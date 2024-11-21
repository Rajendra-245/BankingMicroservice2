# Configure the Azure provider
provider "azurerm" {
  features {}

  # Uncomment and provide your subscription_id, client_id, client_secret, and tenant_id
  AZURE_CLIENT_ID     = "aaba2b34-76ec-43a1-a1d6-aa77ebb76032"
  AZURE_CLIENT_SECRET = "a9e35d0f-80b7-41ad-9f85-11a5047868f1"
  AZURE_TENANT_ID     = "c3337333-ab54-4b33-8aa7-1d5b19f9b96f"
  AZURE_SUBSCRIPTION_ID = "c36a2f47-ab04-42a4-a035-c64fe75e4fba"

}

# Create a resource group
resource "azurerm_resource_group" "example" {
  name     = "example-resources"
  location = "East US"
}

# Create a virtual network
resource "azurerm_virtual_network" "example" {
  name                = "example-network"
  address_space        = ["10.0.0.0/16"]
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}

# Create a subnet within the virtual network
resource "azurerm_subnet" "example" {
  name                 = "example-subnet"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Create a network interface for the virtual machine
resource "azurerm_network_interface" "example" {
  name                = "example-nic"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  ip_configuration {
    name                          = "example-ip-config"
    subnet_id                     = azurerm_subnet.example.id
    private_ip_address_allocation = "Dynamic"
  }
}

# Create a virtual machine
resource "azurerm_linux_virtual_machine" "example" {
  name                = "example-vm"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  size                = "Standard_DS1_v2"
  admin_username      = "adminuser"
  admin_password      = "P@ssw0rd1234!"
  network_interface_ids = [
    azurerm_network_interface.example.id,
  ]
  os_disk {
    name                     = "example-os-disk"
    caching                  = "ReadWrite"
    storage_account_type     = "Standard_LRS"
  }
  source_image_id = "/subscriptions/{subscription-id}/resourceGroups/{resource-group}/providers/Microsoft.Compute/images/{image-name}" # Replace with correct image ID
}

# Output the public IP address of the virtual machine
output "vm_public_ip" {
  value = azurerm_linux_virtual_machine.example.public_ip_address
}
