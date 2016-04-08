

:: If it's got 3 drives, it must have Firewire
if exist F:\ set fw=true

:: A nice message to our dear technician
echo Key Technology G6 CPU BurnInTest 1.01
echo WARNING: THIS TEST WILL ERASE ALL DATA ON PRIMARY DISK
echo ensure all ports and drives are ready for testing

:: the only thing that originally existed in this .cmd
wpeinit

:: Probe for Motherboard Model
for /f "tokens=1 skip=1" %%a in ('wmic baseboard get product') do type currentbiosversions.txt | findstr "%%a"
if errorlevel 1 goto altconfig
:: Probe for BIOS version
for /f "tokens=1 skip=1" %%b in ('wmic bios get smbiosbiosversion') do type currentbiosversions.txt | findstr "%%b"
if errorlevel 1 goto updatebios
goto setdisk

:updatebios
:: Currently only functions for Gen5
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

:altconfig
:: When BIOS can't be set automatically
set motherboard=unsupported
if "%%a" == "S1200BTL" (
echo Motherboard not supported for WinPE BIOS update, EFI or Deployment Assistant must be used instead
) else (
echo Motherboard not recognized
)
goto setdisk

:setdisk 
:: Strip and reassign drive letters depending on configuration
diskpart /s volstrip.txt
if "%%a" == "S1200RP" (
diskpart /s diskpartGen5.txt
) else (
if "%fw%" == "true" diskpart /s diskpartGen4.txt
) else (
diskpart /s diskpartGen4dd.txt
)

:serial
time
date
set /p serialnumber=Serial Number:
:: Allow for manual diagnostics before we start erasing things
if "%serialnumber%" == "test" goto cmdline
:: Set BIOS configuration if it's a Gen 5
if "%%a" == "S1200RP" for /f "tokens=4 delims=;" %%d in ('find "%%b" currentbiosversions.txt') do %%d
:: Allow powershell scripting (used for ejecting the CD)
powershell set-executionpolicy unrestricted
:: Map the network folder for logging BIT results
net use N: \\pxeserver\BITPE_LOGS password /user:admin

:setip
if exist N:\ goto online
netsh int ipv4 set address ethernet static 192.168.0.1 255.255.255.0 127.0.0.1
netsh int ipv4 set address "ethernet 2" static 192.168.0.2 255.255.255.0 127.0.0.1

if "%fw%" == "true" goto FW0
"x:\Program Files\BurnInTest\bit.exe" –h -x -r -c G6_SelftestDD.bitcfg
goto end
:FW0
"x:\Program Files\BurnInTest\bit.exe" –h -x -r -c G6_Selftest.bitcfg
goto end

:online
if "%fw%" == "true" goto FW1
"x:\Program Files\BurnInTest\bit.exe" –h -x -r -c G6_DD.bitcfg
goto end
:FW1
"x:\Program Files\BurnInTest\bit.exe" –h -x -r -c G6.bitcfg
goto end

:end
:: If something went wrong, don't shutdown
if errorlevel 1 goto cmdline
:: Erase all partition data from primary disk
diskpart /s diskclean.txt
:: Eject the CD
powershell eject
:: Test completed successfully
wpeutil shutdown

:cmdline