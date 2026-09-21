locals {
  axonserver_properties = var.axonserver_properties == "" ? templatefile("${path.module}/conf/axonserver.properties.tftpl", {
    first_name              = "${var.cluster_name}-1"
    public_domain           = var.public_domain
    namespace               = var.namespace
    internal_token          = var.internal_token
    devmode_enabled         = var.devmode_enabled
    platform_authentication = var.platform_authentication
    admin_password          = var.admin_password
    accesscontrol_enabled   = var.accesscontrol_enabled
  }) : var.axonserver_properties
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
