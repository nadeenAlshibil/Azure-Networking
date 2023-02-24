#NIC
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


#Create Unique KeyVault name
resource "random_id" "kvname" {
  byte_length = 5
  prefix = "keyvault"
}

#Get my IP 
data "http" "myip" {
  url = "https://ifconfig.me/ip"
}

#Private endpoint for keyvault access
resource "azurerm_private_endpoint" "keyvaultPE" {
  name                = "keyvaultprivendpoint"
  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name
  subnet_id           = azurerm_subnet.subnetvm.id

  private_service_connection {
    name                           = "AzureKeyVault"
    subresource_names              = [ "vault" ]
    private_connection_resource_id = azurerm_key_vault.keyvault.id
    is_manual_connection           = false
  }
}

#Keyvault Creation
resource "azurerm_key_vault" "keyvault" {
  name                       = random_id.kvname.hex
  location                   = azurerm_resource_group.default.location
  resource_group_name        = azurerm_resource_group.default.name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = "premium"
  soft_delete_retention_days = 7
  enable_rbac_authorization  = true
  network_acls {
    bypass = "AzureServices"
    default_action = "Deny"
    ip_rules = [ data.http.myip.response_body ]
  }

}

resource "azurerm_role_assignment" "allowme" {
  scope                = azurerm_key_vault.keyvault.id
  role_definition_name = "Key Vault Administrator"
  principal_id         = data.azuread_client_config.current.object_id
}

resource "azurerm_role_assignment" "allowvm" {
  scope                = azurerm_key_vault.keyvault.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_linux_virtual_machine.vmlab.identity[0].principal_id
}


# Create an SSH key
resource "tls_private_key" "sshkey" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "azurerm_key_vault_secret" "secret" {
  name         = "secret-privkey"
  value        = tls_private_key.sshkey.private_key_openssh
  key_vault_id = azurerm_key_vault.keyvault.id
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
    public_key = tls_private_key.sshkey.public_key_openssh
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

  identity {
    type    = "SystemAssigned"
  }
}


