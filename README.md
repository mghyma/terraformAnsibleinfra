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

![azureserviceprincipal](https://github.com/mghyma/terraformAnsibleinfra/assets/128038495/e96b7549-45da-414c-b818-ea1edb60d4c9)

Task 2: Configure Ansible in a Linux machine
To create and provision the resources in Azure with Ansible, we need to have a Linux VM with Ansible configured. In this exercise, you will deploy an Azure Linux VM and configure Ansible on the virtual machine

 1.In the Azure Cloud shell enter below command to create Azure resource group

  az group create --name AnsibleVM --location eastus

 2.Create the Azure virtual machine for Ansible.

 az vm create --resource-group AnsibleVM --name AnsibleVM  --image OpenLogic:CentOS:7.7:latest  --admin-username india  --admin-password India@123456

 Replace the <password> with your password.

 3.Once the deployment is successful, navigate to the resource group and select the VM.

 ![azureVMselect](https://github.com/mghyma/terraformAnsibleinfra/assets/128038495/36b69204-b5a4-4830-9828-b79809ab9006)

 4.Select Overview and copy the Public IP address.

 ![AnsibleVMPublicIP](https://github.com/mghyma/terraformAnsibleinfra/assets/128038495/387042af-417d-4377-b82d-afdb9cb9477b)










   
