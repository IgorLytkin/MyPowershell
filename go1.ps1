# ������� ��� �������� ssh.exe
Stop-Process -Name ssh -Force -ErrorAction SilentlyContinue

# ������������� ssh-�������
if ($env:computername = "IGOR2022") { # ������� HP
    $SecretKey     = "D:\Yandex\igor.lytkin.2020\YandexDisk\Singularity\Keys\2023\ed25519\id_ed25519"
    $SecretKeyPpk  = "D:\Yandex\igor.lytkin.2020\YandexDisk\Singularity\Keys\2023\ed25519\id_ed25519.ppk"
} elseif ($env:computername = "IGOR2023") { # Beelink EQ12
    $SecretKey     = "C:\Users\igorl\YandexDisk\Singularity\Keys\2023\ed25519\id_ed25519"
    $SecretKeyPpk  = "C:\Users\igorl\YandexDisk\Singularity\Keys\2023\ed25519\id_ed25519.ppk"
}

$Ports = 22,5432,5433,6379,7687
foreach ($i in $Ports) {
    ssh -L $i:localhost:$i -v -i $SecretKey -N -f -l liv singularity.lytkins.ru
}

# ��������� ��������� ���� � passphrase � Pageant
Start-Process "pageant.exe" -ArgumentList $SecretKeyPpk -PassThru

# ������� ��������� ����� ����� �������� �������� � putty
Start-Sleep -Seconds 5

# ��������� �������� putty.exe
for ($i = 1, $i -le 2, $i++) {
    Start-Process "putty.exe" -ArgumentList "-ssh -i $SecretKeyPpk -l liv -L 22:localhost:22 -m script" + $i + ".sh" -NoNewWindow
}



