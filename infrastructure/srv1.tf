resource "yandex_compute_instance" "srv1" {
  name        = var.srv1.name
  hostname    = var.srv1.hostname
  platform_id = "standard-v1"
  zone        = var.zone

  resources {
    cores         = var.srv1.cores
    memory        = var.srv1.memory
    core_fraction = var.srv1.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = var.debian_image_id
      size     = var.srv1.disk_size
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.default.id
    nat       = true
    ip_address = var.srv1.ip_address
  }

  scheduling_policy {
    preemptible = var.srv1.preemptible
  }

  metadata = {
    ssh-keys = "debian:${var.ssh_public_key}"
  }

  labels = var.tags
}