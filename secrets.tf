resource "random_uuid" "token" {
}

resource "random_uuid" "internal_token" {
}

resource "kubernetes_secret" "axonserver_token" {
  metadata {
    name      = "axonserver.token"
    namespace = kubernetes_namespace.as_demo.id
  }

  data = {
    "axonserver.token" = random_uuid.token.result
  }

  immutable = true
}

resource "kubernetes_secret" "axonserver_license" {
  metadata {
    name      = "axonserver.license"
    namespace = kubernetes_namespace.as_demo.id
  }

  data = {
    "axonserver.license" = var.axonserver_license_path
  }
}
