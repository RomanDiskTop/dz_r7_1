resource "yandex_compute_instance" "srv3" {
  name        = var.srv3.name
  hostname    = var.srv3.hostname
  platform_id = "standard-v1"
  zone        = var.zone

  resources {
    cores         = var.srv3.cores
    memory        = var.srv3.memory
    core_fraction = var.srv3.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = var.redos_image_id
      size     = var.srv3.disk_size
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.default.id
    nat       = true
    ip_address = var.srv3.ip_address
  }

  scheduling_policy {
    preemptible = var.srv3.preemptible
  }

  metadata = {
    ssh-keys = "redos:${var.ssh_public_key}"
  }

  labels = var.tags
}