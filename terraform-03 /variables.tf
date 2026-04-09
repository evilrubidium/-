###cloud vars
variable "token" {
  type        = string
  description = "OAuth-token; https://cloud.yandex.ru/docs/iam/concepts/authorization/oauth-token"
}

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

variable "vpc_name" {
  type        = string
  default     = "develop"
  description = "VPC network&subnet name"
}

variable "vm_web_name" {
  type        = string
  description = "web VM"
}

variable "vm_db_name" {
  type        = string
  description = "DB VM"
}

variable "zone" {
  description = "Зона для создания ресурсов"
  type        = string
}

variable "security_group_ingress" {
  description = "Ingress rules for security group"
  type = list(object({
    protocol       = string
    description    = string
    v4_cidr_blocks = list(string)
    port           = optional(number)
    from_port      = optional(number)
    to_port        = optional(number)
  }))
  default = [
    {
      protocol       = "TCP"
      description    = "разрешить входящий SSH"
      v4_cidr_blocks = ["0.0.0.0/0"]
      port           = 22
    },
    {
      protocol       = "TCP"
      description    = "разрешить входящий HTTP"
      v4_cidr_blocks = ["0.0.0.0/0"]
      port           = 80
    },
    {
      protocol       = "TCP"
      description    = "разрешить входящий HTTPS"
      v4_cidr_blocks = ["0.0.0.0/0"]
      port           = 443
    }
  ]
}

variable "security_group_egress" {
  description = "Egress rules for security group"
  type = list(object({
    protocol       = string
    description    = string
    v4_cidr_blocks = list(string)
    port           = optional(number)
    from_port      = optional(number)
    to_port        = optional(number)
  }))
  default = [
    {
      protocol       = "TCP"
      description    = "разрешить весь исходящий трафик"
      v4_cidr_blocks = ["0.0.0.0/0"]
      from_port      = 0
      to_port        = 65365
    }
  ]
}

variable "each_vm" {
  type = list(object({
    vm_name     = string
    cpu         = number
    ram         = number
    disk_volume = number
  }))
  default = [
    { vm_name = "main",    cpu = 2, ram = 4, disk_volume = 20 },
    { vm_name = "replica", cpu = 2, ram = 2, disk_volume = 10 }
  ]
}

# Параметры VM 

variable "platform_id" {
  description = "Платформа VM"
  type        = string
  default     = "standard-v1"
}

variable "image_family" {
  description = "Семейство образа ОС"
  type        = string
  default     = "ubuntu-2204-lts"
}

# Web VM (count)

variable "web_vm_count" {
  description = "Количество web VM"
  type        = number
  default     = 2
}

variable "web_vm_resources" {
  description = "Ресурсы web VM"
  type = object({
    cores  = number
    memory = number
  })
  default = {
    cores  = 2
    memory = 2
  }
}

variable "web_vm_disk_size" {
  description = "Размер диска web VM"
  type        = number
  default     = 10
}

# Storage VM 

variable "storage_vm_name" {
  description = "Имя storage VM"
  type        = string
  default     = "storage"
}

variable "storage_vm_resources" {
  description = "Ресурсы storage VM"
  type = object({
    cores  = number
    memory = number
  })
  default = {
    cores  = 2
    memory = 2
  }
}

variable "storage_boot_disk_size" {
  description = "Размер загрузочного диска storage VM"
  type        = number
  default     = 10
}

# Доп диски

variable "disk_count" {
  description = "Количество дополнительных дисков"
  type        = number
  default     = 3
}

variable "disk_size" {
  description = "Размер дополнительного диска (ГБ)"
  type        = number
  default     = 1
}

variable "disk_type" {
  description = "Тип диска"
  type        = string
  default     = "network-ssd"
}

variable "disk_prefix" {
  description = "Префикс имени дисков"
  type        = string
  default     = "extra-disk"
}
