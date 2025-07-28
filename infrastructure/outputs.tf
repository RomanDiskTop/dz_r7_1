output "srv-zbx_public_ip" {
  description = "Публичный IP сервера с Zabbix"
  value       = yandex_compute_instance.srv-zbx.network_interface[0].nat_ip_address
}

output "srv1_public_ip" {
  description = "Публичный IP сервера с ELK"
  value       = yandex_compute_instance.srv1.network_interface[0].nat_ip_address
}

output "srv2_public_ip" {
  description = "Публичный IP prod сервера"
  value       = yandex_compute_instance.srv2.network_interface[0].nat_ip_address
}

output "srv3_public_ip" {
  description = "Публичный IP prod сервера"
  value       = yandex_compute_instance.srv3.network_interface[0].nat_ip_address
}