# Usage
1. Install Terraform 0.15 (from [here](https://www.terraform.io/downloads.html "Download Terraform!"))
2. Export the env variables (you can also place them in the provider block):
   - ARM_TENANT_ID (you can get it [here](https://portal.azure.com/#blade/Microsoft_AAD_IAM/ActiveDirectoryMenuBlade/Properties))
   - ARM_SUBSCRIPTION_ID (you can get it [here](https://portal.azure.com/#blade/Microsoft_Azure_Billing/SubscriptionsBlade))
   - ARM_CLIENT_ID (you can get it [here](#getting-arm_client_id--arm_client_secret))
   - ARM_CLIENT_SECRET (you can get it [here](#getting-arm_client_id--arm_client_secret))
3. Run ```terraform init```- it might take a bit of time to run since your local Terraform need to install all the Azure package
4. Run ```terraform plan``` with ```-var-file='example.tfvars'``` and your own ```tfvars``` file (you can see an example in this repo) to see what your command will create/change if you'll run ```terraform apply```.
5. Run ```terraform apply``` with ```-var-file='example.tfvars'``` and your own ```tfvars``` file (you can see an example in this repo) to actually create/modify your cloud resources. Make sure to approve the command in the interactive prompt (or else use ```-auto-approve``` with caution).
6. You can do the same as the previous commend but with the ```terraform destroy``` command to completely destroy the cloud resources.

# limitations (current)
- Only one node pool
- No Spots

# Tasks
### TODO
- firewall and/or VNets
- Choose Subscription
- identity
- Node pools
- Auto Scaling
- GPU support
- Spot Support
- policy (as code)
### Done
- sku size
- tags

# Appendix
## Getting ARM_CLIENT_ID & ARM_CLIENT_SECRET

1. Register a new app [here.](https://portal.azure.com/#blade/Microsoft_AAD_IAM/ActiveDirectoryMenuBlade/RegisteredApps/RegisteredApps/Overview)
2. Save the Application ID (it might be also called 'client id')- this is your ```ARM_CLIENT_ID```
3. After you've created app click it and go to the 'Certificates & secrets' blade (in the left) and create a new 'Client Secret'- this is your ```ARM_CLIENT_SECRET```.
**Make sure to save your value,** since it'll be the last time you get it (PS Keep it Super Secret! If someone have it they'll have access to your Azure account).
