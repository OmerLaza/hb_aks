variable "aks_resource_group" {
  type        = string
  description = "Resource group name of the AKS cluster."
}

variable "aks_name" {
  type        = string
  description = "Name of the AKS cluster."
}

variable "project_name" {
  type        = string
  description = "Name of the project, it's used for various nameing purposes."
}

variable "num_of_replicas" {
  type        = number
  description = "Number of replicas of your container."
  default     = 3
  validation {
    condition     = var.num_of_replicas > 0
    error_message = "Number of replicas must be greated then 0."
  }
}

variable "docker_image_address" {
  type        = string
  description = "Address of the docker image e.g \"azurereg.azurecr.io/some_image:latest\". If null the deployment and secret will not be created."
  default = null
}

variable "docker_server"{
  type = string
  description = "Address of the docker server to get the image from e.g. \"azurereg.azurecr.io\"."
  sensitive = false
  default = null
}

variable "docker_image_username"{
  type = string
  description = "Username used to connect to the docker registry."
  sensitive = false
  default = null
}

variable "docker_image_password"{
  type = string
  description = "Password used to connect to the docker registry."
  sensitive = true
  default = null
}

variable "resources_limits" {
  type        = map(string)
  description = "Resource limits for the deployment."
  default = null
  # exemple
  # {
  #   cpu    = "500m"
  #   memory = "200Mi"
  #   "nvidia.com/gpu" = "1"
  # }
}

variable "resources_requested" {
  type        = map(string)
  description = "Resource requested for the deployment."
  default = null
  # exemple
  # {
  #   cpu    = "500m"
  #   memory = "200Mi"
  #   "nvidia.com/gpu" = "1"
  # }
}

/*
variable liveness_probe{
  type = map(string)
  description = ""
  default = null
  # exemple
  # {
  #   http_get {
  #     path = "/nginx_status"
  #     port = 80

  #     http_header {
  #       name  = "X-Custom-Header"
  #       value = "Awesome"
  #     }
  #   }

  #   initial_delay_seconds = 3
  #   period_seconds        = 3
  # }
}
*/
