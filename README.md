# Terraform Module to deploy Axon Server on k8s


[Google Cloud](https://img.shields.io/badge/GoogleCloud-%234285F4.svg?style=for-the-badge&logo=google-cloud&logoColor=white) 
![Terraform](https://img.shields.io/badge/terraform-%235835CC.svg?style=for-the-badge&logo=terraform&logoColor=white)

![License](https://badgen.net/github/license/AxonIQ/terraform-axonserver-gke/)
![Release](https://badgen.net/github/release/AxonIQ/terraform-axonserver-gke/)

<p align="center">
  <img height="240" src="https://www.axoniq.io/hs-fs/hubfs/Axon_Server_Enterprise_-_Dark_icon.png?width=239&height=240&name=Axon_Server_Enterprise_-_Dark_icon.png">
  <h3 align="center">Run modern applications seamlessly with zero-configuration message routing and event storage</h3>
</p>

---


## USAGE

```terraform
module "as_demo" {
  source = "git@github.com:AxonIQ/terraform-axonserver-gke.git?ref=v1.0"

  nodes_number  = 3
  cluster_name  = "axonserver"
  public_domain = "axoniq.net"

  axonserver_license_path = file("${path.module}/axonserver.license")
}
```


## Inputs

| Name                                                                                                        | Description                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               | Type                                                                                                                       | Default                          | Required |
|-------------------------------------------------------------------------------------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------|----------------------------------|:--------:|
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name)                                    | Axon Server cluster name.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 | `string`                                                                                                                   | `""`                             |   yes    |
| <a name="input_nodes_number"></a> [nodes\_number](#input\_nodes\_number)                                    | The number of nodes deployed inside the cluster.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          | `number`                                                                                                                   | `1`                              |   yes    |
| <a name="input_public_domain"></a> [public\_domain](#input\_public\_domain)                                 | The domain that is added to the hostname when returning hostnames to client applications.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 | `string`                                                                                                                   | `""`                             |   yes    |
| <a name="input_axonserver_license_path"></a> [axonserver\_license\_path](#input\_axonserver\_license\_path) | The path to the Axon Server license                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       | `string`                                                                                                                   | `""`                             |   yes    |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_axonserver_token"></a> [axonserver\_token](#output\_axonserver\_token) | The Axon Server token, generated by `random_uuid` |

## Providers

| Name                                                       | Version |
|------------------------------------------------------------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | 5.36.0  |
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

<a href="https://github.com/AxonIQ/terraform-axonserver-gke/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=AxonIQ/terraform-axonserver-gke" />
</a>

Made with [contrib.rocks](https://contrib.rocks).
