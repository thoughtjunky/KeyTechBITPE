:: Usage
:: bupcfg [desired program] [motherboard generation]
:: available programs: iflash32, syscfg
:: motherboard versions: 4, 5


goto %1


:iflash32
cd "%ProgramFiles%\Gen%2\iflash32"
call install.cmd
if "%2" == "4" iflash32.exe" /u R0042.cap
if "%2" == "5" iflash32.exe /u R03.02.0003.cap updatebackupbios
cd "%windir%\System32"


:syscfg
cd "%ProgramFiles%\Gen%2\syscfg"
call install.cmd
syscfg.exe /bldfs ""
if "%2" == "4" syscfg.exe /bcs "" "Main" "Quiet Boot" 0
::Options: 0=Disabled: 1=Enabled
if "%2" == "4" syscfg.exe /bcs "" "Processor Configuration" "Processor C6" 0
::Options: 0=Disabled: 1=Enabled
if "%2" == "4" syscfg.exe /bcs "" "PCI Configuration" "Wake on LAN (PME)" 0
::Options: 0=Disabled: 1=Enabled
if "%2" == "4" syscfg.exe "" /bcs "Server Management" "Resume on AC Power Loss" 2
::Options: 1=Last State: 2=Reset: 0=Stay Off
if "%2" == "5" syscfg.exe "" /bcs "Server Management" "Resume on AC Power Loss" 02
::Options: 01=Last State: 02=Reset: 00=Stay Off
if "%2" == "4" syscfg.exe "" /bcs "Server Management" "FRB-2 Enable" 0
::Options: 0=Disabled: 1=Enabled
syscfg.exe /bcs "" "USB Configuration" "Make USB Devices Non-Bootable" 1
::Options: 0=Disabled: 1=Enabled
syscfg.exe /bbosys
echo Enter the correct boot order i.e. "2134". If correct press enter.
set /p bootorder=Boot Order:
syscfg.exe /bbosys "" %bootorder%
cd "%windir%\System32"