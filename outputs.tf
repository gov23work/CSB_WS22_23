output "public_ip_server" {
 value = "${join(" ", google_compute_instance.prometheus.*.network_interface.0.access_config.0.nat_ip)}"
 description = "The public IP address of the newly created instance"
}
output "public_ip_client" {
  value = "${join(" ", google_compute_instance.client.*.network_interface.0.access_config.0.nat_ip)}"
  description = "The public IP address of the newly created instance"
}