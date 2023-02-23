#VM
resource "azurerm_network_security_group" "nsgvm" {
  name                = "nsgvm"
  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name
}

resource "azurerm_subnet_network_security_group_association" "assocnsg" {
  subnet_id                 = azurerm_subnet.subnetvm.id
  network_security_group_id = azurerm_network_security_group.nsgvm.id
}

resource "azurerm_network_interface" "nicvm" {
  name                = "nicvm"
  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnetvm.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "vmlab" {
  name                = "vmlab"
  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name
  size                = "Standard_B2s"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.nicvm.id,
  ]

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}

#Bastion
resource "azurerm_public_ip" "pubipbastion" {
  name                = "pubipbastion"
  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_bastion_host" "bastion" {
  name                = "bastion"
  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.subnetbastion.id
    public_ip_address_id = azurerm_public_ip.pubipbastion.id
  }
}