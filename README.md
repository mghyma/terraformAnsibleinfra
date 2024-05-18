title: Automating Infrastructure Deployments in the Cloud with Ansible and Azure Pipelines### What’s covered in this lab
1What covered in this project
 1.	How Ansible can be used to implement Infrastructure as Code (IaC)
 2.	How to automate infrastructure deployments in the Cloud with Ansible and Azure pipelines.# terraformAnsibleinfra
2.	### Setting up the Environment
### Task 1: Create an Azure service principal with Azure CLI
Ansible includes a suite of modules for interacting with Azure Resource Manager, giving you the tools to easily create and orchestrate infrastructure on the Microsoft Azure Cloud. Using the Azure Resource Manager modules requires authenticating with the Azure API. In this lab, you will use Azure service principal for authentication.

1. Login to the [Azure portal](https://portal.azure.com).

2. Click **Cloud Shell** and select **Bash**.
   ![azurebashshell](https://github.com/mghyma/terraformAnsibleinfra/assets/128038495/9c997708-f93c-4fdc-878f-b265c062d406)
3.Enter the following command to get Azure SubscriptionID and copy the same to notepad.

az account show

![azuredisplaysubid](https://github.com/mghyma/terraformAnsibleinfra/assets/128038495/f0f9aea4-433b-4486-a6d1-ed4a2217c61c)

4.Enter the following command by replacing ServicePrincipalName with your desired value and Subscription ID from the previous step.

az ad sp create-for-rbac --name ServicePrincipalName --role Contributor --scopes /subscriptions/<subscriptionid> 





   
