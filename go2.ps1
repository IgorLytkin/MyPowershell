# ������ ������� �� IGOR2023 (Beelink EQ)
# ������� ��� �������� ssh.exe
Stop-Process -Name ssh -Force -ErrorAction SilentlyContinue

# ������������� ssh-�������
Start-Process "ssh.exe" -ArgumentList "-fNt -L 22:localhost:22 -v -i C:\Users\igorl\YandexDisk\Singularity\Keys\2023\ed25519\id_ed25519  -l liv singularity.lytkins.ru"
Start-Process "ssh.exe" -ArgumentList "-fNt -L 5432:localhost:5432 -v -i C:\Users\igorl\YandexDisk\Singularity\Keys\2023\ed25519\id_ed25519 -l liv singularity.lytkins.ru"
Start-Process "ssh.exe" -ArgumentList "-fNt -L 5433:localhost:5433 -v -i C:\Users\igorl\YandexDisk\Singularity\Keys\2023\ed25519\id_ed25519 -l liv singularity.lytkins.ru"
Start-Process "ssh.exe" -ArgumentList "-fNt -L 6379:localhost:6379 -v -i C:\Users\igorl\YandexDisk\Singularity\Keys\2023\ed25519\id_ed25519 -l liv singularity.lytkins.ru"
Start-Process "ssh.exe" -ArgumentList "-fNt -L 7687:localhost:7687 -v -i C:\Users\igorl\YandexDisk\Singularity\Keys\2023\ed25519\id_ed25519 -l liv singularity.lytkins.ru"

# ��������� ��������� ���� � passphrase � Pageant
Start-Process "pageant.exe" -ArgumentList "C:\Users\igorl\YandexDisk\Singularity\Keys\2023\ed25519\id_ed25519.ppk" -PassThru

# ������� ��������� ����� ����� �������� �������� � putty
Start-Sleep -Seconds 30

# ��������� �������� putty.exe
Start-Process "putty.exe" -ArgumentList "-ssh -i C:\Users\igorl\YandexDisk\Singularity\Keys\2023\ed25519\id_ed25519.ppk -l liv -L 22:localhost:22 -m script1.sh" -NoNewWindow
Start-Process "putty.exe" -ArgumentList "-ssh -i C:\Users\igorl\YandexDisk\Singularity\Keys\2023\ed25519\id_ed25519.ppk -l liv -L 22:localhost:22 -m script2.sh" -NoNewWindow


                                                                                                                                                                      1