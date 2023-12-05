# Скрипт запуска на IGOR2023 (Beelink EQ)
# Убиваем все процессы ssh.exe
Stop-Process -Name ssh -Force -ErrorAction SilentlyContinue

# Устанавливаем ssh-туннели
Start-Process "ssh.exe" -ArgumentList "-fNt -L 22:localhost:22 -v -i C:\Users\igorl\YandexDisk\Singularity\Keys\2023\ed25519\id_ed25519  -l liv singularity.lytkins.ru"
Start-Process "ssh.exe" -ArgumentList "-fNt -L 5432:localhost:5432 -v -i C:\Users\igorl\YandexDisk\Singularity\Keys\2023\ed25519\id_ed25519 -l liv singularity.lytkins.ru"
Start-Process "ssh.exe" -ArgumentList "-fNt -L 5433:localhost:5433 -v -i C:\Users\igorl\YandexDisk\Singularity\Keys\2023\ed25519\id_ed25519 -l liv singularity.lytkins.ru"
Start-Process "ssh.exe" -ArgumentList "-fNt -L 6379:localhost:6379 -v -i C:\Users\igorl\YandexDisk\Singularity\Keys\2023\ed25519\id_ed25519 -l liv singularity.lytkins.ru"
Start-Process "ssh.exe" -ArgumentList "-fNt -L 7687:localhost:7687 -v -i C:\Users\igorl\YandexDisk\Singularity\Keys\2023\ed25519\id_ed25519 -l liv singularity.lytkins.ru"

# Загружаем секретный ключ с passphrase в Pageant
Start-Process "pageant.exe" -ArgumentList "C:\Users\igorl\YandexDisk\Singularity\Keys\2023\ed25519\id_ed25519.ppk" -PassThru

# Ожидаем некоторое время перед запуском туннелей и putty
Start-Sleep -Seconds 30

# Запускаем процессы putty.exe
Start-Process "putty.exe" -ArgumentList "-ssh -i C:\Users\igorl\YandexDisk\Singularity\Keys\2023\ed25519\id_ed25519.ppk -l liv -L 22:localhost:22 -m script1.sh" -NoNewWindow
Start-Process "putty.exe" -ArgumentList "-ssh -i C:\Users\igorl\YandexDisk\Singularity\Keys\2023\ed25519\id_ed25519.ppk -l liv -L 22:localhost:22 -m script2.sh" -NoNewWindow


                                                                                                                                                                      1