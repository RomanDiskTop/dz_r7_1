resource "yandex_compute_instance" "srv-zbx" {
  name        = var.srv-zbx.name
  hostname    = var.srv-zbx.hostname
  platform_id = "standard-v1"
  zone        = var.zone

  resources {
    cores         = var.srv-zbx.cores
    memory        = var.srv-zbx.memory
    core_fraction = var.srv-zbx.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = var.ubuntu_image_id
      size     = var.srv-zbx.disk_size
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.default.id
    nat       = true
    ip_address = var.srv-zbx.ip_address
  }

  scheduling_policy {
    preemptible = var.srv-zbx.preemptible
  }

  metadata = {
    ssh-keys = "ubuntu:${var.ssh_public_key}"
  }
}