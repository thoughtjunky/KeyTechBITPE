cd "%ProgramFiles%\Gen4\syscfg"
set def=%bootorder%
install.cmd
syscfg.exe /bldfs ""
syscfg.exe /bcs "Main" "Quiet Boot" 0                                        ::Options: 0=Disabled: 1=Enabled
syscfg.exe /bcs "Processor Configuration" "Processor C6" 0                   ::Options: 0=Disabled: 1=Enabled
syscfg.exe /bcs "PCI Configuration" "Wake on LAN (PME)" 0                    ::Options: 0=Disabled: 1=Enabled
syscfg.exe /bcs "USB Configuration" "Make USB Devices Non-Bootable" 1        ::Options: 0=Disabled: 1=Enabled
syscfg.exe /bcs "Server Management" "Resume on AC Power Loss" 2              ::Options: 1=Last State: 2=Reset: 0=Stay Off
syscfg.exe /bcs "Server Management" "FRB-2 Enable" 0                         ::Options: 0=Disabled: 1=Enabled
syscfg.exe /bbosys
echo Enter the correct boot order, i.e. "2 1 3 4". If correct press enter.
set /s bootorder=Boot Order:
if "%bootorder%" == "%def%" goto syscfg4next
syscfg.exe /bbosys "" %bootorder%
cd "%windir%\System32"