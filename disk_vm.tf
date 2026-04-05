# Подключил образ Ubuntu через data source
data "yandex_compute_image" "ubuntu" {
  family = "ubuntu-2204-lts"
}

# Создал 3 одинаковых диска размером 1 Гб
resource "yandex_compute_disk" "extra_disks" {
  count     = 3
  name      = "extra-disk-${count.index + 1}"
  size      = 1
  type      = "network-ssd"
  zone      = var.zone
  folder_id = var.folder_id
}

# Создал VM "storage" и подключаем к ней дополнительные диски
resource "yandex_compute_instance" "storage" {
  name        = "storage"
  platform_id = "standard-v1"
  folder_id   = var.folder_id
  zone        = var.zone

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.id
      size     = 10
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.develop_subnet.id
    nat       = true
  }

  # Динамически подключил созданные диски
  dynamic "secondary_disk" {
    for_each = yandex_compute_disk.extra_disks
    content {
      disk_id     = secondary_disk.value.id
      device_name = secondary_disk.value.name
    }
  }
}