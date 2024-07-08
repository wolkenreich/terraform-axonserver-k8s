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

resource "kubernetes_secret" "axoniq_license" {
  count = length(var.console_authentication) > 0 ? [] : [1]
  metadata {
    name      = "axoniq.license"
    namespace = kubernetes_namespace.as_demo.id
  }

  data = {
    "axoniq.license" = var.axonserver_license_path
  }
}
