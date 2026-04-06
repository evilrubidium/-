resource "yandex_compute_instance" "web" {
  count       = 2
  name        = "web-${count.index + 1}" # web-1, web-2
  platform_id = "standard-v1"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd8nn389itrf54ofq31g"
      size     = 10
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
