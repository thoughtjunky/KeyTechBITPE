:: Usage
:: bupcfg [desired program] [motherboard generation]
:: available programs: iflash32, syscfg
:: motherboard versions: 4, 5

goto %1

:iflash32
pushd "%ProgramFiles%\Gen%2\iflash32"
call install.cmd
if "%2" == "4" iflash32.exe" /u R0042.cap
if "%2" == "5" iflash32.exe /u R03.02.0003.cap updatebackupbios
popd
goto end


:syscfg
pushd "%ProgramFiles%\Gen%2\syscfg"
call install.cmd >nul 2>&1
syscfg /bldfs
if errorlevel 1 goto cmdline
@echo Loaded Defaults
if "%2" == "4" syscfg.exe /bcs "" ^
"Main" "Quiet Boot" 0 ^
"Processor Configuration" "Processor C6" 0 ^
"PCI Configuration" "Wake on LAN (PME)" 0 ^
"Server Management" "FRB-2 Enable" 0 ^
"USB Configuration" "Make USB Devices Non-Bootable" 1
syscfg /prp ON
if errorlevel 1 goto cmdline
@echo Power Restore Policy set ON
syscfg /bbosys
echo Type the correct boot sequence i.e. "2134" to change boot order.
set /p bootorder=Boot Order:
syscfg /bbosys "" %bootorder% >nul 2>&1
popd

:end