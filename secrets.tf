resource "random_uuid" "token" {
}

resource "random_uuid" "internal_token" {
}

resource "kubernetes_secret" "axonserver_token" {
  metadata {
    name      = "axonserver.token"
    namespace = var.create_namespace ? kubernetes_namespace.axonserver[0].id : data.kubernetes_namespace.axonserver[0].id
  }

  data = {
    "axonserver.token" = random_uuid.token.result
  }

  immutable = true
}

resource "kubernetes_secret" "axoniq_license" {
  count = length(var.console_authentication) > 0 ? 0 : 1
  metadata {
    name      = "axoniq.license"
    namespace = var.create_namespace ? kubernetes_namespace.axonserver[0].id : data.kubernetes_namespace.axonserver[0].id
  }

  data = {
    "axoniq.license" = var.axonserver_license_path
  }
}
