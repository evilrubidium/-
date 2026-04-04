## Задание 2 
<img width="786" height="175" alt="Снимок экрана 2026-03-31 134723" src="https://github.com/user-attachments/assets/cd35b0f2-7e72-43f0-b83b-cd6865d887f4" />

## Задание 3 
<img width="1190" height="188" alt="image" src="https://github.com/user-attachments/assets/c313010e-4ffa-43f9-9a94-5a9a90a8464f" />

## Задание 4
было 

platform_id = "  platform_id = "standart-v4"
  resources {
    cores         = 1
    memory        = 1
    core_fraction = 5" 
    
а надо 

  platform_id = "standard-v3"
  resources {
    cores         = 2
    memory        = 2
    core_fraction = 100


<img width="713" height="279" alt="image" src="https://github.com/user-attachments/assets/309faf39-7601-4b6a-9ff2-fb473b61e702" />

## Задание 5

<img width="713" height="279" alt="Снимок экрана 2026-03-31 174411" src="https://github.com/user-attachments/assets/d4b2126a-5f71-42b4-86aa-d2e551fb2f9b" />
<img width="485" height="47" alt="Снимок экрана 2026-03-31 174555" src="https://github.com/user-attachments/assets/104387f4-867e-4297-9ead-36d2480259b9" />
<img width="703" height="518" alt="Снимок экрана 2026-03-31 174631" src="https://github.com/user-attachments/assets/c99da0c2-1aef-4f8a-83dc-61e64e14aaf8" />

## Задание 6

"preemptible = true" Это означает, что ВМ — прерываемая (preemptible). Cтоит значительно дешевле и может быть остановлена в любой момент (без предупреждения). Если коротко то можно поднимать ВМ “на время практики” и не переплачивать

"core_fraction = 5" Это ограничение CPU — доля использования ядра. Чем больше знначение, тем быстрее и дорожа ВМ обходится

## Задание 2
<img width="944" height="290" alt="image" src="https://github.com/user-attachments/assets/411f3bdb-50e2-4940-ace6-458fd9d37fb1" />

## Задание 3
<img width="1814" height="156" alt="image" src="https://github.com/user-attachments/assets/6ffc5190-2369-41d0-9d8c-031d59cb0dca" />


## Задание 4
<img width="496" height="224" alt="image" src="https://github.com/user-attachments/assets/dfa5a3a9-ee4e-432b-a4ed-387023dd8644" />

## Задание 5
<img width="768" height="179" alt="image" src="https://github.com/user-attachments/assets/db5de64d-4e42-486c-9f53-e171db2c9912" />

## Задание 6
<img width="1136" height="112" alt="image" src="https://github.com/user-attachments/assets/c106eeb7-88c8-43db-927b-ec82df0f9221" />

## Код 

# main.tf

# Существующая сеть
data "yandex_vpc_network" "existing" {
  name      = var.existing_network_name
  folder_id = var.folder_id
}

# Подсеть для первой ВМ (web)
resource "yandex_vpc_subnet" "develop" {
  name           = "develop-web-subnet"
  zone           = var.default_zone
  network_id     = data.yandex_vpc_network.existing.id
  v4_cidr_blocks = var.default_cidr
}

# Подсеть для второй ВМ (db)
resource "yandex_vpc_subnet" "develop_db" {
  name           = "develop-db-subnet"
  zone           = "ru-central1-b"
  network_id     = data.yandex_vpc_network.existing.id
  v4_cidr_blocks = ["10.0.2.0/24"]
}

# Образ Ubuntu
data "yandex_compute_image" "ubuntu" {
  family = var.vm_web_image_family
}

# ВМ Web
resource "yandex_compute_instance" "platform" {
  name                      = local.vm_web_full_name
  zone                      = var.default_zone
  platform_id               = var.vm_web_platform_id
  allow_stopping_for_update = true

  resources {
    cores         = var.vms_resources["web"].cores
    memory        = var.vms_resources["web"].memory
    core_fraction = var.vms_resources["web"].core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
      size     = var.vms_resources["web"].hdd_size
      type     = var.vms_resources["web"].hdd_type
    }
  }

  scheduling_policy {
    preemptible = var.vm_web_preemptible
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = true
  }

  metadata = merge(
  var.metadata,
  {
    "ssh-keys" = "ubuntu:${var.vms_ssh_root_key}"
  }
)
}

# ВМ DB
resource "yandex_compute_instance" "platform_db" {
  name        = local.vm_db_full_name
  zone        = "ru-central1-b"
  platform_id = var.vm_db_platform_id

  resources {
    cores         = var.vms_resources["db"].cores
    memory        = var.vms_resources["db"].memory
    core_fraction = var.vms_resources["db"].core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
      size     = var.vms_resources["db"].hdd_size
      type     = var.vms_resources["db"].hdd_type
    }
  }

  scheduling_policy {
    preemptible = var.vm_db_preemptible
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.develop_db.id
    nat       = true
  }

  metadata = var.metadata
}


# outputs.tf

output "vms_info" {
  value = [
    {
      name       = yandex_compute_instance.platform.name
      external_ip = yandex_compute_instance.platform.network_interface[0].nat_ip_address
      fqdn       = yandex_compute_instance.platform.fqdn
    },
    {
      name       = yandex_compute_instance.platform_db.name
      external_ip = yandex_compute_instance.platform_db.network_interface[0].nat_ip_address
      fqdn       = yandex_compute_instance.platform_db.fqdn
    }
  ]
}


# providers.tf
terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = "~>1.12.0"
}


provider "yandex" {
  token     = "(мой токен, скрыл для безопастности)"
  folder_id = var.folder_id
  zone      = var.default_zone
}

# variables.tf

### cloud vars
variable "cloud_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}

variable "default_cidr" {
  type        = list(string)
  default     = ["10.0.1.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "existing_network_name" {
  type        = string
  default     = "default"
  description = "Name of the existing VPC network to use"
}

### ssh vars
variable "vms_ssh_root_key" {
  type        = string
  default     = "(ssh key, скрыл для безопасости)"
  description = "ssh-keygen -t ed25519"
}

### ВМ Web
variable "vm_web_name" {
  type    = string
  default = "netology-develop-platform-web"
}

variable "vm_web_platform_id" {
  type    = string
  default = "standard-v3"
}

variable "vm_web_image_family" {
  type    = string
  default = "ubuntu-2004-lts"
}

variable "vm_web_preemptible" {
  type    = bool
  default = true
}

### ВМ DB
variable "vm_db_name" {
  type    = string
  default = "netology-develop-platform-db"
}

variable "vm_db_platform_id" {
  type    = string
  default = "standard-v3"
}

variable "vm_db_preemptible" {
  type    = bool
  default = true
}

### Map переменная для ресурсов всех ВМ
variable "vms_resources" {
  type = map(object({
    cores         = number
    memory        = number
    core_fraction = number
    hdd_size      = number
    hdd_type      = string
  }))
  default = {
    web = {
      cores         = 2
      memory        = 2
      core_fraction = 100
      hdd_size      = 10
      hdd_type      = "network-hdd"
    }
    db = {
      cores         = 2
      memory        = 2
      core_fraction = 20
      hdd_size      = 10
      hdd_type      = "network-hdd"
    }
  }
}

### Общий metadata для всех ВМ
variable "metadata" {
  type = map(any)
  default = {
    "serial-port-enable" = 1
  }
}
