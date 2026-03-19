# Terraform Outputs

output "kubernetes_namespace" {
  value       = kubernetes_namespace.app.metadata[0].name
  description = "Kubernetes namespace name"
}

output "deployment_name" {
  value       = kubernetes_deployment.app.metadata[0].name
  description = "Deployment name"
}

output "service_name" {
  value       = kubernetes_service.app.metadata[0].name
  description = "Kubernetes service name"
}

output "service_cluster_ip" {
  value       = kubernetes_service.app.spec[0].cluster_ip
  description = "Service Cluster IP"
}

output "service_nodeport" {
  value       = try(kubernetes_service.app_nodeport.spec[0].port[0].node_port, null)
  description = "NodePort number for local access"
}

output "app_url_local" {
  value       = "http://localhost:30501"
  description = "Application URL for local development"
}

output "hpa_name" {
  value       = kubernetes_horizontal_pod_autoscalev2.app.metadata[0].name
  description = "HorizontalPodAutoscaler name"
}

output "kubectl_commands" {
  value = {
    get_pods           = "kubectl get pods -n ${kubernetes_namespace.app.metadata[0].name} -l app=prediction-app"
    get_deployment     = "kubectl get deployment -n ${kubernetes_namespace.app.metadata[0].name} ${kubernetes_deployment.app.metadata[0].name}"
    get_service        = "kubectl get service -n ${kubernetes_namespace.app.metadata[0].name}"
    port_forward       = "kubectl port-forward -n ${kubernetes_namespace.app.metadata[0].name} svc/${kubernetes_service.app.metadata[0].name} 8501:8501"
    logs               = "kubectl logs -n ${kubernetes_namespace.app.metadata[0].name} -l app=prediction-app -f"
    describe_pod       = "kubectl describe pod -n ${kubernetes_namespace.app.metadata[0].name} <pod-name>"
  }
  description = "Useful kubectl commands"
}

output "terraform_state" {
  value = {
    backend = "local"
    path    = ".terraform/tfstate"
  }
  description = "Terraform state configuration"
}

output "summary" {
  value = <<-EOT
    ✅ Infrastructure Terraform déployée avec succès!
    
    📦 Ressources créées:
    - Namespace: ${kubernetes_namespace.app.metadata[0].name}
    - Deployment: ${kubernetes_deployment.app.metadata[0].name}
    - Service: ${kubernetes_service.app.metadata[0].name}
    - HPA: Scaling de ${var.app_min_replicas} à ${var.app_max_replicas} replicas
    
    🔗 Accès:
    - URL locale: http://localhost:30501
    - Port-forward: kubectl port-forward svc/prediction-app 8501:8501
    
    📊 Vérification:
    - kubectl get pods -n ${kubernetes_namespace.app.metadata[0].name}
    - kubectl get hpa -n ${kubernetes_namespace.app.metadata[0].name}
    
    🔐 Secrets et ConfigMap créés
    - ConfigMap: app-config
    - Secrets: app-secrets
    
    ⚙️ RBAC configuré
    - ServiceAccount: app-sa
    - Role & RoleBinding
    
    🌐 NetworkPolicy appliquée
    - Ingress restreint
    - Egress contrôlé
  EOT
  
  description = "Deployment summary"
}
