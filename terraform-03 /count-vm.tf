resource "yandex_compute_instance" "web" {
  count       = var.web_vm_count
  name        = "web-${count.index + 1}"
  platform_id = var.platform_id

  resources {
    cores  = var.web_vm_resources.cores
    memory = var.web_vm_resources.memory
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.id
      size     = var.web_vm_disk_size
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.develop_subnet.id
    security_group_ids = [yandex_vpc_security_group.example.id]
    nat                = true
  }

  metadata = {
    ssh-keys = "ubuntu:${local.ssh_pub_key}"
  }

  depends_on = [yandex_compute_instance.db]
}
