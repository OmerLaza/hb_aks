variable "location" {
  type        = string
  description = "The location of the resources"
  default     = "West Europe"
}

variable "project_name" {
  type        = string
  description = "Name of the project, it's used for various nameing purposes."
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
  description = "List of tags to add to all the resources."
  default     = {}
}

variable "kubernetes_version" {
  type        = string
  description = "Version of the k8s cluster"
  default     = "1.19.9"
}

variable "vent_peer" {
  type        = string
  default     = ""
  description = "The vent you want to connect to have acsess to this AKS."
}

variable "new_log_analitics" {
  type        = bool
  default     = false
  description = "Creates new Azure Log Analitics Solution and Azure Log Analytics Workspace and configers the AKS to it."
}

variable "log_analitics_workspace_address" {
  type        = string
  default     = null
  description = "Adderess of log_analitics_workspace that we want the AKS to send logs to. It lest empty(or null) we will create a new one."
  # Example: "/subscriptions/SUBSCRIPTION_ID/resourcegroups/RESOURCE_GROUP_ID/providers/microsoft.operationalinsights/workspaces/LOG_ANALITICS_WORKSPACE_NAME"
}

variable "kube_dashboard" {
  type        = bool
  default     = false
  description = "Should we enable the kube dashboard."
}
