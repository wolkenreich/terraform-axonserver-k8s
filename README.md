# Terraform Module to deploy Axon Server on Kubernetes


![Kubernetes](https://img.shields.io/badge/Kubernetes-3069DE?style=for-the-badge&logo=kubernetes&logoColor=white) 
![Terraform](https://img.shields.io/badge/terraform-%235835CC.svg?style=for-the-badge&logo=terraform&logoColor=white)

![License](https://badgen.net/github/license/AxonIQ/terraform-axonserver-k8s/)
![Release](https://badgen.net/github/release/AxonIQ/terraform-axonserver-k8s/)

<p align="center">
  <img height="240" src="https://www.axoniq.io/hs-fs/hubfs/Axon_Server_Enterprise_-_Dark_icon.png?width=239&height=240&name=Axon_Server_Enterprise_-_Dark_icon.png">
  <h3 align="center">Run modern applications seamlessly with zero-configuration message routing and event storage</h3>
</p>

---


## USAGE

```terraform
module "axonserver" {
  source = "git@github.com:AxonIQ/terraform-axonserver-k8s.git?ref=v1.14"
  
  axonserver_release = "2024.1.4"

  internal_token = var.axonserver_internal_token

  nodes_number  = 3
  cluster_name  = "axonserver"
  public_domain = "axoniq.net"
  namespace     = "axonserver"
  
  axonserver_license_path = file("${path.module}/axoniq.license")
  axonserver_properties   = file("${path.module}/axonserver.properties")
}
```


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_internal_token"></a> [internal\_token](#input\_internal\_token) | Internal access token used by Axon Server for access control between cluster nodes. | `string` | n/a | yes |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Axon Server cluster name. Node, service and StatefulSet names are derived from it as `<cluster_name>-<n>`. | `string` | `""` | no |
| <a name="input_nodes_number"></a> [nodes\_number](#input\_nodes\_number) | The number of nodes deployed inside the cluster. Each node gets its own StatefulSet and headless Service. | `number` | `1` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Kubernetes namespace. | `string` | `"axonserver"` | no |
| <a name="input_create_namespace"></a> [create\_namespace](#input\_create\_namespace) | Create the namespace, or expect an existing one. | `bool` | `true` | no |
| <a name="input_public_domain"></a> [public\_domain](#input\_public\_domain) | The domain that is added to the hostname when returning hostnames to client applications. | `string` | `""` | no |
| <a name="input_axonserver_release"></a> [axonserver\_release](#input\_axonserver\_release) | Axon Server release. Used as the image tag together with `java_version`: `axoniq/axonserver:<release>-jdk-<java_version>`. | `string` | `"2024.1.4"` | no |
| <a name="input_axonserver_license_path"></a> [axonserver\_license\_path](#input\_axonserver\_license\_path) | The Axon Server license **contents** (pass `file(...)`, despite the variable name). Ignored when `console_authentication` is set. | `string` | `""` | no |
| <a name="input_axonserver_properties"></a> [axonserver\_properties](#input\_axonserver\_properties) | The **contents** of an `axonserver.properties` file (pass `file(...)`). When set, it replaces the rendered template entirely, so `internal_token`, `public_domain`, `devmode_enabled` and `accesscontrol_enabled` are no longer applied by this module. | `string` | `""` | no |
| <a name="input_console_authentication"></a> [console\_authentication](#input\_console\_authentication) | AxonIQ Console authentication token. When set, the license is managed through the Console: no license secret is created, the license directory becomes a PVC, and the autocluster properties are omitted. | `string` | `""` | no |
| <a name="input_accesscontrol_enabled"></a> [accesscontrol\_enabled](#input\_accesscontrol\_enabled) | Enable Axon Server access control. | `bool` | `true` | no |
| <a name="input_devmode_enabled"></a> [devmode\_enabled](#input\_devmode\_enabled) | Axon Server devmode. | `bool` | `false` | no |
| <a name="input_java_version"></a> [java\_version](#input\_java\_version) | Java runtime. Must be `17` or `11`. | `number` | `17` | no |
| <a name="input_java_tool_options"></a> [java\_tool\_options](#input\_java\_tool\_options) | Value of the `JAVA_TOOL_OPTIONS` environment variable, used to pass JVM options. | `string` | `""` | no |
| <a name="input_assign_pods_to_different_nodes"></a> [assign\_pods\_to\_different\_nodes](#input\_assign\_pods\_to\_different\_nodes) | Avoid the co-location of the replicas on the same Kubernetes node (preferred pod anti-affinity). | `bool` | `false` | no |
| <a name="input_resources_limits_cpu"></a> [resources\_limits\_cpu](#input\_resources\_limits\_cpu) | spec.container.resources.limits.cpu | `number` | `1` | no |
| <a name="input_resources_limits_memory"></a> [resources\_limits\_memory](#input\_resources\_limits\_memory) | spec.container.resources.limits.memory | `string` | `"1Gi"` | no |
| <a name="input_resources_requests_cpu"></a> [resources\_requests\_cpu](#input\_resources\_requests\_cpu) | spec.container.resources.requests.cpu | `number` | `1` | no |
| <a name="input_resources_requests_memory"></a> [resources\_requests\_memory](#input\_resources\_requests\_memory) | spec.container.resources.requests.memory | `string` | `"1Gi"` | no |
| <a name="input_events_storage"></a> [events\_storage](#input\_events\_storage) | Events PVC storage. | `string` | `"5Gi"` | no |
| <a name="input_log_storage"></a> [log\_storage](#input\_log\_storage) | Log PVC storage. | `string` | `"2Gi"` | no |
| <a name="input_data_storage"></a> [data\_storage](#input\_data\_storage) | Data PVC storage. | `string` | `"10Gi"` | no |
| <a name="input_plugins_storage"></a> [plugins\_storage](#input\_plugins\_storage) | Plugins PVC storage. | `string` | `"1Gi"` | no |
| <a name="input_license_storage"></a> [license\_storage](#input\_license\_storage) | License PVC storage. Only used when `console_authentication` is set. | `string` | `"1Gi"` | no |

`internal_token` is the only variable without a default. `cluster_name` and `public_domain` default to an empty string, which is accepted by Terraform but does not produce a usable deployment, so set them in practice.


## Outputs

| Name | Description |
|------|-------------|
| <a name="output_axonserver_token"></a> [axonserver\_token](#output\_axonserver\_token) | The Axon Server token, generated by `random_uuid` |

## Providers

| Name                                                       | Version |
|------------------------------------------------------------|---------|
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | 2.31.0  |
| <a name="provider_random"></a> [random](#provider\_random)             | 3.6.2   |
| <a name="provider_template"></a> [template](#provider\_template)       | 2.2.0   |

## Requirements

| Name                                                                      | Version  |
|---------------------------------------------------------------------------|----------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.9.0 |


## LICENSE

Apache 2 Licensed. See [LICENSE](LICENSE) for full details.

## AUTHORS

<a href="https://github.com/AxonIQ/terraform-axonserver-k8s/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=AxonIQ/terraform-axonserver-k8s" />
</a>

Made with [contrib.rocks](https://contrib.rocks).
