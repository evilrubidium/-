
## Задание 0
<img width="1024" height="337" alt="Снимок экрана 2026-03-31 115137" src="https://github.com/user-attachments/assets/5606a16a-697d-4d38-bb77-9b9d8e0b8926" />

## Задание 1
2. terraform.tfvars - т.к. он не попадает в git и он как раз таки предназначен для для переменных (логины, пароли, токены)

3. <img width="1190" height="398" alt="Снимок экрана 2026-03-31 125156" src="https://github.com/user-attachments/assets/55321b65-b33e-4303-a144-3039b9a3c696" />

<img width="553" height="410" alt="Снимок экрана 2026-03-31 125908" src="https://github.com/user-attachments/assets/b4bed8f8-42eb-46d2-b7a3-2d40fd91042f" />

4.<img width="945" height="349" alt="Снимок экрана 2026-03-31 130523" src="https://github.com/user-attachments/assets/9010c07b-b352-4e22-849d-83f3d875162c" />
resource "docker_image" { - ресурса должен быть еще один параметр, поэтому меняем на (resource "docker_image" "nginx" {)
resource "docker_container" "1nginx" { - в Terraform имя ресурса не может начинаться с цифры, поэтому меняем на (resource "docker_container" "nginx" {)
image = docker_image.nginx.image_id - неправельная image, поэтому меняем на (image = docker_image.nginx.name)
random_password.random_string_FAKE.resulT - здесь неверная ссылка на пароль, поэтому меняем на (random_password.random_string.result)
После всех исправлений нас ждем это окно
<img width="666" height="93" alt="Снимок экрана 2026-03-31 131508" src="https://github.com/user-attachments/assets/0782a488-c578-4604-9826-06ee94339121" />

5.
resource "docker_image" "nginx" {
  name         = "nginx:latest"
  keep_locally = true
}

resource "docker_container" "nginx" {
  image = docker_image.nginx.name
  name  = "example_${random_password.random_string.result}"

  ports {
    internal = 80
    external = 9090
  }
}
<img width="1005" height="274" alt="Снимок экрана 2026-03-31 131820" src="https://github.com/user-attachments/assets/6236af9e-5b3f-43d0-ba9e-ba380c7f47e4" />
<img width="1029" height="91" alt="image" src="https://github.com/user-attachments/assets/061094a4-bee4-48fb-aee6-2669db49bddf" />

6.
<img width="1029" height="91" alt="Снимок экрана 2026-03-31 131907" src="https://github.com/user-attachments/assets/f56ad87a-4526-4eb7-a10a-d028e1f1d151" />
<img width="900" height="208" alt="Снимок экрана 2026-03-31 132129" src="https://github.com/user-attachments/assets/beacdf76-4f46-475c-a4b1-67d35ef4530d" />
<img width="923" height="86" alt="Снимок экрана 2026-03-31 132150" src="https://github.com/user-attachments/assets/188f686e-56e5-4a38-8f48-8886cfadbacc" />
Ключ -auto-approve выполняет применение изменений без подтверждения пользователя. Т.е. можно случайно удалить ресурсы, можно создать платные ресурсы в облаке. Используется для CI/CD (автоматические деплои), скриптов и автоматизации и когда не требуется ручное подтверждение

7. <img width="992" height="216" alt="Снимок экрана 2026-03-31 132752" src="https://github.com/user-attachments/assets/45e739a2-8129-4386-90f6-f6d3c99157d8" />
<img width="1277" height="686" alt="Снимок экрана 2026-03-31 132829" src="https://github.com/user-attachments/assets/79e131a9-f180-45ad-a384-1e3632608fec" />
8. resource "docker_image" "nginx" {
  name         = "nginx:latest"
  keep_locally = true
}
мы поставили   keep_locally = true, поэтому образ польностью не удалился
Подтверждение из документации Terraform (docker provider):
keep_locally (Boolean)
If true, then the Docker image won't be deleted on destroy.
