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
module "as_demo" {
  source = "git@github.com:AxonIQ/terraform-axonserver-k8s.git?ref=v1.6"
  
  axonserver_release = "2024.0.4"

  nodes_number  = 3
  cluster_name  = "axonserver"
  public_domain = "axoniq.net"
  namespace     = "axonserver"

  axonserver_license_path = file("${path.module}/axoniq.license")
}
```


## Inputs

| Name                                                                                                        | Description                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               | Type                                                                                                                       | Default                          | Required |
|-------------------------------------------------------------------------------------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------|----------------------------------|:--------:|
| <a name="input_axonserver_release"></a> [axonserver\_release](#input\_axonserver\_release)                  | Axon Server Release namespace.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            | `string`                                                                                                                   | `"2024.0.4"`                     |   yes    |
| <a name="input_namespace"></a> [namespace](#input\_namespace)                                               | Kubernetes cluster namespace.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             | `string`                                                                                                                   | `"axonserver"`                   |   yes    |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name)                                    | Axon Server cluster name.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 | `string`                                                                                                                   | `""`                             |   yes    |
| <a name="input_nodes_number"></a> [nodes\_number](#input\_nodes\_number)                                    | The number of nodes deployed inside the cluster.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          | `number`                                                                                                                   | `1`                              |   yes    |
| <a name="input_public_domain"></a> [public\_domain](#input\_public\_domain)                                 | The domain that is added to the hostname when returning hostnames to client applications.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 | `string`                                                                                                                   | `""`                             |   yes    |
| <a name="input_axonserver_license_path"></a> [axonserver\_license\_path](#input\_axonserver\_license\_path) | The path to the Axon Server license                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     | `string`                                                                                                                   | `""`                             |   yes    |
| <a name="input_console_authentication"></a> [console\_authentication](#input\_console\_authentication)      | Console authentication token license                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    | `string`                                                                                                                   | `""`                             |    no    |

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
