variable "k8s_host" {
  type = string
}

variable "k8s_client_certificate" {
  type = string
}

variable "k8s_client_key" {
  type = string
}

variable "k8s_cluster_ca_certificate" {
  type = string
}

variable "name" {
  type = string
}

variable "namespace" {
  type    = string
  default = "ingress-nginx"
}

variable "chart" {
  type    = string
  default = "ingress-nginx"
}

variable "repository" {
  type    = string
  default = "https://kubernetes.github.io/ingress-nginx"
}

variable "ingress_version" {
  type    = string
  default = "4.7.1"
}

variable "create_namespace" {
  type    = bool
  default = true
}

variable "values" {
  type = list(string)
  default = [
    <<EOF
controller:
  service:
    annotations:
      service.beta.kubernetes.io/azure-load-balancer-internal: "true"
    type: LoadBalancer
  nodeSelector:
    "kubernetes.io/os": "linux"
  tolerations:
  - key: "node-role.kubernetes.io/control-plane"
    operator: "Exists"
    effect: "NoSchedule"
EOF
  ]
}











