

resource "azurerm_resource_group" "rg" {
  location = "eastus"
  name     = "AzureMedia"
}

# Create virtual network
resource "azurerm_virtual_network" "my_terraform_network" {
  name                = "AzureMedia-Vnet"
  address_space       = ["10.1.0.0/16"]
  location            = "eastus"
  resource_group_name = "AzureMedia"
}

# Create subnet
resource "azurerm_subnet" "my_terraform_subnet" {
  name                 = "AzureMedia-Subnet"
  resource_group_name  = "AzureMedia"
  virtual_network_name = azurerm_virtual_network.my_terraform_network.name
  address_prefixes     = ["10.1.1.0/24"]
}

# Create public IPs
resource "azurerm_public_ip" "my_terraform_public_ip" {
  name                = "myPublicIP"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Dynamic"
}

# Create Network Security Group and rule
resource "azurerm_network_security_group" "my_terraform_nsg" {
  name                = "myNetworkSecurityGroup"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Create network interface
resource "azurerm_network_interface" "my_terraform_nic" {
  name                = "myNIC"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "my_nic_configuration"
    subnet_id                     = azurerm_subnet.my_terraform_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.my_terraform_public_ip.id
  }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "example" {
  network_interface_id      = azurerm_network_interface.my_terraform_nic.id
  network_security_group_id = azurerm_network_security_group.my_terraform_nsg.id
}

# Generate random text for a unique storage account name
resource "random_id" "random_id" {
  keepers = {
    # Generate a new ID only when a new resource group is defined
    resource_group = azurerm_resource_group.rg.name
  }

  byte_length = 8
}

# Create storage account for boot diagnostics
resource "azurerm_storage_account" "my_storage_account" {
  name                     = "diag${random_id.random_id.hex}"
  location                 = azurerm_resource_group.rg.location
  resource_group_name      = azurerm_resource_group.rg.name
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# Create virtual machine
resource "azurerm_linux_virtual_machine" "my_terraform_vm" {
  name                  = "azureterraform"
  location              = "eastus"
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.my_terraform_nic.id]
  size                  = "Standard_DS1_v2"

  os_disk {
    name                 = "myOsDisk"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  computer_name  = "LinuxMachine"
  admin_username = "india1"

  admin_ssh_key {
    username   = "india1"
    public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCtdiuvMIoR9HSWXqDaSUuJFJmHEF2dMy4jz7/Drjf2r5AkJI+vXQwSTsK55Xmx8aloskZBpa9XAOAhW/rpsQTxpHyZRIcPz7KHIvnBrxgY8uXnxvFq4RnENPjyfxGJalGd5PigWVToKc5r0x0Yek+9T40Fyj5Pzjq0H2AfKrhNoQB0a34OQbFzcZW/NnlgyDjd9Y4SX3EKOtl89WY88QvGLLeIzcijSoAiaZou9yT6Q68FJLhpJV3ZElk0TK360AkdIdSkAcDKjLQaR6Sqazwsd9IgRTpboCWniUv4HPu8VFlh0wROCWWIAW6PhRW2C7BAQvP9SwfQuhIGKazghxi7 rsa-key-20240517"
  }

  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.my_storage_account.primary_blob_endpoint
  }
}