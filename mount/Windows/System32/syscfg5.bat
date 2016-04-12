cd "%ProgramFiles%\Gen5\syscfg"
set def=%bootorder%
install.cmd
syscfg.exe /bldfs ""
syscfg.exe /bcs "" "Server Management" "Resume on AC Power Loss" 02
syscfg.exe /bbosys
echo Enter the correct boot order, i.e. "2 1 3 4". If correct press enter.
set /s bootorder=Boot Order:
if "%bootorder%" == "%def%" goto syscfg5next
syscfg.exe /bbosys "" %bootorder%
:syscfg5next
cd "%windir%\System32"