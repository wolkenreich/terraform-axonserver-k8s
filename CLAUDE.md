# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

Reusable Terraform module that deploys an Axon Server cluster onto Kubernetes. Fork of `AxonIQ/terraform-axonserver-k8s`, currently based on upstream **v1.22**.

This repo is a **module only** — there is no backend, no root-level `.tfvars`, and no provider configuration. It is consumed as:

```terraform
module "axonserver" {
  source         = "git@github.com:wolkenreich/terraform-axonserver-k8s.git?ref=<tag>"
  cluster_name   = "axonserver"
  nodes_number   = 3
  namespace      = "axonserver"
  public_domain  = "example.net"
  internal_token = "<uuid>"
  axonserver_tag = "2025.1.5-jdk-17"
}
```

## Commands

```bash
terraform init -backend=false
terraform validate      # the check CI runs; expect "deprecated resource" warnings (see below)
terraform fmt -recursive
```

There are no tests. `terraform plan`/`apply` cannot be run from this repo — it requires a root module that configures the `kubernetes` provider and a reachable cluster. CI (`.lighthouse/jenkins-x/release.yaml`) runs `terraform init && terraform validate` in `hashicorp/terraform:1.14`; the PR pipeline runs the build pack's `lint` step.

`terraform validate` warns that `kubernetes_config_map`, `kubernetes_secret` and friends are deprecated in favour of the `_v1` names. That is pre-existing upstream, not something a change introduced — it surfaces because the kubernetes provider now resolves to 3.x. Both provider constraints in `versions.tf` are bounded below the next major (`< 4.0.0`); keep them bounded, since a child module's constraints are inherited by every caller.

## Architecture

**One StatefulSet per node, not one StatefulSet with N replicas.** `services.tf` and `statefulset.tf` both use `count = var.nodes_number`, producing `${cluster_name}-1 … -N`, each StatefulSet with `replicas = 1` and a matching headless Service (`cluster_ip = "None"`). Axon Server nodes need stable, individually addressable DNS names (`AXONIQ_AXONSERVER_HOSTNAME`), so anything touching node identity must keep the `${var.cluster_name}-${count.index + 1}` naming and the `app` / `cluster` label pair consistent across service, statefulset, selector and pod template — the anti-affinity rule and Prometheus scrape annotations key off them.

`spec.selector` is immutable on a StatefulSet: adding or removing a label there forces Terraform to replace every node. PVCs are not in Terraform state and are retained, so data survives, but the cluster goes down. This is why the fork does not carry upstream's `run` label.

**Cluster bootstrap** happens through `conf/axonserver.properties.tftpl`, rendered in `configmap.tf` via `templatefile()` and mounted read-only at `/axonserver/config`. Node 1 (`${cluster_name}-1`) is hardcoded as the autocluster seed. Passing `axonserver_properties` replaces the rendered template wholesale — all template variables (`internal_token`, `public_domain`, `devmode_enabled`, `admin_password`, …) are then the caller's responsibility.

**`platform_authentication` is a mode switch, not just a value.** A non-empty value means AxonIQ Platform manages the license, and it flips behaviour in three files at once:

| | `platform_authentication == ""` | non-empty |
|---|---|---|
| `secrets.tf` | creates `axoniq.license` secret from `axonserver_license_path` | no secret |
| `statefulset.tf` | `license` volume = that secret, mounted read-only | `license` volume_claim_template (PVC), writable |
| properties template | emits `autocluster.first` / `autocluster.contexts` | omits them; emits `axoniq.platform.authentication` |

Changing this variable on a live deployment swaps a secret-backed mount for a PVC, so it is a destructive change.

Despite their names, `axonserver_license_path` and `axonserver_properties` carry file **contents** (callers pass `file(...)`), not paths.

**State-sensitive resources:** `kubernetes_secret.axonserver_token` is `immutable = true` (any change forces replacement, and the token is the module's only output); `volume_claim_template` blocks cannot be resized in place by the Kubernetes provider.

## Relationship to upstream

Remotes: `origin` = `wolkenreich/terraform-axonserver-k8s`, `upstream` = `AxonIQ/terraform-axonserver-k8s`.

`master` was rebuilt on upstream v1.22 in September 2026, replacing a divergence that had grown from the old v1.14 fork point. The pre-rebase history is preserved on `backup/master-pre-rebase-v1.22` (local and on `origin`). The `original-source` branch is stale — it still points at v1.14; use `upstream/main` for comparisons.

The fork delta is six commits on top of `upstream/main`: four functional deviations, one restoring the fork-only `.lighthouse/` pipelines, `.project` and the `.idea` entry in `.gitignore`, and one documenting them. The README's "Differences from upstream" section lists the functional four. The one worth repeating here, because it looks like an omission: **resources reference `var.namespace` directly** instead of `kubernetes_namespace.axonserver[0].id` / a `kubernetes_namespace` data source, because resolving it that way made every apply propose a redeploy. The trade-off is that nothing depends on the namespace resource, so with `create_namespace = true` Terraform does not order its creation before the resources inside it.

When pulling upstream changes, check them against these four before merging — upstream has repeatedly re-introduced what the fork removed.

[Record 001](docs/records/001-rebase-onto-upstream-v1.22.md) documents the rebase: what was superseded, what was kept and why, and which renames callers have to follow.

## CI / Release

Jenkins X + Lighthouse (Tekton). `triggers.yaml` maps presubmits to `pullrequest.yaml` and postsubmits on `main`/`master` to `release.yaml`, which computes the next version, validates, generates a changelog and promotes. **Any push to `master` triggers a release build.** Consumers pin the module by git tag, so a release is what makes a change consumable.
