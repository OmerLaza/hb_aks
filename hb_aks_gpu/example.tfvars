aks_resource_group = "TestAKS-kdfjsf22"
aks_name = "TestAKS-k8s"
project_name = "TestAKS"

docker_image_address = "azurereg.azurecr.io/some_image:latest"
docker_server = "azurereg.azurecr.io"
docker_image_username = "SOME_USERNAME"
docker_image_password = "SOME_PASSWORD"

num_of_replicas = 3
resources_requested = {
    cpu    = "500m"
    memory = "200Mi"
    "nvidia.com/gpu" = "1"
}

resources_limits = {
    cpu    = "1000m"
    memory = "750Mi"
    "nvidia.com/gpu" = "1"
}