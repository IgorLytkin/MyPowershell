# ������ �������� ssh-������ �� ��������� Linux-�������
# Copyright (C) 2023 Igor Lytkin
# ��������: https://winitpro.ru/index.php/2019/10/29/windows-ssh-tunneling/
# ������������ �����:
# 1. �������� ssh-������ ������������
# 2. %USERPROFILE%\.ssh\known_hosts - ������ ��������� ������

# ����������
$ServerFqdn = "singularity.lytkins.ru"
$UbuntuUserName = "liv"
$Ports = "22","5432","5433","6379","7687"
$LocalComputerName = $env:ComputerName
# $PassPhrase = Read-Host -Prompt "SSH Key Passphraze: " -AsSecureString

# ��������� ������� ssh-������� �� ������ � �� Windows
Get-WindowsCapability -Online | Where-Object Name -like 'OpenSSH.Client*'

# ������� ��� �������� ssh.exe, pagent.exe, putty.exe
Stop-Process -Name ssh -Force -ErrorAction SilentlyContinue
Stop-Process -Name pageant -Force -ErrorAction SilentlyContinue
Stop-Process -Name putty -Force -ErrorAction SilentlyContinue

# ��������� PAgent.exe, ��������� ��������� ���� � ������� .ppk
# https://putty.org.ru/manual/chapter9
Start-Process "pageant.exe" -ArgumentList "$SecretKeyPpk -restrict-acl" -PassThru

# ������������� ssh-�������
if ($LocalComputerName -eq "IGOR2022") { # ������� HP
    $KeysFolder = "D:\Yandex\igor.lytkin.2020\YandexDisk\Singularity\Keys\2023\rsa\"
    $TcpView = 'd:\Dist\SysinternalsSuite\tcpview64.exe'
} elseif ($LocalComputerName -eq "IGOR2023") { # Beelink EQ12
    $KeysFolder = 'C:\Users\igorl\YandexDisk\Singularity\Keys\2023\rsa\'
    $TcpView = 'c:\Dist\SysinternalsSuite\tcpview64.exe'
}
$SecretKey     = $KeysFolder + 'ssh_host_rsa_key'
$SecretKeyPpk  = $SecretKey + '.ppk'
Write-Host '��� ����������:', $LocalComputerName
Write-Host '��������� ssh-����:', $SecretKey
Write-Host '��������� ssh-���� (��� pagent):', $SecretKeyPpk

# ��������� ��������� ���� � ssh-agent
# Start-Process -FilePath "C:\WINDOWS\System32\OpenSSH\ssh-add.exe" -ArgumentList "-v $SecretKey"
# TODO ������ ���� ��������

# ������ TcpView64
# -e - RunAs Administrator
Write-Host '������ TcpView64'
Write-Host $TcpView
Start-Process -FilePath $TcpView -ArgumentList "-e"

# ���� �� ������� ������, ������� ssh-������� �� ����
Write-Host '������ ssh-������� ��� ������ ',$Ports
foreach ($i in $Ports) {
    Write-Host $i
    $s_Port = $i+":localhost:"+$i
    Write-Host $s_Port
    $s = "������� ����� localost :",$i,"->",$ServerFqdn,":",$i
    Write-Host $s
    Start-Process -FilePath "C:\WINDOWS\System32\OpenSSH\ssh.exe" `
                  -ArgumentList "-L $s_Port -v -i $SecretKey -fN -l $UbuntuUserName  $ServerFqdn" `
                  -NoNewWindow
    # TODO: ������ ���� �������� ssh.exe
   Start-Sleep -Seconds 15
}

# ������� ��������� ����� ����� �������� �������� � putty
# Start-Sleep -Seconds 30

# ��������� �������� putty.exe
for ($j = 1;$j -le 3;$j++) {
    Write-Host  '������ Putty #', $j
    Start-Process "putty.exe" -ArgumentList "-ssh -i $SecretKeyPpk " # -l liv -L 22:localhost:22" -NoNewWindow
    # TODO: ������ ���� �������� putty.exe
}


