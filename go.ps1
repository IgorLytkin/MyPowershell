# Скрипт проброса ssh-портов до заданного Linux-сервера
# Copyright (C) 2023 Igor Lytkin
# Источник: https://winitpro.ru/index.php/2019/10/29/windows-ssh-tunneling/

# Переменные
$ServerFqdn = "singularity.lytkins.ru"
$UbuntuUserName = "liv"
$Ports = "22","5432","5433","6379","7687"
$LocalComputerName = $env:ComputerName
# $PassPhrase = Read-Host -Prompt "SSH Key Passphraze: " -AsSecureString

# Проверяем наличие ssh-клиента на машине с ОС Windows
Get-WindowsCapability -Online | Where-Object Name -like 'OpenSSH.Client*'

# Убиваем все процессы ssh.exe, pagent.exe, putty.exe
Stop-Process -Name ssh -Force -ErrorAction SilentlyContinue
Stop-Process -Name pagent -Force -ErrorAction SilentlyContinue
Stop-Process -Name putty -Force -ErrorAction SilentlyContinue

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

# Добавляем секретный ключ в ssh-agent
ssh-add -v $SecretKey
# TODO Анализ кода возврата

# Цикл по номерам портов, создаем ssh-туннель на порт
Write-Host 'Создаём ssh-туннели для портов ',$Ports
foreach ($i in $Ports) {
    Write-Host $i
    $s_Port = $i+":localhost:"+$i
    Write-Host $s_Port
    $s = "Проброс порта localost :",$i,"->",$ServerFqdn,":",$i
    Write-Host
    Write-Host $s
    Write-Host
    ssh -L $s_Port -v -i $SecretKey -N -f -l $UbuntuUserName  $ServerFqdn
    # TODO: анализ кода возврата ssh.exe

}

# Загружаем секретный ключ с passphrase в Pageant
Start-Process "pageant.exe" -ArgumentList $SecretKeyPpk -PassThru
# TODO: анализ кода возврата pagent.exe

# Ожидаем некоторое время перед запуском туннелей и putty
Start-Sleep -Seconds 5

# Запускаем процессы putty.exe
for ($j = 1;$j -le 2;$j++) {
    Write-Host  'Запуск Putty #',$j
    Start-Process "putty.exe" -ArgumentList "-ssh -i $SecretKeyPpk -l liv -L 22:localhost:22" -NoNewWindow
    # TODO: анализ кода возврата putty.exe
}
