# Terraform Variables

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "development"
}

variable "kubeconfig_path" {
  description = "Path to Kubernetes configuration file"
  type        = string
  default     = "~/.kube/config"
}

variable "kubernetes_host" {
  description = "Kubernetes API server host"
  type        = string
  default     = null
}

variable "client_certificate" {
  description = "Client certificate for Kubernetes"
  type        = string
  default     = null
}

variable "client_key" {
  description = "Client key for Kubernetes"
  type        = string
  default     = null
  sensitive   = true
}

variable "cluster_ca_certificate" {
  description = "CA certificate for Kubernetes"
  type        = string
  default     = null
}

variable "docker_host" {
  description = "Docker daemon host"
  type        = string
  default     = "unix:///var/run/docker.sock"
}

# Application Configuration
variable "app_name" {
  description = "Application name"
  type        = string
  default     = "prediction-app"
}

variable "app_image" {
  description = "Docker image for application"
  type        = string
  default     = "prediction-app:latest"
}

variable "app_port" {
  description = "Application port"
  type        = number
  default     = 8501
}

variable "app_host" {
  description = "Application host"
  type        = string
  default     = "localhost"
}

variable "app_replicas" {
  description = "Number of application replicas"
  type        = number
  default     = 2
}

variable "app_min_replicas" {
  description = "Minimum replicas for HPA"
  type        = number
  default     = 2
}

variable "app_max_replicas" {
  description = "Maximum replicas for HPA"
  type        = number
  default     = 5
}

# Resource Requests and Limits
variable "app_cpu_request" {
  description = "CPU request for application"
  type        = string
  default     = "250m"
}

variable "app_memory_request" {
  description = "Memory request for application"
  type        = string
  default     = "256Mi"
}

variable "app_cpu_limit" {
  description = "CPU limit for application"
  type        = string
  default     = "500m"
}

variable "app_memory_limit" {
  description = "Memory limit for application"
  type        = string
  default     = "512Mi"
}

# Database Configuration
variable "db_host" {
  description = "Database host"
  type        = string
  default     = "postgres"
}

variable "db_port" {
  description = "Database port"
  type        = number
  default     = 5432
}

variable "db_name" {
  description = "Database name"
  type        = string
  default     = "prediction_db"
}

variable "db_user" {
  description = "Database username"
  type        = string
  sensitive   = true
  default     = "appuser"
}

variable "db_pass" {
  description = "Database password"
  type        = string
  sensitive   = true
}

# Security
variable "secret_key" {
  description = "Secret key for application"
  type        = string
  sensitive   = true
}

variable "api_key" {
  description = "API key"
  type        = string
  sensitive   = true
}

# Logging
variable "log_level" {
  description = "Logging level"
  type        = string
  default     = "INFO"
}

# Tags & Labels
variable "common_tags" {
  description = "Common tags for all resources"
  type        = map(string)
  default = {
    Managed = "Terraform"
    Project = "DevSecOps"
  }
}
