
@echo OFF

:: Make the variables behave
SETLOCAL ENABLEDELAYEDEXPANSION

if "%1" == "v" ( 
	echo ON 
	set verbose=true
)

:: If it's got 3 drives, it must have Firewire
if exist F:\ set fw=true

:: A nice message to our dear technician
@echo.
call colorecho 0b "Key Technology G6 CPU BurnInTest 1.01"
@echo.
call colorecho 0b "THIS TEST WILL ERASE ALL PARTITION DATA ON PRIMARY DISK"
@echo.
call colorecho 0b "Ensure all ports and drives are ready for testing"
@echo.
@echo.
@echo Please wait...
@echo.

:: the only thing that originally existed in this .cmd
@echo Initializing Windows PE Services...
wpeinit
@echo.

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
set /p biosupdate=BIOS version %bios% is not current, update BIOS?:
if "%biosupdate%" == "yes" goto upbios
if "%biosupdate%" == "no" goto setbios
@echo Please enter "yes" or "no"
goto updatebios

:upbios
if "%mobo%" == "S1200BTL" goto altconfig
for /f "tokens=3 delims=;" %%c in ('find "%mobo%" currentbiosversions.txt') do %%c
if errorlevel 1 (
	call colorecho 0c "Something went wrong updating BIOS"
	@echo.
	call colorecho 0c "Try again, or update manually."
	@echo.
	goto cmdline
)
pause BIOS update successful, press any key to reboot.
wpeutil reboot

:altconfig
:: When BIOS can't be set automatically
set motherboard=unsupported
if "%mobo%" == "S1200BTL" (
	call colorecho 0c "Motherboard not supported for WinPE BIOS update, EFI or Deployment Assistant must be used instead"
	@echo.
) else (
	call colorecho 0c "Motherboard not recognized"
	@echo.
)
goto setbios

:setbios
:: Set BIOS configuration if it's a Gen 5
@echo.
if "%mobo%" == "S1200RP" echo Setting BIOS...
if "%mobo%" == "S1200RP" for /f "tokens=4 delims=;" %%d in ('find "%bios%" currentbiosversions.txt') do %%d
if errorlevel 1 goto cmdline
@echo.

:serial
time
date
set /p serialnumber=Serial Number:

:: Allow for manual diagnostics before we start erasing things
if "%serialnumber%" == "test" goto cmdline

:: Allow powershell scripting (used for ejecting the CD)
powershell set-executionpolicy unrestricted

:: Map the network folder for logging BIT results
	@echo Attempting to map network drive...
net use N: \\pxeserver\BITPE_LOGS password /user:admin >nul 2>&1
	@echo.
	@echo.
	
goto setdisk

:setdisk 
:: Strip and reassign drive letters depending on configuration
	@echo Assigning drive letters and formatting Disk 0 ...
	@echo.
if errorlevel 1 (
	call colorecho 06 "Network Share not found"
) else (
	call colorecho 0a "Network Share Mapped"
)
	@echo.
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
if errorlevel 1 (
	call colorecho 0c "Failed to set Static IP Addresses"
) else (
	call colorecho 0a "Static IP Addresses Set"
	goto cmdline
)
	@echo.
goto burnintest

:burnintest
if "%fw%" == "true" goto FW0
	call colorecho 0a "Launching BurnInTest G6_SelftestDD script..."
	@echo.
call "x:\Program Files\BurnInTest\bit.exe" –h -x -r -c G6_SelftestDD.bitcfg"
goto end

:FW0
	call colorecho 0a "Launching BurnInTest G6_Selftest script..."
	@echo.
call "x:\Program Files\BurnInTest\bit.exe" –h -x -r -c G6_Selftest.bitcfg"
goto end

:online
if "%fw%" == "true" goto FW1
	call colorecho 0a "Launching BurnInTest G6_DD script..."
	@echo.
call "x:\Program Files\BurnInTest\bit.exe" –h -x -r -c G6_DD.bitcfg"
goto end

:FW1
	call colorecho 0a "Launching BurnInTest G6 script..."
	@echo.
call "x:\Program Files\BurnInTest\bit.exe" –h -x -r -c G6.bitcfg"
goto end

:end
:: If something went wrong, don't shutdown
if errorlevel 1 (
	call colorecho 0c "Something went wrong"
) else (
	call colorecho 0a "BurnInTest Complete"
	goto cmdline
)
	@echo.
	@echo.

:: Erase all partition data from primary disk
diskpart /s diskclean.txt >nul 2>&1
if errorlevel 1 (
	call colorecho 0c "Failed to Clean Disk 0"
) else (
	call colorecho 0a "Disk 0 Cleaned"
	goto cmdline
)
	@echo.
	@echo.

:: Eject the CD
powershell eject
if errorlevel 1 (
	call colorecho 0c "Unable to eject CD"
) else (
	call colorecho 0a "CD Ejected"
	goto cmdline
)
	@echo.
	@echo.

:: Test completed successfully
	call colorecho 0a "Testing complete, shutting down..."
	@echo.
wpeutil shutdown


:cmdline
