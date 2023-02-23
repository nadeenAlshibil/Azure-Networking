variable "name" {
  type        = string
  description = "Name of the deployment"
  default = "NetSecLab"
}

variable "environment" {
  type        = string
  description = "Name of the environment"
  default     = "dev"
}

variable "location" {
  type        = string
  description = "Location of the resources"
  default     = "northeurope"
}

#FW
variable "vnetfw_address_space" {
  type        = list(string)
  description = "Address space of the firewall virtual network"
  default     = ["10.0.0.0/16"]
}

variable "subnetfw_address_space" {
  type        = list(string)
  description = "Address space of the firewall subnet"
  default     = ["10.0.0.0/24"]
}

#VM
variable "vnetvm_address_space" {
  type        = list(string)
  description = "Address space of the vm virtual network"
  default     = ["10.1.0.0/16"]
}

variable "subnetvm_address_space" {
  type        = list(string)
  description = "Address space of the vm subnet"
  default     = ["10.1.0.0/24"]
}

variable "subnetbastion_address_space" {
  type        = list(string)
  description = "Address space of the bastion subnet"
  default     = ["10.1.1.0/27"]
}

#PEs
variable "vnetpe_address_space" {
  type        = list(string)
  description = "Address space of the private endpoints virtual network"
  default     = ["10.2.0.0/16"]
}

variable "subnetpe_address_space" {
  type        = list(string)
  description = "Address space of the private endpoints subnet"
  default     = ["10.2.0.0/24"]
}

