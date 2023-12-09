# Скрипт проброса ssh-портов до заданного Linux-сервера
# Copyright (C) 2023 Igor Lytkin
# Источник: https://winitpro.ru/index.php/2019/10/29/windows-ssh-tunneling/

# Переменные
$ServerFqdn = 'singularity.lytkins.ru'
$UbuntuUserName = 'liv'
$Ports = '22','5432','5433','6379','7687'
$LocalComputerName = $env:ComputerName

# Проверяем наличие ssh-клиента на машине с ОС Windows
Get-WindowsCapability -Online | Where-Object Name -like 'OpenSSH.Client*'

# Убиваем все процессы ssh.exe
Stop-Process -Name ssh -Force -ErrorAction SilentlyContinue

# Устанавливаем ssh-туннели
if ($LocalComputerName -eq "IGOR2022") { # Ноутбук HP
    $KeysFolder = "D:\Yandex\igor.lytkin.2020\YandexDisk\Singularity\Keys\2023\ed25519\"
} elseif ($LocalComputerName -eq "IGOR2023") { # Beelink EQ12
    $KeysFolder = 'C:\Users\igorl\YandexDisk\Singularity\Keys\2023\ed25519\'
}
$SecretKey     = $KeysFolder + 'id_ed25519'
$SecretKeyPpk  = $SecretKey + '.ppk'
Write-Host 'Имя компьютера:', $LocalComputerName
Write-Host 'Секретный ssh-ключ:', $SecretKey
Write-Host 'Секретный ssh-ключ (для pagent):', $SecretKeyPpk

# Цикл по номерам портов, создаем ssh-туннель на порт
Write-Host 'Создаём ssh-туннели для портов ',$Ports
foreach ($i in $Ports) {
    $s_Port = $i+":localhost:"+$i
    $s = "Проброс порта localost :",$i,"->",$ServerFqdn,":",$i
    Write-Host
    Write-Host $s
    Write-Host
    ssh -L $s_Port -v -i $SecretKey -N -f -l $UbuntuUserName  $ServerFqdn

    # TODO: анализ кода возврата ssh

}

# Загружаем секретный ключ с passphrase в Pageant
Start-Process "pageant.exe" -ArgumentList $SecretKeyPpk -PassThru

# Ожидаем некоторое время перед запуском туннелей и putty
Start-Sleep -Seconds 5

# Запускаем процессы putty.exe
for ($j = 1, $j -le 2, $j++) {
    Start-Process "putty.exe" -ArgumentList "-ssh -i $SecretKeyPpk -l liv -L 22:localhost:22" -NoNewWindow
}
