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

variable "tags" {
  type        = map(string)
  description = ""
  default     = {}
}

variable "kubernetes_version" {
  type        = string
  description = "Version of the k8s cluster"
  default     = "1.19.9"
  validation {
    condition     = contains(["1.18.14", "1.18.17", "1.19.7", "1.19.9", "1.20.2", "1.20.5"], var.kubernetes_version)
    error_message = "Your envirerment can be only one of: prod/dev/test."
    # tried to make this dynamic but TF doesn't support it yet :( maybe in TF 0.16
  }
}

variable "vent_peer" {
  type        = string
  default     = ""
  description = "The vent you want to connect to have acsess to this AKS."
}

# Spot Args

variable "spot_config" {
  description = "Block describeing the arguments required for spots"
  
  type = object({
    spot_vm_size         = string
    spot_vm_number       = number
    spot_evection_policy = string
    spot_max_price       = number
  })
  default = {
    spot_vm_size         = "Standard_NC6"
    spot_vm_number       = 0
    spot_evection_policy = "Delete"
    spot_max_price       = 1
  }

  validation {
    condition     = var.spot_config.spot_vm_number >= 0
    error_message = "Number of spot instances should be >= 0 (if 0 no spot will be created)."
  }

  validation {
    condition     = contains(["Deallocate", "Delete"], var.spot_config.spot_evection_policy)
    error_message = "Number of spot instances should be 'Delete' or 'Deallocate'."
  }

  validation {
    condition     = var.spot_config.spot_max_price > 0 || var.spot_config.spot_max_price == -1
    error_message = "Spot Price must be above 0 (or -1)."
  }
}
