#!/bin/bash
#
# MODIFIKASI By BangMam
#
echo "Pilih OS yang ingin anda install"
echo "	1) Windows 2019 Password : Botol123456789!"
echo "	2) Windows 2016 Password : Nixpoin.com123!"
echo "	3) Windows 2012 Password : Nixpoin.com123!"
echo "	4) Windows 10"
echo "	5) Windows 2022"
echo "	6) Windows 2019 Password : P@ssword64"
echo "	7) Pakai link gz mu sendiri"

read -p "Pilih [1]: " PILIHOS

case "$PILIHOS" in
	1|"") PILIHOS="https://download1511.mediafire.com/w3qxhvst0hagzzCX8SQtNf_0UcPzp7unpfhJVu3_wtsV2pMiiEzJizjrJhb8EOYWkD1gO49Gfu9Vbx7Xplr8Mx1oAOUiV-NE3rrXV80YVB9imjT0NKXVFyJBR-hN00_lpFAzEkQTAwerg7ejmtwc7WCL5pVceuZswczjYWWbFrUA/oi1bb1p9heg6sbm/windows2019DO.gz"  IFACE="Ethernet Instance 0";;
	2) PILIHOS="https://download1503.mediafire.com/icmvfi3kw0yg225FMiMBo55j53ukdt_hRzP_yb__S_t-dVKqq3YZKZbgSH4pjtvTzV73dSt12XK4oBFszTC4-fi6cBBgnHzyHBcrBWhgK30607R251dtlvE9Fhl5TiuVt1ngVIufFaxprifGyKWK9AURQcTUnejUgQe6bKbMd-Tl1vE/s8zxdghgha8m2wj/windows2016.gz"  IFACE="Ethernet Instance 0 2";;
	3) PILIHOS="https://download1349.mediafire.com/7e0d40pgxylg0suMFCA363KENgIe0cKuCWG7GRubeU9ROEmc-4wz2pgeaKyQCcPLb-q7I3Vn66pFJxX2uuf0wni5Hp5WB9viIkJnhm33MVbpaPfuq4YYZ1vV8HP0jXG0gjgdlvlUfpsCyUqT1isQTC2dRBaHMAusou30Ycrp3pXN/66rpxhj70pe3olc/windows2012v2.gz"  IFACE="Ethernet Instance 0";;
	4) PILIHOS="https://files.sowan.my.id/windows10.gz"  IFACE="Ethernet Instance 0 2";;
	5) PILIHOS="https://files.sowan.my.id/windows2022.gz"  IFACE="Ethernet Instance 0 2";;
        6) PILIHOS="https://download1349.mediafire.com/vi33u31onrsg56NlxqFTv6EsChol8dhGY-mU8Kqf0AHReK5h4DOhwOWvFJTTPUiWbYl0JmqYneEs_iWSTqxn2FMq2Dll805G1SYwfA7yIU2M1rA3rqmXuWOxIs73SwMZjTMRzu1G8-zoa-rNBdSpGtW4bNHau42zRhjpS5KaZjep2nw/r0h9kuzoxq7rp19/windows19.gz"  IFACE="Ethernet Instance 0 2";;
	7) read -p "Masukkan Link GZ mu : " PILIHOS;;
	*) echo "pilihan salah"; exit;;
esac

echo "Gunakan script ini dengan bijak, jika script ini mengalami masalah silahkan hubungi WA Admin 083117542926"

read -p "Masukkan password untuk akun Administrator: " PASSADMIN

IP4=$(curl -4 -s icanhazip.com)
GW=$(ip route | awk '/default/ { print $3 }')


cat >/tmp/net.bat<<EOF
@ECHO OFF
cd.>%windir%\GetAdmin
if exist %windir%\GetAdmin (del /f /q "%windir%\GetAdmin") else (
echo CreateObject^("Shell.Application"^).ShellExecute "%~s0", "%*", "", "runas", 1 >> "%temp%\Admin.vbs"
"%temp%\Admin.vbs"
del /f /q "%temp%\Admin.vbs"
exit /b 2)
net user Administrator $PASSADMIN


netsh -c interface ip set address name="$IFACE" source=static address=$IP4 mask=255.255.240.0 gateway=$GW
netsh -c interface ip add dnsservers name="$IFACE" address=1.1.1.1 index=1 validate=no
netsh -c interface ip add dnsservers name="$IFACE" address=8.8.4.4 index=2 validate=no

cd /d "%ProgramData%/Microsoft/Windows/Start Menu/Programs/Startup"
del /f /q net.bat
exit
EOF


cat >/tmp/dpart.bat<<EOF
@ECHO OFF
echo JENDELA INI JANGAN DITUTUP
echo SCRIPT INI AKAN MERUBAH PORT RDP MENJADI 5000, SETELAH RESTART UNTUK MENYAMBUNG KE RDP GUNAKAN ALAMAT $IP4:5000
echo KETIK YES LALU ENTER!

cd.>%windir%\GetAdmin
if exist %windir%\GetAdmin (del /f /q "%windir%\GetAdmin") else (
echo CreateObject^("Shell.Application"^).ShellExecute "%~s0", "%*", "", "runas", 1 >> "%temp%\Admin.vbs"
"%temp%\Admin.vbs"
del /f /q "%temp%\Admin.vbs"
exit /b 2)

set PORT=5000
set RULE_NAME="Open Port %PORT%"

netsh advfirewall firewall show rule name=%RULE_NAME% >nul
if not ERRORLEVEL 1 (
    rem Rule %RULE_NAME% already exists.
    echo Hey, you already got a out rule by that name, you cannot put another one in!
) else (
    echo Rule %RULE_NAME% does not exist. Creating...
    netsh advfirewall firewall add rule name=%RULE_NAME% dir=in action=allow protocol=TCP localport=%PORT%
)

reg add "HKLM\System\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" /v PortNumber /t REG_DWORD /d 5000

ECHO SELECT VOLUME=%%SystemDrive%% > "%SystemDrive%\diskpart.extend"
ECHO EXTEND >> "%SystemDrive%\diskpart.extend"
START /WAIT DISKPART /S "%SystemDrive%\diskpart.extend"

del /f /q "%SystemDrive%\diskpart.extend"
cd /d "%ProgramData%/Microsoft/Windows/Start Menu/Programs/Startup"
del /f /q dpart.bat
timeout 50 >nul
del /f /q ChromeSetup.exe
echo JENDELA INI JANGAN DITUTUP
exit
EOF

wget --no-check-certificate -O- $PILIHOS | gunzip | dd of=/dev/vda bs=3M status=progress

mount.ntfs-3g /dev/vda2 /mnt
cd "/mnt/ProgramData/Microsoft/Windows/Start Menu/Programs/"
cd Start* || cd start*; \
wget https://dl.google.com/tag/s/appguid%3D%7B8A69D345-D564-463C-AFF1-A69D9E530F96%7D%26iid%3D%7B45F92F00-8E63-6F7A-4CD7-F00E4683C4AD%7D%26lang%3Did%26browser%3D4%26usagestats%3D1%26appname%3DGoogle%2520Chrome%26needsadmin%3Dprefers%26ap%3Dx64-statsdef_1%26installdataindex%3Dempty/update2/installers/ChromeSetup.exe
cp -f /tmp/net.bat net.bat
cp -f /tmp/dpart.bat dpart.bat

echo 'Your server will turning off in 3 second'
sleep 3
poweroff
