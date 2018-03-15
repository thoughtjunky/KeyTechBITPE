echo off
echo ""
echo S1200RP Integrated BMC Firmware Update rev BMC_i_0113r7782
echo Performing a signed image update of the Integrated BMC Firmware.
echo ""
.\WinPEUtils_x86\FWPIAUPD\Devicesetup.exe remove *IPI0001
.\WinPEUtils_x86\FWPIAUPD\DeviceSetup install .\WinPEUtils_x86\FWPIAUPD\IMBDrv.inf *IMBDRV
.\WinPEUtils_x86\FWPIAUPD\FWPIAUPD -u -bin -ni -b -o -pia -nopc -if=usb BMC_i_0113r7782.bin

echo "Update BIOS to R03.01.0002"
.\WinPEUtils_x86\IFlash32\DeviceSetup install .\WinPEUtils_x86\IFlash32\flashud.inf *int0800
.\WinPEUtils_x86\IFlash32\DeviceSetup install .\WinPEUtils_x86\IFlash32\IBSMUtil.inf *IntelUtilDeV
.\WinPEUtils_x86\IFlash32\IFlash32 /u /ni R03.01.0002.cap

echo ""
echo "Flashing ME MEComplete_03.00.07.018..."
.\WinPEUtils_x86\IFlash32\IFlash32 /u /ni MEComplete_03.00.07.018.cap
echo ""
echo "MEComplete_03.00.07.018 update completed..."

echo "Update FRUSDR using FRUSDR utility"
.\WinPEUtils_x86\FRUSDR\DeviceSetup.exe install .\WinPEUtils_x86\FRUSDR\imbdrv.inf *IMBDRV
.\WinPEUtils_x86\FRUSDR\DeviceSetup.exe install .\WinPEUtils_x86\FRUSDR\IBSMUtil.inf *IntelUtilDeV
.\WinPEUtils_x86\FRUSDR\frusdr -cfg master.cfg

echo "Updates completed. Please reboot using the front panel button."

echo on
