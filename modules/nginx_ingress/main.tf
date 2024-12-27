provider "kubernetes" {
  host = var.k8s_host
  client_certificate = base64decode(var.k8s_client_certificate)
  client_key = base64decode(var.k8s_client_key)
  cluster_ca_certificate = base64decode(var.k8s_cluster_ca_certificate)
}

provider "helm" {
  kubernetes {
    host = var.k8s_host
    client_certificate = base64decode(var.k8s_client_certificate)
    client_key = base64decode(var.k8s_client_key)
    cluster_ca_certificate = base64decode(var.k8s_cluster_ca_certificate)
  }
}

resource "helm_release" "nginx_ingress" {
  name             = var.name
  namespace        = var.namespace
  chart            = var.chart
  repository       = var.repository
  version          = var.ingress_version
  create_namespace = var.create_namespace
  values           = var.values
}