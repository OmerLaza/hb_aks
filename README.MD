# Usage
## General Instaurations
This guide was written using Powershell but should be compatible using Bash.

1. Install Terraform 0.15 (from [here](https://www.terraform.io/downloads.html "Download latest Terraform!") for the newest version or [here](https://releases.hashicorp.com/terraform/ "Download Terraform!") for older versions).
2. Export the env variables (you can also place them in the provider block):
   - ```ARM_TENANT_ID``` (you can get it [here](https://portal.azure.com/#blade/Microsoft_AAD_IAM/ActiveDirectoryMenuBlade/Properties))
   - ```ARM_SUBSCRIPTION_ID``` (you can get it [here](https://portal.azure.com/#blade/Microsoft_Azure_Billing/SubscriptionsBlade))
   - ```ARM_CLIENT_ID``` (you can get it [here](#getting-arm_client_id--arm_client_secret))
   - ```ARM_CLIENT_SECRET``` (you can get it [here](#getting-arm_client_id--arm_client_secret))

## Creating the AKS (Azure Kubernetes Service)
1. ```cd hb_aks``` to create the AKS
2. Run ```terraform init```- it might take a bit of time to run since your local Terraform need to install all the Azure package.
3. Run ```terraform plan``` with ```-var-file='example.tfvars'``` and your own ```tfvars``` file (you can see an example in this repo) to see what your command will create/change if you'll run ```terraform apply```.
4. Run ```terraform apply``` with ```-var-file='example.tfvars'``` and your own ```tfvars``` file (you can see an example in this repo) to actually create/modify your cloud resources. Make sure to approve the command in the interactive prompt (or else use ```-auto-approve``` with caution).
5. Make sure to save the ```aks_name``` & ```resource_group``` out variables of the Terraform apply for the next part.
6. You can do the same as the previous commend but with the ```terraform destroy``` command to completely destroy the cloud resources.

## Adding the GPU support
note about the built in support [here](#AKS-with-built-in-support-for-GPU)

1. cd ```../hb_aks_gpu```
2. Create ```.tfvars``` file like with variables ```aks_resource_group``` & ```aks_name``` with the relevant variables from the previous run of ```terraform apply```.
3. Run ```terraform plan``` with ```-var-file='example.tfvars'``` and your own ```tfvars``` file (you can see an example in this repo) to see what your command will create/change if you'll run ```terraform apply```.
4. Run ```terraform apply``` in similar way (aka ```-var-file``` argument) and approve it to create the GPU support in the AKS cluster.
5. You can destroy the aks config using the ```terraform destroy``` command.

## Test the GPU config
Based on [this Azure doc](https://docs.microsoft.com/en-us/azure/aks/gpu-cluster#confirm-that-gpus-are-schedulable).

1. run ```az login``` (or equivalent).
2. run ```az aks get-credentials --resource-group YOUR_RESOURCE_GROUP_NAME --name NAME_OF_YOUR_AKS_CLUSTER```
this will add the appropriate config to your ```kubectl``` config file (aka kubeconfig).
3. Run ```kubectl get nodes``` 
4. Run ```kubectl describe node``` to get list of all your nodes (you can also specify node by adding it's name in the end of the command), each one of them should have ```nvidia.com/gpu``` line under ```Capacity```.

# Tasks
## TODO
- Auto Scaling
- Fix network hard coding (ip ranges)
- identity
- Node pools
- Spot Support
- firewall
- policy (as code)
## Done
- GPU support
- VNets
- sku size
- tags
- logs

# Appendix
## Getting ARM_CLIENT_ID & ARM_CLIENT_SECRET

1. Register a new app [here.](https://portal.azure.com/#blade/Microsoft_AAD_IAM/ActiveDirectoryMenuBlade/RegisteredApps/RegisteredApps/Overview)
2. Save the Application ID (it might be also called 'client id')- this is your ```ARM_CLIENT_ID```.
3. After you've created app click it and go to the 'Certificates & secrets' blade (in the left) and create a new 'Client Secret'- this is your ```ARM_CLIENT_SECRET```.
   
    **Make sure to save your value,** since it'll be the last time you get it (PS Keep it Super Secret! If someone have it they'll have access to your Azure account).

## AKS with built in support for GPU
The built in GPU support for AKS (aka built in GPU support) is currently (May 2021) in preview. So I had to configure it 'by hand' using this TF module.

To see the current AKS + GPU as a service options look [here](https://docs.microsoft.com/en-us/azure/aks/gpu-cluster "AKS + GPU").