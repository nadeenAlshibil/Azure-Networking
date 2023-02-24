# Virtual Networks
#Firewall vnet
resource "azurerm_virtual_network" "vnetfw" {
  name                = "vnetfw-${var.name}-${var.environment}"
  address_space       = var.vnetfw_address_space
  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name
}

resource "azurerm_subnet" "subnetfw" {
  name                                           = "AzureFirewallSubnet"
  resource_group_name                            = azurerm_resource_group.default.name
  virtual_network_name                           = azurerm_virtual_network.vnetfw.name
  address_prefixes                               = var.subnetfw_address_space
}

#VM vnet
resource "azurerm_virtual_network" "vnetvm" {
  name                = "vnetvm-${var.name}-${var.environment}"
  address_space       = var.vnetvm_address_space
  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name
}

resource "azurerm_subnet" "subnetvm" {
  name                                           = "subnetvm"
  resource_group_name                            = azurerm_resource_group.default.name
  virtual_network_name                           = azurerm_virtual_network.vnetvm.name
  address_prefixes                               = var.subnetvm_address_space
}

resource "azurerm_subnet" "subnetbastion" {
  name                                           = "AzureBastionSubnet"
  resource_group_name                            = azurerm_resource_group.default.name
  virtual_network_name                           = azurerm_virtual_network.vnetvm.name
  address_prefixes                               = var.subnetbastion_address_space
}

resource "azurerm_network_security_group" "nsgvm" {
  name                = "nsgvm"
  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name
}

resource "azurerm_subnet_network_security_group_association" "assocnsg" {
  subnet_id                 = azurerm_subnet.subnetvm.id
  network_security_group_id = azurerm_network_security_group.nsgvm.id
}

#PE vnet
resource "azurerm_virtual_network" "vnetpe" {
  name                = "vnetpe-${var.name}-${var.environment}"
  address_space       = var.vnetpe_address_space
  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name
}

resource "azurerm_subnet" "subnetpe" {
  name                                           = "subnetpe"
  resource_group_name                            = azurerm_resource_group.default.name
  virtual_network_name                           = azurerm_virtual_network.vnetpe.name
  address_prefixes                               = var.subnetpe_address_space
}