:: Usage
:: bupcfg [desired program] [motherboard generation]
:: available programs: iflash32, syscfg
:: motherboard versions: 4, 5

goto %1

:iflash32
pushd "%ProgramFiles%\Gen%2\iflash32"
if "%verbose%" == "true" (
call install.cmd
) else (
call install.cmd nul nul >nul 2>&1
)
if "%2" == "4" iflash32.exe" /u R0042.cap
if "%2" == "5" iflash32.exe /u R03.02.0003.cap updatebackupbios
if errorlevel 1 (
	call colorecho 0c "Something went wrong flashing BIOS"
	@echo.
	exit /b 1
)
popd
goto end


:syscfg

pushd "%ProgramFiles%\Gen%2\syscfg"

if "%verbose%" == "true" (
call install.cmd
) else (
call install.cmd nul nul >nul 2>&1
)

syscfg /bldfs "" >nul 2>&1
if errorlevel 1 (
	call colorecho 0c "unable to load system defaults"
	@echo.
	exit /b 1
)
call colorecho 0a "Loaded Defaults"

if "%2" == "4" (
syscfg.exe /bcs "" "Main" "Quiet Boot" 0
syscfg.exe /bcs "" "Processor Configuration" "Processor C6" 0
syscfg.exe /bcs "" "PCI Configuration" "Wake on LAN (PME)" 0
syscfg.exe /bcs "" "Server Management" "FRB-2 Enable" 0
syscfg.exe /bcs "" "USB Configuration" "Make USB Devices Non-Bootable" 1
)

if "%2" == "5" syscfg /prp ON
if errorlevel 1 (
	call colorecho 0c "Failed to set Power Restore Policy"
	@echo.
	exit /b 1
)

syscfg /bbosys

@echo Type the correct boot sequence i.e. "2134" to change boot order.

set bootorder=blank

set /p bootorder=Boot Order:
set ERRORLEVEL=0

if not "%bootorder%" == "blank" (
	syscfg /bbosys "" %bootorder% /q >nul 2>&1
	@echo.
)

if errorlevel 1 (
	call colorecho 0c "Something went wrong setting the boot order"
	@echo.
	call colorecho 0c "did you put spaces between your numbers?"
	@echo.
	popd
	exit /b 1
)

if not "%bootorder%" == "blank" (
	call colorecho 0a "Boot order set successfully"
)

:end
popd
exit /b