# Убиваем все процессы ssh.exe
Stop-Process -Name ssh -Force -ErrorAction SilentlyContinue

# Устанавливаем ssh-туннели
$SecretKey = "D:\Yandex\igor.lytkin.2020\YandexDisk\Singularity\Keys\2023\ed25519\id_ed25519"
ssh -L 22:localhost:22 -v -i $SecretKey -N -f -l liv singularity.lytkins.ru
ssh -L 5432:localhost:5432 -v -i $SecretKey -N -f -l liv singularity.lytkins.ru
ssh -L 5433:localhost:5433 -v -i $SecretKey -N -f -l liv singularity.lytkins.ru
ssh -L 6379:localhost:6379 -v -i $SecretKey -N -f -l liv singularity.lytkins.ru
ssh -L 7687:localhost:7687 -v -i $SecretKey -N -f -l liv singularity.lytkins.ru

# Загружаем секретный ключ с passphrase в Pageant
$SecretKeyPpk = "D:\Yandex\igor.lytkin.2020\YandexDisk\Singularity\Keys\2023\ed25519\id_ed25519.ppk"

Start-Process "pageant.exe" -ArgumentList $SecretKeyPpk -PassThru 
# | Wait-Process

# Ожидаем некоторое время перед запуском туннелей и putty
Start-Sleep -Seconds 5

# Запускаем процессы putty.exe
Start-Process "putty.exe" -ArgumentList "-ssh -i $SecretKeyPpk -l liv -L 22:localhost:22 -m script1.sh" -NoNewWindow
Start-Process "putty.exe" -ArgumentList "-ssh -i $SecretKeyPpk -l liv -L 22:localhost:22 -m script2.sh" -NoNewWindow


