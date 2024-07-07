resource "kubernetes_namespace" "as_demo" {
  metadata {
    labels = {
      name = var.namespace
    }

    name = var.namespace
  }
}

