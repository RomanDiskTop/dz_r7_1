# Yandex Cloud Authentication
variable "token" {
  description = "Yandex Cloud OAuth token"
  type        = string
  sensitive   = true
}

variable "cloud_id" {
  description = "Yandex Cloud ID"
  type        = string
  sensitive   = true
}

variable "folder_id" {
  description = "Yandex Cloud Folder ID"
  type        = string
  sensitive   = true
}

# Infrastructure
variable "region
  description = "Yandex Cloud region"
  type        = string
  default     = "ru-central1"
}

variable "zone" {
  description = "Yandex Cloud zone"
  type        = string
  default     = "ru-central1-a"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC network"
  type        = string
  default     = "10.0.0.0/24"
}

# SSH
variable "ssh_public_key" {
  description = "Public SSH key for VM access"
  type        = string
}

# Операционка
variable "ubuntu_image_id" {
  description = "Ubuntu 24 image ID"
  type        = string
  default     = "fd8slqa3vkedptmcmgh7" # проверка
}

variable "centos_image_id" {
  description = "CentOS 8 image ID"
  type        = string
  default     = "fd8qfp90a5l0m3d2htrm" # проверка
}

variable "redos_image_id" {
  description = "RedOS 7.3 image ID"
  type        = string
  default     = "fd8av5nmo34m8d82fcpo" # проверка
}

variable "debian_image_id" {
  description = "Debian 11 image ID"
  type        = string
  default     = "fd87369k2j9efm56m8j7" # проверка
}

# srv1 (Debian 11)
variable "srv1" {
  description = "zabbix+pgsql+nginx"
  type = object({
    name          = string
    hostname      = string
    ip_address    = string
    cores         = number
    memory        = number
    disk_size     = number
    core_fraction = number
    preemptible   = bool
  })
  default = {
    name          = "srv1"
    hostname      = "srv1"
    ip_address    = "10.0.0.11"
    cores         = 2
    memory        = 2
    disk_size     = 20
    core_fraction = 20
    preemptible   = false
  }
}

# srv2 (CentOS 8)
variable "srv2" {
  description = "srv2 (Elasticsearch+Logstash)"
  type = object({
    name          = string
    hostname      = string
    ip_address    = string
    cores         = number
    memory        = number
    disk_size     = number
    core_fraction = number
    preemptible   = bool
  })
  default = {
    name          = "srv2"
    hostname      = "srv2"
    ip_address    = "10.0.0.12"
    cores         = 2
    memory        = 4
    disk_size     = 20
    core_fraction = 20
    preemptible   = true
  }
}

# srv3 (RedOS 7.3)
variable "srv3" {
  description = "srv3"
  type = object({
    name          = string
    hostname      = string
    ip_address    = string
    cores         = number
    memory        = number
    disk_size     = number
    core_fraction = number
    preemptible   = bool
  })
  default = {
    name          = "srv3"
    hostname      = "srv3"
    ip_address    = "10.0.0.13"
    cores         = 2
    memory        = 2
    disk_size     = 20
    core_fraction = 20
    preemptible   = true
  }
}

# srv-zbx (Ubuntu 24)
variable "srv-zbx" {
  description = "srv-zbx"
  type = object({
    name          = string
    hostname      = string
    ip_address    = string
    cores         = number
    memory        = number
    disk_size     = number
    core_fraction = number
    preemptible   = bool
  })
  default = {
    name          = "srv-zbx"
    hostname      = "srv-zbx"
    ip_address    = "10.0.0.10"
    cores         = 2
    memory        = 2
    disk_size     = 20
    core_fraction = 20
    preemptible   = true
  }
}

# Теги
variable "tags" {
  description = "Common tags for all resources"
  type        = map(string)
  default = {
    project     = "infrastructure"
    environment = "production"
    terraform   = "true"   
  }
}