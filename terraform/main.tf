# Terraform Main Configuration - Infrastructure DevSecOps

terraform {
  required_version = ">= 1.0"
  
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.25"
    }
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.2"
    }
  }

  # Configuration backend pour état distant
  # Décommenter et configurer pour production
  # backend "s3" {
  #   bucket         = "terraform-state"
  #   key            = "prediction-app/terraform.tfstate"
  #   region         = "us-east-1"
  #   encrypt        = true
  #   dynamodb_table = "terraform-lock"
  # }

  backend "local" {
    path = ".terraform/tfstate"
  }
}

# =====================================================================
# Providers Configuration
# =====================================================================

provider "kubernetes" {
  config_path = var.kubeconfig_path
  
  client_certificate     = var.client_certificate
  client_key             = var.client_key
  cluster_ca_certificate = var.cluster_ca_certificate
  host                   = var.kubernetes_host
}

provider "docker" {
  host = var.docker_host
}

# =====================================================================
# Locals
# =====================================================================

locals {
  app_name      = "prediction-app"
  app_version   = "1.0.0"
  environment   = var.environment
  namespace     = "prediction-app"
  labels = {
    app         = local.app_name
    environment = local.environment
    managed-by  = "terraform"
    version     = local.app_version
  }
}

# =====================================================================
# Kubernetes Namespace
# =====================================================================

resource "kubernetes_namespace" "app" {
  metadata {
    name = local.namespace
    labels = merge(
      local.labels,
      {
        pod-security = "restricted"
      }
    )
  }
}

# =====================================================================
# ConfigMaps
# =====================================================================

resource "kubernetes_config_map" "app" {
  metadata {
    name      = "app-config"
    namespace = kubernetes_namespace.app.metadata[0].name
    labels    = local.labels
  }

  data = {
    ENVIRONMENT    = var.environment
    LOG_LEVEL      = var.log_level
    APP_NAME       = local.app_name
    APP_VERSION    = local.app_version
    API_HOST       = "0.0.0.0"
    API_PORT       = tostring(var.app_port)
    DB_HOST        = var.db_host
    DB_PORT        = tostring(var.db_port)
    DB_NAME        = var.db_name
  }
}

# =====================================================================
# Secrets
# =====================================================================

resource "kubernetes_secret" "app" {
  metadata {
    name      = "app-secrets"
    namespace = kubernetes_namespace.app.metadata[0].name
    labels    = local.labels
  }

  type = "Opaque"

  data = {
    SECRET_KEY = base64encode(var.secret_key)
    DB_USER    = base64encode(var.db_user)
    DB_PASS    = base64encode(var.db_pass)
    API_KEY    = base64encode(var.api_key)
  }

  sensitive = true
}

# =====================================================================
# Service Account & RBAC
# =====================================================================

resource "kubernetes_service_account" "app" {
  metadata {
    name      = "app-sa"
    namespace = kubernetes_namespace.app.metadata[0].name
    labels    = local.labels
  }
}

resource "kubernetes_role" "app" {
  metadata {
    name      = "app-role"
    namespace = kubernetes_namespace.app.metadata[0].name
    labels    = local.labels
  }

  rule {
    api_groups = [""]
    resources  = ["configmaps"]
    verbs      = ["get", "list", "watch"]
  }

  rule {
    api_groups = [""]
    resources  = ["secrets"]
    verbs      = ["get", "list"]
  }

  rule {
    api_groups = [""]
    resources  = ["pods"]
    verbs      = ["get", "list"]
  }
}

resource "kubernetes_role_binding" "app" {
  metadata {
    name      = "app-rolebinding"
    namespace = kubernetes_namespace.app.metadata[0].name
    labels    = local.labels
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = kubernetes_role.app.metadata[0].name
  }

  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.app.metadata[0].name
    namespace = kubernetes_namespace.app.metadata[0].name
  }
}

# =====================================================================
# Deployment
# =====================================================================

resource "kubernetes_deployment" "app" {
  metadata {
    name      = local.app_name
    namespace = kubernetes_namespace.app.metadata[0].name
    labels    = local.labels
  }

  spec {
    replicas = var.app_replicas

    strategy {
      type = "RollingUpdate"
      rolling_update {
        max_surge       = 1
        max_unavailable = 0
      }
    }

    selector {
      match_labels = local.labels
    }

    template {
      metadata {
        labels = local.labels
      }

      spec {
        service_account_name = kubernetes_service_account.app.metadata[0].name

        security_context {
          run_as_non_root = true
          run_as_user     = 1000
          fs_group        = 1000
        }

        # Init container
        init_container {
          name  = "db-migration"
          image = var.app_image

          env_from {
            config_map_ref {
              name = kubernetes_config_map.app.metadata[0].name
            }
          }
        }

        # Main container
        container {
          name  = "app"
          image = var.app_image

          port {
            name           = "http"
            container_port = var.app_port
            protocol       = "TCP"
          }

          env_from {
            config_map_ref {
              name = kubernetes_config_map.app.metadata[0].name
            }
          }

          env {
            name = "SECRET_KEY"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.app.metadata[0].name
                key  = "SECRET_KEY"
              }
            }
          }

          env {
            name = "DB_USER"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.app.metadata[0].name
                key  = "DB_USER"
              }
            }
          }

          env {
            name = "DB_PASS"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.app.metadata[0].name
                key  = "DB_PASS"
              }
            }
          }

          resources {
            requests = {
              cpu    = var.app_cpu_request
              memory = var.app_memory_request
            }
            limits = {
              cpu    = var.app_cpu_limit
              memory = var.app_memory_limit
            }
          }

          liveness_probe {
            http_get {
              path   = "/healthz"
              port   = "http"
              scheme = "HTTP"
            }
            initial_delay_seconds = 30
            period_seconds        = 10
            timeout_seconds       = 5
            failure_threshold     = 3
          }

          readiness_probe {
            http_get {
              path   = "/"
              port   = "http"
              scheme = "HTTP"
            }
            initial_delay_seconds = 10
            period_seconds        = 5
            timeout_seconds       = 3
            failure_threshold     = 2
          }

          security_context {
            allow_privilege_escalation = false
            read_only_root_filesystem  = true
            capabilities {
              drop = ["ALL"]
            }
          }

          volume_mount {
            name       = "logs"
            mount_path = "/var/log/app"
          }

          volume_mount {
            name       = "tmp"
            mount_path = "/tmp"
          }
        }

        volume {
          name = "logs"
          empty_dir {}
        }

        volume {
          name = "tmp"
          empty_dir {}
        }

        termination_grace_period_seconds = 30
        dns_policy                       = "ClusterFirst"
      }
    }
  }

  depends_on = [
    kubernetes_namespace.app,
    kubernetes_config_map.app,
    kubernetes_secret.app
  ]
}

