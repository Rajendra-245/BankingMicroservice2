# Define the Virtual Network
resource "azurerm_virtual_network" "example" {
  name                = "vnet-example"
  address_space       = ["10.0.0.0/16"]
  location            = "East US"
  resource_group_name = "rg-new"
}

# Define the Subnet
resource "azurerm_subnet" "example" {
  name                 = "subnet-example"
  resource_group_name  = "rg-new"
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Define the Network Interface
resource "azurerm_network_interface" "example" {
  name                = "nic-example"
  location            = "East US"
  resource_group_name = "rg-new"

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.example.id
    private_ip_address_allocation = "Dynamic"
  }
}

# Define the Linux Virtual Machine
resource "azurerm_linux_virtual_machine" "linux_vm" {
  name                = "vm-new"
  resource_group_name = "rg-new"
  location            = "East US"
  size                = "Standard_B2s"

  admin_username      = "adminuser"

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"  # Automatically selects a valid version
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  # Reference the network interface ID
  network_interface_ids = [azurerm_network_interface.example.id]
}
