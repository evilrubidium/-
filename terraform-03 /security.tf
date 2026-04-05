# Получил существующую сеть по имени
data "yandex_vpc_network" "existing" {
  name      = "default"  
  folder_id = var.folder_id
}

# Создал подсеть в существующей сети
resource "yandex_vpc_subnet" "develop_subnet" {
  name           = "develop-subnet"
  zone           = var.zone
  network_id     = data.yandex_vpc_network.existing.id
  v4_cidr_blocks = ["10.0.0.0/24"]
  folder_id      = var.folder_id
}

# Создал security group в существующей сети
resource "yandex_vpc_security_group" "example" {
  name       = "example_dynamic"
  network_id = data.yandex_vpc_network.existing.id
  folder_id  = var.folder_id

  dynamic "ingress" {
    for_each = var.security_group_ingress
    content {
      protocol       = lookup(ingress.value, "protocol", null)
      description    = lookup(ingress.value, "description", null)
      port           = lookup(ingress.value, "port", null)
      from_port      = lookup(ingress.value, "from_port", null)
      to_port        = lookup(ingress.value, "to_port", null)
      v4_cidr_blocks = lookup(ingress.value, "v4_cidr_blocks", null)
    }
  }

  dynamic "egress" {
    for_each = var.security_group_egress
    content {
      protocol       = lookup(egress.value, "protocol", null)
      description    = lookup(egress.value, "description", null)
      port           = lookup(egress.value, "port", null)
      from_port      = lookup(egress.value, "from_port", null)
      to_port        = lookup(egress.value, "to_port", null)
      v4_cidr_blocks = lookup(egress.value, "v4_cidr_blocks", null)
    }
  }
}
