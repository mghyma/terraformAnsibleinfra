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

5. Run the following commands to configure Ansible on Centos:
    #!/bin/bash

 # Update all packages that have available updates.
 sudo yum update -y

 # Install Python 3 and pip.
 sudo yum install -y python3-pip

 # Upgrade pip3.
 sudo pip3 install --upgrade pip

 # Install Ansible.
 pip3 install "ansible==2.9.17"

 # Install Ansible azure_rm module for interacting with Azure.
 pip3 install ansible[azure]
 
 6.Now we must create a directory named .azure in the home directory and a credentials file under it. This local credentials file is to provide credentials to Ansible. Type the following commands to create them.

mkdir ~/.azure

nano ~/.azure/credentials

7.Insert the following lines into the credentials file. Replace the placeholders with the information from the service principal details you copied in the previuous task. Press Ctrl+ to save the file and Ctrl+X to exit from the text editor.

[default]

subscription_id=<your-Azure-subscription_id>

client_id=<your-Azure-client_id>

secret=<your-Azure-secret>

tenant=<your-Azure-tenant>

8.Run nano ~/.bashrc and insert the following text into .bashrc. Press Ctrl+O to save the file and Ctrl+X to exit from the text editor.

PATH=$PATH:$HOME/.local/bin:$HOME/bin

9.Ansible is an agentless architecture based automation tool . Only it needs ssh authentication using Ansible Control Machine private/public key pair. Now let us create a pair of private and public keys. Run the following command to generate a private/public key pair for ssh and to install the public key in the local machine.

ssh-keygen -t rsa

chmod 755 ~/.ssh

touch ~/.ssh/authorized_keys

chmod 644 ~/.ssh/authorized_keys

ssh-copy-id india@10.50.1.4

![sshkeys](https://github.com/mghyma/terraformAnsibleinfra/assets/128038495/284456eb-c38c-421d-a32d-747fa22e87a6)

10.In the next task, you need SSH private key to created SSH endpoint in Azure DevOps service. Run the following command to get the private key. Copy the private key to notepad.

cat ~/.ssh/id_rsa

![sshprivatekey](https://github.com/mghyma/terraformAnsibleinfra/assets/128038495/8a95f442-d208-414b-b4b7-7ad895416649)

Task 3: Create a SSH Service Connection in Azure DevOps
To connect and run playbooks through Ansible VM in Azure pipelines, we need to have a connection between Azure DevOps and Ansible VM. This service connection provides authentication to Ansible.
1.Navigate to Project Settings --> Service Connections. Select Create service connection.

![sshendpoint](https://github.com/mghyma/terraformAnsibleinfra/assets/128038495/de6e545d-1e92-4cfe-bc07-c243da10fc8f)

2.the project we created above using https://dev.azure.com/mgskrish/mediawikipro1

3.New Service Connection windows select SSH and click Next

![SSHSelect](https://github.com/mghyma/terraformAnsibleinfra/assets/128038495/531c17d1-42d1-409c-bda0-64b84e8e5acf)

4. New SSH service connection window provide the required details and click Save to save the connection.

![SSHServiceConnection](https://github.com/mghyma/terraformAnsibleinfra/assets/128038495/3b3fbd2c-29eb-4db7-aef6-5ae91ec3f607)



















   
