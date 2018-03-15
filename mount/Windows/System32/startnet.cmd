if not "%1" == "v" @echo OFF
SETLOCAL ENABLEDELAYEDEXPANSION
cls

REM
REM If it's got more than one hard disk, it must have Firewire.
REM	 I should really find a way to use powershell 
REM  to check specifically for each drive,
REM	 but I'm just not there yet.
REM
if exist E:\ ( 
	set fw=FW
  ) else ( 
	set fw=DD 
  )

REM
REM A nice message to our dear technician
REM
echo.
call colorecho 0b "Key Technology G6 CPU BurnInTest 1.03" & echo.
call colorecho 0b "THIS TEST WILL ERASE ALL PARTITION DATA ON PRIMARY DISK" & echo.
call colorecho 0b "Ensure all ports and drives are ready for testing" & echo.
echo.
echo Please wait
echo Initializing Windows PE Services...
echo.

REM
REM the only thing that existed in this script originally...
REM  installs plug and play devices and loads network resources
REM
call wpeinit

REM
REM Probe for Motherboard Model and BIOS version
REM  then redirect accordingly
REM
for /f "skip=1" %%a in ('wmic baseboard get product') do set mobo=%%a
	find "%mobo%" "settings.txt" >nul 2>&1 || goto altconfig
	
for /f "skip=1" %%b in ('wmic bios get smbiosbiosversion') do set bios=%%b
	find "%bios%" "settings.txt" >nul 2>&1 && goto serial
	echo.

REM
REM Does not work on Gen 4
REM
call colorecho 0c "Current BIOS %bios%" & echo. 
call colorecho 0c "Does not match the Specsheet" & echo . Update?[Y/N]

:updbios
set /p biosupdate=
	if "%biosupdate%" == "y" goto upbios
	if "%biosupdate%" == "n" goto serial
	echo Please enter Y or N
	goto updbios
echo.
	
:upbios
for /f "tokens=3 delims=;" %%c in ('find "%mobo%" "settings.txt"') do %%c ^
	&& pause BIOS update successful, press any key to reboot. ^
	|| goto cmd
wpeutil reboot

:altconfig
REM
REM When BIOS can't be set automatically
REM
set motherboard=unsupported
if "%mobo%" == "S1200BTL" (
	call colorecho 0c "BIOS update not supported in Windows PE 4." & echo.
	call colorecho 0c "EFI or Deployment Assistant must be used instead." & echo.
  ) else (
	call colorecho 0c "Motherboard not recognized: cannot verify bios version." & echo.
	call colorecho 0c "Drive assignment may not work as expected" & echo.
  )

:serial
time
date
set /p computername=Serial Number:

REM
REM Here lies a back door to allow for manual diagnostics before we start erasing things.
REM Technically you could ctrl+C whenever you want, but I prefer this solution.
REM
if "%computername%" == "test" goto cmd
echo.
 
REM
REM Map the network folder for logging BIT results
REM
echo Attempting to map network drive...
echo.
if exist N: (
	call colorecho 0a "Network Share Mapped"
  ) else (
	net use N: \\pxeserver\BITPE_LOGS password /user:admin >nul 2>&1
	if errorlevel 1 (
		call colorecho 0e "Network Share not found" & set net=SelfTest
	  ) else (
		call colorecho 0a "Network Share Mapped" & set net=Networked
		)
  )
echo.
echo.
	
REM
REM Strip and reassign drive letters depending on configuration
REM
echo Assigning drive letters and formatting Disk 0 ...
echo.
diskpart /s "volstrip.txt" >nul 2>&1
diskpart /s "%mobo%%fw%.txt" >nul 2>&1

:setip
if exist N:\ goto bit
netsh int ipv4 set address ethernet static 192.168.0.1 255.255.255.0 127.0.0.1 && ^
netsh int ipv4 set address "ethernet 2" static 192.168.0.2 255.255.255.0 127.0.0.1
	if ERRORLEVEL 1 (
	call colorecho 0c "Failed to set Static IP" & echo.
  ) else (
	call colorecho 0a "Static IP Set" & echo.
  )
echo.

:bit
REM
REM Run BurnInTest with a dynamically assigned script 
REM  depending on the presence of a network share and Firewire drives
REM
call colorecho 0a "Launching BurnInTest G6%net%%fw% script..."
call "%programfiles%\BurnInTest\bit.exe" /X /R /C "G6%net%%fw%.bitcfg" /L 512,0,512,768
if ERRORLEVEL 1 (
	call colorecho 0c "Something went wrong with BurnInTest" & goto cmd
  )
echo.
echo.

:end
REM
REM Erase all partition data from primary disk
REM
diskpart /s "diskclean.txt" >nul 2>&1 ^
	&& call colorecho 0a "Disk 0 Cleaned" ^
	|| call colorecho 0c "Failed to Clean Disk 0"
echo.
echo.
	
REM
REM Set BIOS configuration if it's a Gen 5 or 6
REM
for /f "tokens=4 delims=;" %%d in ('find "%mobo%" "settings.txt"') do %%d ^
	&& call colorecho 0a "BIOS config set" ^
	|| goto cmd
echo.
echo.

REM
REM Eject the CD
REM
powershell set-executionpolicy unrestricted
	if ERRORLEVEL 1 (
		call colorecho 0c "Failed to set Powershell Execution Policy" & echo.
		call colorecho 0c "this is required for automatic ejection of the CD upon test completion" & echo.
		echo.
	  )
powershell Set-CDDriveState -eject 2>nul
	if ERRORLEVEL 1 (
		call colorecho 0c "Unable to eject CD" & echo.
	  ) else (
		call colorecho 0a "CD Ejected" & echo.
	  )
echo.

REM
REM Test completed successfully
REM
call colorecho 0a "Testing complete, press any key to power off" & echo.
echo.
pause >nul
wpeutil shutdown


:cmd
echo.
echo.
