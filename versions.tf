terraform {
  required_version = ">= 1.9.0"

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.31.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.6.2"
    }
    template = {
      source  = "hashicorp/template"
      version = ">= 2.2.0"
    }
  }
}
