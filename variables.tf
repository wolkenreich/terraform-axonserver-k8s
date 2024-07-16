variable "axonserver_release" {
  description = "Axonserver Release"
  type        = string
  default     = "2024.0.4"
}

variable "namespace" {
  description = "Kubernetes namespace"
  type        = string
  default     = "axonserver"
}

variable "cluster_name" {
  description = "Axon Server cluster name"
  type        = string
  default     = ""
}

variable "nodes_number" {
  description = "number of axonserver nodes"
  type        = number
  default     = 1
}

variable "public_domain" {
  description = "Public domain"
  type        = string
  default     = ""
}

variable "axonserver_license_path" {
  description = "Axon Server license path"
  type        = string
  default     = ""
}

variable "console_authentication" {
  description = "Console Authentication token"
  type        = string
  default     = ""
}
