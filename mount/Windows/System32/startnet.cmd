@echo off


:: If it's got 3 drives, it must have Firewire
if exist F:\ set fw=true

:: A nice message to our dear technician
@echo.
@echo Key Technology G6 CPU BurnInTest 1.01
@echo WARNING: THIS TEST WILL ERASE ALL DATA ON PRIMARY DISK
@echo Ensure all ports and drives are ready for testing
@echo.
@echo Please wait...
@echo.

:: the only thing that originally existed in this .cmd
@echo Initializing services...
wpeinit
@echo.

:: Make the variables behave
SETLOCAL ENABLEDELAYEDEXPANSION

:: Probe for Motherboard Model
for /f "tokens=1 skip=1" %%a in ('wmic baseboard get product') do set mobo=%%a
find "%mobo%" currentbiosversions.txt >nul 2>&1
if errorlevel 1 goto altconfig
:: Probe for BIOS version
for /f "tokens=1 skip=1" %%b in ('wmic bios get smbiosbiosversion') do set bios=%%b
find "%bios%" currentbiosversions.txt >nul 2>&1
if errorlevel 1 goto updatebios
goto setbios

:updatebios
:: Currently only functions for Gen5
set /p biosupdate=BIOS version is not current, update BIOS?:
if "%biosupdate%" == "yes" goto upbios
if "%biosupdate%" == "no" goto setbios
@echo Please enter "yes" or "no"
goto updatebios
:upbios
if "%mobo%" == "S1200BTL" goto altconfig
for /f "tokens=3 delims=;" %%c in ('find "%mobo%" currentbiosversions.txt') do %%c
if errorlevel 1 goto cmdline
pause BIOS update successful, press any key to reboot.
wpeutil reboot

:altconfig
:: When BIOS can't be set automatically
set motherboard=unsupported
if "%mobo%" == "S1200BTL" (
@echo Motherboard not supported for WinPE BIOS update, EFI or Deployment Assistant must be used instead
) else (
@echo Motherboard not recognized
)
goto setbios

:setbios
:: Set BIOS configuration if it's a Gen 5
@echo.
if "%mobo%" == "S1200RP" echo Setting BIOS...
if "%mobo%" == "S1200RP" for /f "tokens=4 delims=;" %%d in ('find "%bios%" currentbiosversions.txt') do %%d

:serial
time
date
set /p serialnumber=Serial Number:
:: Allow for manual diagnostics before we start erasing things
if "%serialnumber%" == "test" goto cmdline
:: Allow powershell scripting (used for ejecting the CD)
powershell set-executionpolicy unrestricted
:: Map the network folder for logging BIT results
net use N: \\pxeserver\BITPE_LOGS password /user:admin
goto setdisk

:setdisk 
:: Strip and reassign drive letters depending on configuration
diskpart /s volstrip.txt >nul 2>&1
if "%mobo%" == "S1200RP" (
diskpart /s diskpartGen5.txt >nul 2>&1
) else (
if "%fw%" == "true" diskpart /s diskpartGen4.txt >nul 2>&1
if not "%fw%" == "true" diskpart /s diskpartGen4dd.txt >nul 2>&1
)
goto setip

:setip
if exist N:\ goto online
netsh int ipv4 set address ethernet static 192.168.0.1 255.255.255.0 127.0.0.1
netsh int ipv4 set address "ethernet 2" static 192.168.0.2 255.255.255.0 127.0.0.1
goto burnintest

:burnintest
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