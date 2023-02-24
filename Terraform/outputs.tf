output "vmlabidentity" {
  value = azurerm_linux_virtual_machine.vmlab.identity
}

output "myip" {
  value = data.http.myip.response_body
}