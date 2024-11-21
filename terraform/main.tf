provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}
 
# Resource Group
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}
 
# Virtual Network
resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  address_space       = var.address_space
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
}
 
# Subnet
resource "azurerm_subnet" "subnet" {
  name                 = var.subnet_name
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.subnet_address_prefix
}
 
# Network Security Group
resource "azurerm_network_security_group" "nsg" {
  name                = var.nsg_name
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
 
  security_rule {
    name                       = "AllowSSH"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
 
  security_rule {
    name                       = "Allow8001"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "8001"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}
 
# Public IP Address
resource "azurerm_public_ip" "vm_public_ip" {
  name                = "vm-public-ip"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}
 
# Network Interface for Linux VM
resource "azurerm_network_interface" "nic" {
  name                = "nic-linux-vm"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
 
  ip_configuration {
    name                          = "ipconfig-linux"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vm_public_ip.id
  }
}
 
# Associate NSG with NIC
resource "azurerm_network_interface_security_group_association" "nic_nsg" {
  network_interface_id      = azurerm_network_interface.nic.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}
 
# Linux Virtual Machine
resource "azurerm_linux_virtual_machine" "linux_vm1" {
  name                            = var.vm_name
  resource_group_name             = azurerm_resource_group.rg.name
  location                        = var.location
  size                            = var.vm_size
  admin_username                  = var.vm_admin_username
  admin_password                  = var.vm_admin_password
  disable_password_authentication = false
 
  network_interface_ids = [azurerm_network_interface.nic.id]
 
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
 
  source_image_reference {
    publisher = var.vm_image_publisher
    offer     = var.vm_image_offer
    sku       = var.vm_image_sku
    version   = var.vm_image_version
  }
 
  plan {
    name      = var.vm_image_sku
    publisher = var.vm_image_publisher
    product   = var.vm_image_offer
  }
 
  custom_data = base64encode(<<EOT
#!/bin/bash
 
# Update the package repository
sudo dnf -y update
 
# Add Docker repository
sudo dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
 
# Install Docker packages
sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
 
# Start Docker service
sudo systemctl start docker
 
# Enable Docker service to start on boot
sudo systemctl enable docker
 
# Verify Docker installation
sudo docker --version && echo "Docker successfully installed." || echo "Docker installation failed."
 
# Install Maven
sudo dnf install -y maven
 
# Verify Maven installation
sudo mvn --version && echo "Maven successfully installed." || echo "Maven installation failed."
 
# Script completion message
echo "Custom data script execution completed."
EOT
  )
}
 
# Output Public IP Address
output "vm_public_ip" {
  value = azurerm_public_ip.vm_public_ip.ip_address
}
