output "spire_server_ip" {
  value = aws_instance.spire_host.public_ip
}
