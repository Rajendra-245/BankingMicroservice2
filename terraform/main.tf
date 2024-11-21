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
    caching           = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  network_interface_ids = [azurerm_network_interface.example.id]
}
