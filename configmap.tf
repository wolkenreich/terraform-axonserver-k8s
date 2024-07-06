data "template_file" "axonserver_properties" {
  template = file("${path.module}/conf/axonserver.properties.tmpl")

  vars = {
    first_name     = "${var.cluster_name}-1"
    public_domain  = var.public_domain
    namespace      = kubernetes_namespace.as_demo.id
    internal_token = random_uuid.internal_token.result
  }
}

resource "kubernetes_config_map" "axonserver_properties" {
  metadata {
    name      = "axonserver.properties"
    namespace = kubernetes_namespace.as_demo.id
  }

  data = {
    "axonserver.properties" = data.template_file.axonserver_properties.rendered
  }
}
