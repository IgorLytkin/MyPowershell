# ������ �������� ssh-������ �� ��������� Linux-�������
# Copyright (C) 2023 Igor Lytkin
# ��������: https://winitpro.ru/index.php/2019/10/29/windows-ssh-tunneling/

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
Stop-Process -Name pagent -Force -ErrorAction SilentlyContinue
Stop-Process -Name putty -Force -ErrorAction SilentlyContinue

# ������������� ssh-�������
if ($LocalComputerName -eq "IGOR2022") { # ������� HP
    $KeysFolder = "D:\Yandex\igor.lytkin.2020\YandexDisk\Singularity\Keys\2023\ed25519\"
} elseif ($LocalComputerName -eq "IGOR2023") { # Beelink EQ12
    $KeysFolder = 'C:\Users\igorl\YandexDisk\Singularity\Keys\2023\ed25519\'
}
$SecretKey     = $KeysFolder + 'id_ed25519'
$SecretKeyPpk  = $SecretKey + '.ppk'
Write-Host '��� ����������:', $LocalComputerName
Write-Host '��������� ssh-����:', $SecretKey
Write-Host '��������� ssh-���� (��� pagent):', $SecretKeyPpk

# ��������� ��������� ���� � ssh-agent
ssh-add -v $SecretKey
# TODO ������ ���� ��������

# ���� �� ������� ������, ������� ssh-������� �� ����
Write-Host '������ ssh-������� ��� ������ ',$Ports
foreach ($i in $Ports) {
    Write-Host $i
    $s_Port = $i+":localhost:"+$i
    Write-Host $s_Port
    $s = "������� ����� localost :",$i,"->",$ServerFqdn,":",$i
    Write-Host
    Write-Host $s
    Write-Host
    ssh -L $s_Port -v -i $SecretKey -N -f -l $UbuntuUserName  $ServerFqdn
    # TODO: ������ ���� �������� ssh.exe

}

# ��������� ��������� ���� � passphrase � Pageant
Start-Process "pageant.exe" -ArgumentList $SecretKeyPpk -PassThru
# TODO: ������ ���� �������� pagent.exe

# ������� ��������� ����� ����� �������� �������� � putty
Start-Sleep -Seconds 5

# ��������� �������� putty.exe
for ($j = 1;$j -le 2;$j++) {
    Write-Host  '������ Putty #',$j
    Start-Process "putty.exe" -ArgumentList "-ssh -i $SecretKeyPpk -l liv -L 22:localhost:22" -NoNewWindow
    # TODO: ������ ���� �������� putty.exe
}
