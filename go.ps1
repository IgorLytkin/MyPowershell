# Скрипт проброса ssh-портов до заданного Linux-сервера
# Copyright (C) 2023 Igor Lytkin
# Источник: https://winitpro.ru/index.php/2019/10/29/windows-ssh-tunneling/
# Используемые файлы:
# 1. Комплект ssh-ключей пользователя
# 2. %USERPROFILE%\.ssh\known_hosts - список известных хостов

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
Stop-Process -Name pageant -Force -ErrorAction SilentlyContinue
Stop-Process -Name putty -Force -ErrorAction SilentlyContinue

# Запускаем PAgent.exe, загружаем секретный ключ в формате .ppk
# https://putty.org.ru/manual/chapter9
Start-Process "pageant.exe" -ArgumentList "$SecretKeyPpk -restrict-acl" -PassThru

# Устанавливаем ssh-туннели
if ($LocalComputerName -eq "IGOR2022") { # Ноутбук HP
    $KeysFolder = "D:\Yandex\igor.lytkin.2020\YandexDisk\Singularity\Keys\2023\rsa\"
    $TcpView = 'd:\Dist\SysinternalsSuite\tcpview64.exe'
} elseif ($LocalComputerName -eq "IGOR2023") { # Beelink EQ12
    $KeysFolder = 'C:\Users\igorl\YandexDisk\Singularity\Keys\2023\rsa\'
    $TcpView = 'c:\Dist\SysinternalsSuite\tcpview64.exe'
}
$SecretKey     = $KeysFolder + 'ssh_host_rsa_key'
$SecretKeyPpk  = $SecretKey + '.ppk'
Write-Host 'Имя компьютера:', $LocalComputerName
Write-Host 'Секретный ssh-ключ:', $SecretKey
Write-Host 'Секретный ssh-ключ (для pagent):', $SecretKeyPpk

# Добавляем секретный ключ в ssh-agent
# Start-Process -FilePath "C:\WINDOWS\System32\OpenSSH\ssh-add.exe" -ArgumentList "-v $SecretKey"
# TODO Анализ кода возврата

# Запуск TcpView64
# -e - RunAs Administrator
Write-Host 'Запуск TcpView64'
Write-Host $TcpView
Start-Process -FilePath $TcpView -ArgumentList "-e"

# Цикл по номерам портов, создаем ssh-туннель на порт
Write-Host 'Создаём ssh-туннели для портов ',$Ports
foreach ($i in $Ports) {
    Write-Host $i
    $s_Port = $i+":localhost:"+$i
    Write-Host $s_Port
    $s = "Проброс порта localost :",$i,"->",$ServerFqdn,":",$i
    Write-Host $s
    Start-Process -FilePath "C:\WINDOWS\System32\OpenSSH\ssh.exe" `
                  -ArgumentList "-L $s_Port -v -i $SecretKey -fN -l $UbuntuUserName  $ServerFqdn" `
                  -NoNewWindow
    # TODO: анализ кода возврата ssh.exe
   Start-Sleep -Seconds 15
}

# Ожидаем некоторое время перед запуском туннелей и putty
# Start-Sleep -Seconds 30

# Запускаем процессы putty.exe
for ($j = 1;$j -le 3;$j++) {
    Write-Host  'Запуск Putty #', $j
    Start-Process "putty.exe" -ArgumentList "-ssh -i $SecretKeyPpk " # -l liv -L 22:localhost:22" -NoNewWindow
    # TODO: анализ кода возврата putty.exe
}


