locals {
  axonserver_properties = var.axonserver_properties != "" ? var.axonserver_properties : templatefile("${path.module}/conf/axonserver.properties.tftpl", {
    first_name             = "${var.cluster_name}-1"
    public_domain          = var.public_domain
    namespace              = var.namespace
    internal_token         = var.internal_token
    devmode_enabled        = var.devmode_enabled
    console_authentication = var.console_authentication
    accesscontrol_enabled  = var.accesscontrol_enabled
  })
}

resource "kubernetes_config_map" "axonserver_properties" {
  metadata {
    name      = "axonserver.properties"
    namespace = var.namespace
  }

  data = {
    "axonserver.properties" = local.axonserver_properties
  }
}