# =====================================================================
# Service
# =====================================================================

resource "kubernetes_service" "app" {
  metadata {
    name      = local.app_name
    namespace = kubernetes_namespace.app.metadata[0].name
    labels    = local.labels
  }

  spec {
    type = "ClusterIP"

    selector = local.labels

    port {
      name        = "http"
      port        = var.app_port
      target_port = "http"
      protocol    = "TCP"
    }
  }
}

# NodePort Service for local development
resource "kubernetes_service" "app_nodeport" {
  metadata {
    name      = "${local.app_name}-nodeport"
    namespace = kubernetes_namespace.app.metadata[0].name
    labels    = local.labels
  }

  spec {
    type = "NodePort"

    selector = local.labels

    port {
      name        = "http"
      port        = var.app_port
      target_port = "http"
      node_port   = 30501
      protocol    = "TCP"
    }
  }
}

# =====================================================================
# HorizontalPodAutoscaler
# =====================================================================

resource "kubernetes_horizontal_pod_autoscalev2" "app" {
  metadata {
    name      = "${local.app_name}-hpa"
    namespace = kubernetes_namespace.app.metadata[0].name
    labels    = local.labels
  }

  spec {
    scale_target_ref {
      api_version = "apps/v1"
      kind        = "Deployment"
      name        = kubernetes_deployment.app.metadata[0].name
    }

    min_replicas = var.app_min_replicas
    max_replicas = var.app_max_replicas

    metric {
      type = "Resource"
      resource {
        name = "cpu"
        target {
          type                = "Utilization"
          average_utilization = 70
        }
      }
    }

    metric {
      type = "Resource"
      resource {
        name = "memory"
        target {
          type                = "Utilization"
          average_utilization = 80
        }
      }
    }

    behavior {
      scale_down {
        stabilization_window_seconds = 300
        policy {
          type          = "Percent"
          value         = 50
          period_seconds = 60
        }
      }
      scale_up {
        stabilization_window_seconds = 0
        policy {
          type          = "Percent"
          value         = 100
          period_seconds = 30
        }
        policy {
          type          = "Pods"
          value         = 2
          period_seconds = 60
        }
      }
    }
  }
}

# =====================================================================
# NetworkPolicy
# =====================================================================

resource "kubernetes_network_policy" "app" {
  metadata {
    name      = "${local.app_name}-netpol"
    namespace = kubernetes_namespace.app.metadata[0].name
    labels    = local.labels
  }

  spec {
    pod_selector {
      match_labels = local.labels
    }

    policy_types = ["Ingress", "Egress"]

    # Ingress: Allow from Nginx
    ingress {
      from {
        pod_selector {
          match_labels = {
            app = "nginx"
          }
        }
      }
      ports {
        port     = "http"
        protocol = "TCP"
      }
    }

    # Egress: Allow DNS
    egress {
      to {
        namespace_selector {}
      }
      ports {
        port     = "53"
        protocol = "UDP"
      }
    }

    # Egress: Allow to database
    egress {
      to {
        pod_selector {
          match_labels = {
            app = "postgres"
          }
        }
      }
      ports {
        port     = "5432"
        protocol = "TCP"
      }
    }
  }
}

# =====================================================================
# Resource Quota
# =====================================================================

resource "kubernetes_resource_quota" "app" {
  metadata {
    name      = "${local.app_name}-quota"
    namespace = kubernetes_namespace.app.metadata[0].name
  }

  spec {
    hard = {
      "requests.cpu"    = "4"
      "requests.memory" = "4Gi"
      "limits.cpu"      = "8"
      "limits.memory"   = "8Gi"
      "pods"            = "20"
    }
  }
}

# =====================================================================
# Outputs
# =====================================================================

output "namespace" {
  value       = kubernetes_namespace.app.metadata[0].name
  description = "Kubernetes namespace"
}

output "service_name" {
  value       = kubernetes_service.app.metadata[0].name
  description = "Service name"
}

output "service_ip" {
  value       = kubernetes_service.app.spec[0].cluster_ip
  description = "Service Cluster IP"
}

output "app_url" {
  value       = "http://${var.app_host}:${var.app_port}"
  description = "Application URL"
}
