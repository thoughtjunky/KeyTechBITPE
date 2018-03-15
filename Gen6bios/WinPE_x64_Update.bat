echo off
echo ""
echo S1200SP Integrated BMC Firmware Update rev BMC_i_r10248
echo Performing a signed image update of the Integrated BMC Firmware.
echo ""
.\WinPEUtils_x64\FWPIAUPD\Devicesetup.exe remove *IPI0001
.\WinPEUtils_x64\FWPIAUPD\DeviceSetup install .\WinPEUtils_x64\FWPIAUPD\IMBDrv.inf *IMBDRV
.\WinPEUtils_x64\FWPIAUPD\FWPIAUPD -u -bin -ni -b -o -pia -nopc -if=usb BMC_i_r10248.bin

echo "Update BIOS to R02.01.0049"
.\WinPEUtils_x64\IFlash32\DeviceSetup install .\WinPEUtils_x64\IFlash32\flashud.inf *int0800
.\WinPEUtils_x64\IFlash32\DeviceSetup install .\WinPEUtils_x64\IFlash32\IBSMUx64.inf *IntelUtilDeV
.\WinPEUtils_x64\IFlash32\IFlash32 -u R02.01.0049.cap UpdateBackupBios -ni

echo ""
echo "Flashing R02.01.0049_ME..."
.\WinPEUtils_x64\IFlash32\IFlash32 /u /ni R02.01.0049_ME.cap
echo ""
echo "R02.01.0049_ME update completed..."

echo "Update Flash Descriptor to R02.01.0049_FD"
.\WinPEUtils_x64\IFlash32\IFlash32 /u /ni R02.01.0049_FD.cap

echo "Update FRUSDR using FRUSDR utility"
.\WinPEUtils_x64\FRUSDR\DeviceSetup.exe install .\WinPEUtils_x64\FRUSDR\imbdrv.inf *IMBDRV
.\WinPEUtils_x64\FRUSDR\DeviceSetup.exe install .\WinPEUtils_x64\FRUSDR\ibsmux64.inf *IntelUtilDeV
.\WinPEUtils_x64\FRUSDR\frusdr -cfg master.cfg

echo "Updates completed. Please reboot using the front panel button."

echo on
