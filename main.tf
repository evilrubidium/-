
# Использую существующую сеть (default)
data "yandex_vpc_network" "default" {
  name = "default"
}

# Подсеть
resource "yandex_vpc_subnet" "develop" {
  name           = var.vpc_name
  zone           = var.default_zone
  network_id     = data.yandex_vpc_network.default.id
  v4_cidr_blocks = var.default_cidr
}