provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "main" {
  name     = "zero-trust-rg"
  location = var.location
}

resource "azurerm_virtual_network" "main" {
  name                = "zero-trust-vnet"
  address_space       = ["10.1.0.0/16"]
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
}

resource "azurerm_subnet" "spire_subnet" {
  name                 = "spire-subnet"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.1.1.0/24"]
}

resource "azurerm_network_interface" "spire_nic" {
  name                = "spire-nic"
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.spire_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "spire_host" {
  name                  = "spire-server"
  resource_group_name   = azurerm_resource_group.main.name
  location              = var.location
  size                  = "Standard_B1s"
  admin_username        = "azureuser"
  network_interface_ids = [azurerm_network_interface.spire_nic.id]
  admin_password        = "YourStrongPassword123!"

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "20_04-lts"
    version   = "latest"
  }
}
