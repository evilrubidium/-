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
