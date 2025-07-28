resource "yandex_compute_instance" "srv2" {
  name        = var.srv2.name
  hostname    = var.srv2.hostname
  platform_id = "standard-v1"
  zone        = var.zone

  resources {
    cores         = var.srv2.cores
    memory        = var.srv2.memory
    core_fraction = var.srv2.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = var.centos_image_id
      size     = var.srv2.disk_size
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.default.id
    nat       = true
    ip_address = var.srv2.ip_address
  }

  scheduling_policy {
    preemptible = var.srv2.preemptible
  }

  metadata = {
    ssh-keys = "cloud-user:${var.ssh_public_key}"
  }

  labels = var.tags
}