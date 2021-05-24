variable "aks_resource_group" {
  type        = string
  description = ""
}

variable "aks_name" {
  type        = string
  description = ""
}

variable "project_name" {
  type        = string
  description = ""
}

variable "num_of_replicas" {
  type        = number
  description = ""
  default     = 3
  validation {
    condition     = var.num_of_replicas > 0
    error_message = "Number of replicas must be greated then 0."
  }
}

variable "docker_image_address" {
  type        = string
  description = ""
}

variable "docker_server"{
  type = string
  description = ""
  sensitive = false
}

variable "docker_image_username"{
  type = string
  description = ""
  sensitive = false
}

variable "docker_image_password"{
  type = string
  description = ""
  sensitive = true
}

variable "resources_limits" {
  type        = map(string)
  description = ""
  default = null
  # exemple
  # {
  #   cpu    = "250m"
  #   memory = "50Mi"
  # }
}

variable "resources_requested" {
  type        = map(string)
  description = ""
  default = null
  # exemple
  # {
  #   cpu    = "250m"
  #   memory = "50Mi"
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




