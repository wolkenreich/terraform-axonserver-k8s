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
