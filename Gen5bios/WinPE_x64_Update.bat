echo off
echo ""
echo S1200RP Integrated BMC Firmware Update rev BMC_i_0113r7782
echo Performing a signed image update of the Integrated BMC Firmware.
echo ""
.\WinPEUtils_x64\FWPIAUPD\Devicesetup.exe  remove *IPI0001
.\WinPEUtils_x64\FWPIAUPD\DeviceSetup install .\WinPEUtils_x64\FWPIAUPD\IMBDrv.inf *IMBDRV
.\WinPEUtils_x64\FWPIAUPD\FWPIAUPD -u -bin -ni -b -o -pia -nopc -if=usb BMC_i_0113r7782.bin

echo "Update BIOS to R03.01.0002"
.\WinPEUtils_MEComplete_03.00.05.128x64\IFlash32\DeviceSetup install .\WinPEUtils_x64\IFlash32\flashud.inf *int0800
.\WinPEUtils_x64\IFlash32\DeviceSetup install .\WinPEUtils_x64\IFlash32\IBSMUx64.inf *IntelUtilDeV
.\WinPEUtils_x64\IFlash32\IFlash32 /u /ni R03.01.0002.cap

echo ""
echo "Flashing ME MEComplete_03.00.07.018..."
.\WinPEUtils_x64\IFlash32\IFlash32 /u /ni MEComplete_03.00.07.018.cap
echo ""
echo "MEComplete_03.00.07.018 update completed..."

echo "Update FRUSDR using FRUSDR utility"
.\WinPEUtils_x64\FRUSDR\DeviceSetup.exe install .\WinPEUtils_x64\FRUSDR\imbdrv.inf *IMBDRV
.\WinPEUtils_x64\FRUSDR\DeviceSetup.exe install .\WinPEUtils_x64\FRUSDR\ibsmux64.inf *IntelUtilDeV
.\WinPEUtils_x64\FRUSDR\frusdr -cfg master.cfg

echo "Updates completed. Please reboot using the front panel button."

echo on
