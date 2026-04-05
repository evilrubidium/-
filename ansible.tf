locals {
  # Сформировал список VM для веб-серверов
  web_instances = [
    for i, instance in yandex_compute_instance.web : {
      name        = instance.name
      external_ip = instance.network_interface[0].nat_ip_address
      fqdn        = "${instance.hostname}.${var.zone}.internal" # если hostname есть
    }
  ]

  # Список VM для баз данных
  db_instances = [
    for vm in yandex_compute_instance.db : {
      name        = vm.name
      external_ip = vm.network_interface[0].nat_ip_address
      fqdn        = "${vm.hostname}.${var.zone}.internal"
    }
  ]

  # Список для storage VM
  storage_instances = [
    {
      name        = yandex_compute_instance.storage.name
      external_ip = yandex_compute_instance.storage.network_interface[0].nat_ip_address
      fqdn        = "${yandex_compute_instance.storage.hostname}.${var.zone}.internal"
    }
  ]
}

# Генерация inventory файла
resource "local_file" "ansible_inventory" {
  content  = templatefile("${path.module}/inventory.tpl", {
    web_instances     = local.web_instances
    db_instances      = local.db_instances
    storage_instances = local.storage_instances
  })
  filename = "${path.module}/inventory.ini"
}
