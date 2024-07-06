resource "kubernetes_namespace" "as_demo" {
  metadata {
    labels = {
      name = "as-demo"
      env  = "prod"
    }

    name = "as-demo"
  }
}

