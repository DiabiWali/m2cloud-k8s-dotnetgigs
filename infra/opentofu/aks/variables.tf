variable "resource_group_name" {
  type    = string
  default = "rg-m2cloud-k8s"
}

variable "location" {
  type    = string
  default = "francecentral"
}

variable "cluster_name" {
  type    = string
  default = "aks-m2cloud"
}

variable "node_count" {
  type    = number
  default = 3
}

variable "node_vm_size" {
  type    = string
  default = "Standard_B2ms"
}
