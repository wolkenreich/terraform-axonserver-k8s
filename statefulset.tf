resource "kubernetes_stateful_set" "axonserver" {
  count = var.nodes_number

  metadata {
    name      = "${var.cluster_name}-${count.index + 1}"
    namespace = kubernetes_namespace.as_demo.id

    labels = {
      app     = "${var.cluster_name}-${count.index + 1}"
      cluster = var.cluster_name
    }
  }

  spec {
    service_name = "${var.cluster_name}-${count.index + 1}"
    replicas     = 1

    selector {
      match_labels = {
        app     = "${var.cluster_name}-${count.index + 1}"
        cluster = var.cluster_name
      }
    }

    template {
      metadata {
        labels = {
          app     = "${var.cluster_name}-${count.index + 1}"
          cluster = var.cluster_name
        }
      }

      spec {
        #security_context {
        #  run_as_user = 1001
        #  fs_group    = 1001
        #}

        termination_grace_period_seconds = 120

        container {
          name              = "${var.cluster_name}-${count.index + 1}"
          image             = "axoniq/axonserver:latest-jdk-11"
          image_pull_policy = "IfNotPresent"

          resources {
            limits = {
              cpu    = "1"
              memory = "1Gi"
            }
            requests = {
              cpu    = "1"
              memory = "1Gi"
            }
          }

          port {
            name           = "gui"
            container_port = 8024
            protocol       = "TCP"
          }

          port {
            name           = "client-grpc"
            container_port = 8124
            protocol       = "TCP"
          }

          port {
            name           = "internal-grpc"
            container_port = 8224
            protocol       = "TCP"
          }

          env {
            name  = "AXONIQ_AXONSERVER_NAME"
            value = "${var.cluster_name}-${count.index + 1}"
          }

          env {
            name  = "AXONIQ_AXONSERVER_HOSTNAME"
            value = "${var.cluster_name}-${count.index + 1}"
          }

          volume_mount {
            name       = "data"
            mount_path = "/axonserver/data"
          }

          volume_mount {
            name       = "events"
            mount_path = "/axonserver/events"
          }

          volume_mount {
            name       = "log"
            mount_path = "/axonserver/logs"
          }

          volume_mount {
            name       = "plugins"
            mount_path = "/axonserver/plugins"
          }

          volume_mount {
            name       = "config"
            mount_path = "/axonserver/config"
            read_only  = true
          }

          volume_mount {
            name       = "system-token"
            mount_path = "/axonserver/security"
            read_only  = true
          }

          volume_mount {
            name       = "license"
            mount_path = "/axonserver/license"
            read_only  = true
          }

          startup_probe {
            http_get {
              path   = "/actuator/info"
              port   = 8024
              scheme = "HTTP"
            }

            initial_delay_seconds = 30
            period_seconds        = 5
            timeout_seconds       = 1
            failure_threshold     = 110
          }

          readiness_probe {
            http_get {
              path   = "/actuator/info"
              port   = 8024
              scheme = "HTTP"
            }

            initial_delay_seconds = 5
            period_seconds        = 5
            timeout_seconds       = 1
            failure_threshold     = 30
          }

          liveness_probe {
            http_get {
              path   = "/actuator/info"
              port   = 8024
              scheme = "HTTP"
            }

            initial_delay_seconds = 5
            period_seconds        = 10
            timeout_seconds       = 1
            failure_threshold     = 3
          }
        }

        volume {
          name = "config"

          config_map {
            name = kubernetes_config_map.axonserver_properties.metadata[0].name
          }
        }

        volume {
          name = "system-token"

          secret {
            secret_name = kubernetes_secret.axonserver_token.metadata[0].name
          }
        }

        volume {
          name = "license"

          secret {
            secret_name = kubernetes_secret.axoniq_license.metadata[0].name
          }
        }

      }
    }

    volume_claim_template {
      metadata {
        name = "events"
      }

      spec {
        access_modes = ["ReadWriteOnce"]

        resources {
          requests = {
            storage = "5Gi"
          }
        }
      }
    }

    volume_claim_template {
      metadata {
        name = "log"
      }

      spec {
        access_modes = ["ReadWriteOnce"]

        resources {
          requests = {
            storage = "2Gi"
          }
        }
      }
    }

    volume_claim_template {
      metadata {
        name = "data"
      }

      spec {
        access_modes = ["ReadWriteOnce"]

        resources {
          requests = {
            storage = "10Gi"
          }
        }
      }
    }

    volume_claim_template {
      metadata {
        name = "plugins"
      }

      spec {
        access_modes = ["ReadWriteOnce"]

        resources {
          requests = {
            storage = "1Gi"
          }
        }
      }
    }

  }
}

