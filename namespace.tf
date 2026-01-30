
resource "kubernetes_namespace" "axonserver" {
  count = var.create_namespace ? 1 : 0

  metadata {
    labels = {
      name = var.namespace
    }

    name = var.namespace
  }
}

