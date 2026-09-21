# 001 - Rebase the fork onto upstream v1.22

Date: 2026-09-21
Status: Done

## Context

The fork was created from `AxonIQ/terraform-axonserver-k8s` at **v1.14** (`0246db6`). By September 2026 upstream had reached **v1.22** (`00bc29e`): 25 commits, spanning October 2025 to August 2026. Ten fork-local commits sat on top of the old base, and both sides had edited the same files.

A trial merge conflicted in four of the seven `.tf` files (`configmap.tf`, `services.tf`, `statefulset.tf`, `variables.tf`). Four of the ten fork commits had meanwhile become redundant, because upstream implemented the same thing independently:

| Fork commit | Superseded by |
|---|---|
| `2e2d7b0` service port 8024 | upstream `81bccce` (port named `axonserver` instead of `gui`) |
| `88e46e9` `accesscontrol_enabled` | upstream `923e2ee` |
| `7ce7ecb` `java_tool_options` | upstream (same variable) |
| `68705b7` (templatefile half) | upstream `c478f5a` |

Upstream also fixed a real bug the fork still carried: the Prometheus scrape annotation pointed at port 8081, which the service does not expose and Axon Server does not serve (actuator is on 8024).

## Decision

Re-fork rather than merge or rebase: branch from `upstream/main` and re-apply only the deviations that are still needed, as fresh commits. Then reset `master` to that branch and force-push, with the previous history preserved on `backup/master-pre-rebase-v1.22` (pushed to `origin`).

Replaying the ten commits with `git rebase` was rejected: four of them are obsolete, and the fifth (`68705b7`) would have had to be resolved against files upstream had rewritten.

## What the fork still deviates in

1. **`internal_token` is an input variable** instead of a `random_uuid` generated inside the module, so the caller owns the token.
2. **Resources reference `var.namespace` directly**, not `kubernetes_namespace.axonserver[0].id` or a `kubernetes_namespace` data source. Resolving it that way made every apply propose a redeploy. Trade-off: nothing depends on the namespace resource, so with `create_namespace = true` Terraform does not order its creation before the resources inside it.
3. **`cloud.google.com/neg` is excluded from drift detection.** GKE writes the annotation itself. Upstream's alternative (`gke_neg` / `gke_neg_zone` variables) was not adopted; it also writes `cloud.google.com/neg-status`, which is controller-owned.
4. **Upstream's `run` label was dropped** from the service and stateful set selectors. `spec.selector` is immutable on a StatefulSet, so adopting it would force a replacement of every node. PVCs would survive (they are not in Terraform state and are retained), but the cluster would go down. Dropping the label turns the rollout into a rolling restart.

Plus fork-only tooling: `.lighthouse/` pipelines, `.project`, the `.idea` entry in `.gitignore`.

## Consequences for callers

Root modules must be updated before they can move to the new tag:

- `console_authentication` renamed to `platform_authentication`, and the mechanism changed: the `AXONIQ_CONSOLE_AUTHENTICATION` environment variable is gone, replaced by the `axoniq.platform.authentication` property.
- `axonserver_release` + `java_version` replaced by `axonserver_image` + `axonserver_tag`. The tag default is `latest`, so an explicit tag must be passed to keep pinning.
- The service port `gui` is now named `axonserver` (still 8024). Anything addressing the port by name breaks.
- The log mount moved from `/axonserver/logs` to `/axonserver/log`.

Gained for free: the Prometheus port fix, `sensitive = true` on the token output, `image_pull_policy`, `admin_password`, preconditions for clustering and NEG zones, and the removal of the unused `template` provider.

## Follow-up

- The README usage examples still point at `git@github.com:AxonIQ/...?ref=v1.20`. The fork's own repository URL and tagging scheme (Jenkins X currently produces `v0.0.x`) have not been decided.
- The module still uses the deprecated resource names (`kubernetes_config_map` rather than `kubernetes_config_map_v1`), which the 3.x kubernetes provider warns about on every validate. Migrating is a separate piece of work.

## Next sync with upstream

`git fetch upstream` and compare against `upstream/main`, not against `original-source` — that branch is stale at v1.14. Check any upstream change against the four deviations above; upstream has repeatedly re-introduced what the fork removed.
