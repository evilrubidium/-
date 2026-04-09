# Data source
data "yandex_compute_image" "ubuntu" {
  family = var.image_family
}

# Диски
resource "yandex_compute_disk" "extra_disks" {
  count     = var.disk_count
  name      = "extra-disk-${count.index + 1}"
  size      = var.disk_size
  type      = var.disk_type
  zone      = var.zone
  folder_id = var.folder_id
}

# VM storage
resource "yandex_compute_instance" "storage" {
  name        = var.storage_vm_name
  platform_id = var.platform_id
  folder_id   = var.folder_id
  zone        = var.zone

  resources {
    cores  = var.storage_vm_resources.cores
    memory = var.storage_vm_resources.memory
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.id
      size     = var.storage_boot_disk_size
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.develop_subnet.id
    nat       = true
  }

  dynamic "secondary_disk" {
    for_each = yandex_compute_disk.extra_disks
    content {
      disk_id     = secondary_disk.value.id
      device_name = secondary_disk.value.name
    }
  }
}
