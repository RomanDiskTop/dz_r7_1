resource "yandex_vpc_network" "default" {
  name = "net1"
}

resource "yandex_vpc_subnet" "default" {
  name           = "zabbix-subnet"
  zone           = var.zone
  network_id     = yandex_vpc_network.default.id
  v4_cidr_blocks = ["10.0.0.0/24"]
}