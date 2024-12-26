variable "name" {
  description = "(Required) The name of the Managed Kubernetes Cluster to create. Changing this forces a new resource to be created."
  type        = string
}

variable "location" {
  description = "(Required) The location where the Managed Kubernetes Cluster should be created. Changing this forces a new resource to be created."
  type        = string
  default     = "West Europe"
}

variable "resource_group_name" {
  description = "(Required) Specifies the Resource Group where the Managed Kubernetes Cluster should exist. Changing this forces a new resource to be created."
  type        = string
}

variable "default_node_pool" {
  description = "(Required) Specifies configuration for 'System' mode node pool."
  type = object({
    name           = string
    vm_size = optional(string, "Standard_D2_v2")
    node_count = optional(number, 1)
    vnet_subnet_id = string
  })
}

variable "private_cluster_enabled" {
  description = "(Optional) Should this Kubernetes Cluster have its API server only exposed on internal IP addresses? This provides a Private IP Address for the Kubernetes API on the Virtual Network where the Kubernetes Cluster is located."
  type        = bool
  default     = true
}

variable "identity" {
  description = "(Required) Specifies the type of Managed Service Identity that should be configured on this Kubernetes Cluster. Possible values are SystemAssigned or UserAssigned."
  type        = string
  default     = "SystemAssigned"
}

variable "dns_prefix" {
  description = "(Optional) Specifies the DNS prefix to use with private clusters. Changing this forces a new resource to be created."
  type        = string
}

variable "service_cidr" {
  description = "The Network Range used by the Kubernetes service. Changing this forces a new resource to be created."
  type        = string
}

variable "dns_service_ip" {
  description = "IP address within the Kubernetes service address range that will be used by cluster service discovery (kube-dns). Changing this forces a new resource to be created."
  type        = string
}

variable "network_plugin" {
  description = "(Required) Network plugin to use for networking. Currently supported values are azure, kubenet and none. Changing this forces a new resource to be created."
  type        = string
  default     = "azure"
}

variable "nginx_ingress_name" {
  type = string
}

variable "nginx_ingress_namespace" {
  type    = string
  default = "ingress-nginx"
}

variable "nginx_ingress_chart" {
  type    = string
  default = "ingress-nginx"
}

variable "nginx_ingress_repository" {
  type    = string
  default = "https://kubernetes.github.io/ingress-nginx"
}

variable "nginx_ingress_version" {
  type    = string
  default = "4.7.1"
}

variable "nginx_ingress_create_namespace" {
  type    = bool
  default = true
}

variable "nginx_ingress_values" {
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











