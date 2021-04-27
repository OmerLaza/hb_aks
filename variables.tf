variable "location" {
  type        = string
  description = "The location of the resources"
  default     = "West Europe"
}

variable "project_name" {
  type        = string
  description = ""
}

variable "default_pool_vm_size" {
  type        = string
  description = "The VM size of the default vm size"
  default     = "Standard_D2_v2"
  /*validation {
  }*/
}

variable "default_pool_number_of_instances" {
  type        = number
  description = "Number of VM of the default instance type"
  default     = 3
}

variable "env" {
  #TODO: add validation to the env
  type        = string
  description = "Envirerment"
  default     = "dev"
  validation {
    condition     = contains(["prod", "dev", "test"], lower(var.env))
    error_message = "Your envirerment can be only one of: prod/dev/test."
    # tried to make this dynamic but TF doesn't support it yet :( maybe in 0.16
    # https://github.com/hashicorp/terraform/issues/24160
    # https://github.com/hashicorp/terraform/pull/28044
  }
}

# variable "node_pools" {
#   type = list(map)
#   description = "list of objects that represent node_pools with statrure of {name: THE_NAME}"
# }

variable "virtual_network" { # TODO: add vent 
  type        = string
  description = ""
  default     = "" #If no VNet was provided will create new
}

variable "tags" {
  type        = map(string)
  description = ""
  default     = {}
}

variable "kubernetes_version" {
  type = string
  description = "Version of the k8s cluster"
  default = "1.19.9"
validation {
    condition     = contains(["1.18.14", "1.18.17", "1.19.7", "1.19.9", "1.20.2", "1.20.5" ], var.kubernetes_version)
    error_message = "Your envirerment can be only one of: prod/dev/test."
    # tried to make this dynamic but TF doesn't support it yet :( maybe in TF 0.16
  }
}

variable "kube_dashboard" {
  type = bool
  default = false
  description = ""
}

variable "vent_peer" {
  type = string
  default = ""
  description = "The vent you want to connect to have acsess to this AKS."
}

