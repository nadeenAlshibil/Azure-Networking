#!/bin/bash

RgName="myResourceGroup"
Location="northeurope"
 

# Create a resource group.
az group create \
  --name $RgName \
  --location $Location

# Create a virtual network for Azure Firwall with a Firewall subnet.
az network vnet create \
  --name myAzFwVNet \
  --resource-group $RgName \
  --location $Location \
  --address-prefix 10.0.0.0/16 \
  --subnet-name AzureFirewallSubnet \
  --subnet-prefix 10.0.0.0/24

# Create a virtual network for VMs with a VM subnet.
az network vnet create \
  --name myVMVNet \
  --resource-group $RgName \
  --location $Location \
  --address-prefix 10.1.0.0/16 \
  --subnet-name VMSubnet \
  --subnet-prefix 10.1.0.0/24


# Create a Bastion subnet in myVMVNet.
az network vnet subnet create \
 --name AzureBastionSubnet \
 --vnet-name myVMVNet \
 --resource-group $RgName \
 --address-prefixes 10.1.1.0/27

az network public-ip create \
  --resource-group $RgName \
  --sku Standard \
  --name BastionPublicIpAddress

# Create a Bastion 
 az network bastion create \
 --name MyBastion \
 --public-ip-address BastionPublicIpAddress \
 --resource-group $RgName \
 --vnet-name myVMVNet

# Create a virtual network for Private Endpoints with a PrivateEndpoint subnet.
az network vnet create \
  --name myPEVNet \
  --resource-group $RgName \
  --location $Location \
  --address-prefix 10.2.0.0/16 \
  --subnet-name PrivateEndpointSubnet \
  --subnet-prefix 10.2.0.0/24


# Create a network security group for the VM subnet.
az network nsg create \
  --resource-group $RgName \
  --name MyNsg-VMSubnet  \
  --location $Location

# Create an NSG rule to allow SSH traffic in from the Internet to the VM subnet.
az network nsg rule create \
  --resource-group $RgName \
  --nsg-name MyNsg-VMSubnet  \
  --name Allow-SSH-All \
  --access Allow \
  --protocol Tcp \
  --direction Inbound \
  --priority 100 \
  --source-address-prefix Internet \
  --source-port-range "*" \
  --destination-address-prefix "10.1.0.4" \
  --destination-port-range 22

 
 # Associate the NSG to the VMSubnet subnet.
az network vnet subnet update \
  --vnet-name myVMVNet \
  --name VMSubnet \
  --resource-group $RgName \
  --network-security-group MyNsg-VMSubnet
 
 
# Create a public IP address for the VM.
az network public-ip create \
  --resource-group $RgName \
  --name myVm-ip2

# Create a NIC for the VM.
az network nic create \
  --resource-group $RgName \
  --name MyNic2 \
  --vnet-name myVMVNet \
  --subnet VMSubnet \
  --network-security-group MyNsg-VMSubnet \
  --public-ip-address myVm-ip2

# Create a VM in the VM subnet.
az vm create \
  --resource-group $RgName \
  --name myVM2 \
  --nics MyNic2 \
  --image Canonical:UbuntuServer:18.04-LTS:latest \
  --size Standard_B2s \
  --admin-username azureadmin \
  --authentication-type password

  
  #
 
  # --admin-password "Demouser@123" \
