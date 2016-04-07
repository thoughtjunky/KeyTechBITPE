echo off
wpeinit

echo Key Technology G6 CPU BurnInTest 1.01
echo WARNING: THIS TEST WILL ERASE ALL DATA ON PRIMARY DISK
echo ensure all ports and drives are ready for testing
echo 

:: Probe for Motherboard Model
for /f "tokens=1 skip=1" %%a in ('wmic baseboard get product') do find "%%a" currentbiosversions.txt
if errorlevel 1 goto altconfig
:: Probe for BIOS version
for /f "tokens=1 skip=1" %%b in ('wmic bios get smbiosbiosversion') do find "%%b" currentbiosversions.txt
if errorlevel 1 goto updatebios
goto setdisk


:altconfig
set motherboard=unsupported
if "%%a" == "S1200BTL" (
echo Motherboard not supported for WinPE BIOS update, EFI must be used instead
) else (
echo Motherboard not supported for BIOS update and configuration utilities
)

:setdisk 
:: Strip and reassign drive letters depending on configuration
diskpart /s volstrip.txt
if "%%a" == "S1200RP" (
diskpart /s diskpartGen5.txt
) else (
if exist E:/ diskpart /s diskpartGen4.txt
) else (
diskpart /s diskpartGen4dd.txt
)

:serial
time
date
set /p serialnumber=Serial Number:
:: Allow for manual diagnostics before we start erasing things
if "%serialnumber%" == "test" goto cmdline
goto setup

:setup
for /f "tokens=4 delims=;" %%d in ('find "%%b" currentbiosversions.txt') do %%d
if errorlevel 1 goto cmdline
echo successfully set BIOS configuration
:: Allow script to run powershell cmdlets (used for ejecting the CD)
powershell set-executionpolicy unrestricted
:: Map the network folder for logging BIT results
net use N: \\pxeserver\BITPE_LOGS password /user:admin

:setip
if exist N:\ goto online
netsh int ipv4 set address ethernet static 192.168.0.1 255.255.255.0 127.0.0.1
netsh int ipv4 set address "ethernet 2" static 192.168.0.2 255.255.255.0 127.0.0.1

if exist F:\ goto FW0
"x:\Program Files\BurnInTest\bit.exe" –h -x -r -c G6_SelftestDD.bitcfg
goto end
:FW0
"x:\Program Files\BurnInTest\bit.exe" –h -x -r -c G6_Selftest.bitcfg
goto end

:online
if exist F:\ goto FW1
"x:\Program Files\BurnInTest\bit.exe" –h -x -r -c G6_DD.bitcfg
goto end
:FW1
"x:\Program Files\BurnInTest\bit.exe" –h -x -r -c G6.bitcfg

:end
:: If something went wrong, don't shutdown
if errorlevel 1 goto cmdline
:: Erase all partition data from primary disk
diskpart /s diskclean.txt
:: Eject the CD
powershell eject
:: Test completed successfully
wpeutil shutdown

:updatebios
set /p biosupdate=BIOS version is not current, update BIOS?:
if "%biosupdate%" == "yes" goto upbios
if "%biosupdate%" == "no" goto setdisk
echo Please enter "yes" or "no"
goto updatebios

:upbios
if "%motherboard%" == "S1200BTL" goto altconfig
for /f "tokens=3 delims=;" %%c in ('find "%%a" currentbiosversions.txt') do %%c
if errorlevel 1 goto cmdline
pause BIOS update successful, press any key to reboot.
wpeutil reboot

:cmdline
