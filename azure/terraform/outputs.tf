output "spire_server_ip" {
  value = azurerm_linux_virtual_machine.spire_host.public_ip_address
}
