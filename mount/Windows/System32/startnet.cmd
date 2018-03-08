:: Make the things behave
SETLOCAL ENABLEDELAYEDEXPANSION
@echo OFF
cls

::manually running "startnet v" allows for debugging
if "%1" == "v" echo ON && set verbose=true

:: used for error reporting
set bitcrash=false

:: If it's got more than one hard disk, it must have Firewire. CD apparently doesn't count 0_o
if exist E:\ (set fw=true) else (set fw=false)

:: A nice message to our dear technician
@echo.
call colorecho 0b "Key Technology G6 CPU BurnInTest 1.03"
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

:: Probe for Motherboard Model
for /f "skip=1" %%a in ('wmic baseboard get product') do set mobo=%%a
	find "%mobo%" settings.txt >nul 2>&1 || goto altconfig

:: Probe for BIOS version
for /f "skip=1" %%b in ('wmic bios get smbiosbiosversion') do set bios=%%b
	find "%bios%" settings.txt >nul 2>&1 && goto serial

:updatebios
:: Currently only functional for Gen5?
@echo.
call colorecho 0c "BIOS %bios%"
@echo. 
call colorecho 0c "does not match the Specsheet" 
@echo . Update?
if "%mobo%" == "S1200BTL" goto altconfig
set /p biosupdate=
	@echo.
	if "%biosupdate%" == "y" goto upbios
	if "%biosupdate%" == "yes" goto upbios
	if "%biosupdate%" == "n" goto serial
	if "%biosupdate%" == "no" goto serial
	@echo Please enter Yes or No
	goto updatebios
	
:upbios
@echo.
for /f "tokens=3 delims=;" %%c in ('find "%mobo%" settings.txt') do %%c ^
	&& pause BIOS update successful, press any key to reboot. ^
	|| goto cmd
	wpeutil reboot

:altconfig
:: When BIOS can't be set automatically
set motherboard=unsupported
if "%mobo%" == "S1200BTL" (
	call colorecho 0c "Motherboard not supported for WinPE BIOS update. EFI or Deployment Assistant must be used instead"
	@echo.
	) else (
	call colorecho 0c "Motherboard not recognized: cannot verify bios version, drive assignment may not work as expected"
	@echo.
	)

:serial
time
date
set /p computername=Serial Number:
:: Allow for manual diagnostics before we start erasing things
if "%computername%" == "test" goto cmd
@echo.
 
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
if "%mobo%" == "S1200BT" (
	if "%fw%" == "true" diskpart /s diskpartGen4.txt >nul 2>&1
	if "%fw%" == "false" diskpart /s diskpartGen4dd.txt >nul 2>&1
	) else (
	if "%fw%" == "true" diskpart /s diskpartGen5.txt >nul 2>&1
	if "%fw%" == "false" diskpart /s diskpartGen5dd.txt >nul 2>&1
	)

:setip
if exist N:\ goto onlineDD
netsh int ipv4 set address ethernet static 192.168.0.1 255.255.255.0 127.0.0.1
netsh int ipv4 set address "ethernet 2" static 192.168.0.2 255.255.255.0 127.0.0.1
if errorlevel 1 (
	call colorecho 0c "Failed to set Static IP Addresses"
	goto cmd
	) else (
	call colorecho 0a "Static IP Addresses Set"
	)
	@echo.
	@echo.

:offlineDD
if "%fw%" == "true" goto offlineFW
call colorecho 0a "Launching BurnInTest G6_SelftestDD script..."
	@echo.
	@echo.
	call "x:\Program Files\BurnInTest\bit.exe" /X /R /C G6_SelftestDD.bitcfg /L 512,0,512,768
		if errorlevel 1 set bitcrash=true
	goto end

:offlineFW
call colorecho 0a "Launching BurnInTest G6_Selftest script..."
	@echo.
	@echo.
	call "x:\Program Files\BurnInTest\bit.exe" /X /R /C G6_Selftest.bitcfg /L 512,0,512,768
		if errorlevel 1 set bitcrash=true
	goto end

:onlineDD
if "%fw%" == "true" goto onlineFW
call colorecho 0a "Launching BurnInTest G6_DD script..."
	@echo.
	@echo.
	call "x:\Program Files\BurnInTest\bit.exe" /X /R /C G6_DD.bitcfg /L 512,0,512,768
		if errorlevel 1 set bitcrash=true
	goto end

:onlineFW
call colorecho 0a "Launching BurnInTest G6 script..."
	@echo.
	@echo.
	call "x:\Program Files\BurnInTest\bit.exe" /X /R /C G6.bitcfg /L 512,0,512,768
		if errorlevel 1 set bitcrash=true

:end
:: If something went wrong, don't shutdown
if %bitcrash% == "true" (
	call colorecho 0c "Something went wrong with BurnInTest"
	goto cmd
	) else (
	call colorecho 0a "BurnInTest Complete"
	)
	@echo.
	@echo.

:: Erase all partition data from primary disk
diskpart /s diskclean.txt >nul 2>&1
	if errorlevel 1 (
		call colorecho 0c "Failed to Clean Disk 0"
		goto cmd
		) else (
		call colorecho 0a "Disk 0 Cleaned"
		)
	@echo.
	
:: Set BIOS configuration if it's a Gen 5 or 6
@echo.
for /f "tokens=4 delims=;" %%d in ('find "%mobo%" settings.txt') do %%d ^
	&& call colorecho 0a "BIOS config set" ^
	|| goto cmd
@echo.

:: Allow powershell scripting (used for ejecting the CD)
powershell set-executionpolicy unrestricted
	if errorlevel 1 (
		call colorecho 0c "Failed to set Powershell Execution Policy"
		@echo.
		call colorecho 0c "this is required for automatic ejection of the CD upon test completion"
		@echo.
		@echo.
		)

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
	call colorecho 0a "Testing complete, press any key to power off"
	@echo.
	@echo.
	pause >nul
wpeutil shutdown


:cmd
@echo.
@echo.