
@echo OFF
cls

:: Make the variables behave
SETLOCAL ENABLEDELAYEDEXPANSION

if "%1" == "v" ( 
	echo ON 
	set verbose=true
	)

:: A nice message to our dear technician
	@echo.
call colorecho 0b "Key Technology G6 CPU BurnInTest 1.01"
	@echo.
call colorecho 0b "THIS TEST WILL ERASE ALL PARTITION DATA ON PRIMARY DISK"
	@echo.
call colorecho 0b "Ensure all ports and drives are ready for testing"
	@echo.
	@echo.
	@echo Please wait
	@echo Initializing Windows PE Services...

:: the only thing that originally existed in this .cmd
call wpeinit

:: If it's got more than one hard disk, it must have Firewire. CD apparently doesn't count 0_o
if exist E:\ (
	set fw=true
	) else (
	set fw=false)

:: Allow powershell scripting (used for ejecting the CD)
powershell set-executionpolicy unrestricted
if errorlevel 1 (
	call colorecho 0c "Failed to set Powershell Execution Policy"
	@echo.
	call colorecho 0c "this is required for automatic ejection of the CD upon test completion"
	@echo.
	)
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
if "%mobo%" == "S1200RP" for /f "tokens=4 delims=;" %%d in ('find "%mobo%" currentbiosversions.txt') do %%d
if errorlevel 1 goto cmdline
	@echo.

:serial
time
date
set /p computername=Serial Number:
:: Allow for manual diagnostics before we start erasing things
if "%computername%" == "test" goto cmdline
	@echo.
	
:setdisk 
:: Map the network folder for logging BIT results
	@echo Attempting to map network drive...
	@echo.
if exist N: (
	call colorecho 0a "Network Share Mapped"
	) else (
	net use N: \\pxeserver\BITPE_LOGS password /user:admin >nul 2>&1
	if errorlevel 1 (
		call colorecho 06 "Network Share not found"
		) else (
		call colorecho 0a "Network Share Mapped"
		)
	)
	@echo.
	@echo.
	
:: Strip and reassign drive letters depending on configuration
	@echo Assigning drive letters and formatting Disk 0 ...
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
	goto cmdline
	) else (
	call colorecho 0a "Static IP Addresses Set"
	)
	@echo.
	@echo.
goto burnintest

:burnintest
if "%fw%" == "true" goto FW0
	call colorecho 0a "Launching BurnInTest G6_SelftestDD script..."
	@echo.
	@echo.
call "x:\Program Files\BurnInTest\bit.exe" /X /R /C G6_SelftestDD.bitcfg /L 512,0,512,768
goto end

:FW0
	call colorecho 0a "Launching BurnInTest G6_Selftest script..."
	@echo.
	@echo.
call "x:\Program Files\BurnInTest\bit.exe" /X /R /C G6_Selftest.bitcfg /L 512,0,512,768
goto end

:online
if "%fw%" == "true" goto FW1
	call colorecho 0a "Launching BurnInTest G6_DD script..."
	@echo.
	@echo.
call "x:\Program Files\BurnInTest\bit.exe" /X /R /C G6_DD.bitcfg /L 512,0,512,768
goto end

:FW1
	call colorecho 0a "Launching BurnInTest G6 script..."
	@echo.
	@echo.
call "x:\Program Files\BurnInTest\bit.exe" /X /R /C G6.bitcfg /L 512,0,512,768
goto end

:end
:: If something went wrong, don't shutdown
if errorlevel 1 (
	call colorecho 0c "Something went wrong with BurnInTest"
	goto cmdline
	) else (
	call colorecho 0a "BurnInTest Complete"
	)
	@echo.
	@echo.

:: Erase all partition data from primary disk
diskpart /s diskclean.txt >nul 2>&1
if errorlevel 1 (
	call colorecho 0c "Failed to Clean Disk 0"
	goto cmdline
	) else (
	call colorecho 0a "Disk 0 Cleaned"
	)
	@echo.
	@echo.

:: Eject the CD
powershell Set-CDDriveState -eject >nul 2>&1
if errorlevel 1 (
	call colorecho 0c "Unable to eject CD"
	goto cmdline
	) else (
	call colorecho 0a "CD Ejected"
	)
	@echo.
	@echo.

:: Test completed successfully
	call colorecho 0a "Testing complete, shutting down..."
	@echo.
	@echo.
wpeutil shutdown


:cmdline
@echo.
@echo.