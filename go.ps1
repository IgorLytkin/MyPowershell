# ������ �������� ssh-������ �� ��������� Linux-�������
# Copyright (C) 2023 Igor Lytkin
# ��������: https://winitpro.ru/index.php/2019/10/29/windows-ssh-tunneling/

# ����������
$ServerFqdn = 'singularity.lytkins.ru'
$UbuntuUserName = 'liv'
$Ports = '22','5432','5433','6379','7687'

# ��������� ������� ssh-������� �� ������ � �� Windows
Get-WindowsCapability -Online | ? Name -like 'OpenSSH.Client*'

# ������� ��� �������� ssh.exe
Stop-Process -Name ssh -Force -ErrorAction SilentlyContinue

# ������������� ssh-�������
$ComputerName = $env:computername
if ($ComputerName = "IGOR2022") { # ������� HP
    $KeysFolder = "D:\Yandex\igor.lytkin.2020\YandexDisk\Singularity\Keys\2023\ed25519\"
} elseif ($ComputerName = "IGOR2023") { # Beelink EQ12
    $KeysFolder = 'C:\Users\igorl\YandexDisk\Singularity\Keys\2023\ed25519\'
}
$SecretKey     = $KeysFolder + 'id_ed25519'
$SecretKeyPpk  = $SecretKey + '.ppk'
Write-Host '��� ����������:', $ComputerName
Write-Host '��������� ssh-����:', $SecretKey
Write-Host '��������� ssh-���� (��� pagent):', $SecretKeyPpk

# ���� �� ������� ������, ������� ssh-������� �� ����
Write-Host '������ ssh-������� ��� ������ ',$Ports
foreach ($i in $Ports) {
    $s_Port = $i+":localhost:"+$i
    Write-Host "������� ����� localost :",$i,"->",$ServerFqdn,":",$i
    ssh -L $s_Port -v -i $SecretKey -N -f -l $UbuntuUserName  $ServerFqdn
}

# ��������� ��������� ���� � passphrase � Pageant
Start-Process "pageant.exe" -ArgumentList $SecretKeyPpk -PassThru

# ������� ��������� ����� ����� �������� �������� � putty
Start-Sleep -Seconds 5

# ��������� �������� putty.exe
for ($j = 1, $j -le 2, $j++) {
    Start-Process "putty.exe" -ArgumentList "-ssh -i $SecretKeyPpk -l liv -L 22:localhost:22" -NoNewWindow
}