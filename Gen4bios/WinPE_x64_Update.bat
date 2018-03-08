echo off

echo ""
echo S2600JF Integrated BMC Firmware Update rev 01.17.5256
echo Performing a signed image update of the Integreated BMC Firmware.
echo ""
.\WinPEUtils_x64\FWPIAUPD\Devicesetup.exe  remove *IPI0001
.\WinPEUtils_x64\FWPIAUPD\DeviceSetup install .\WinPEUtils_x64\FWPIAUPD\IMBDrv.inf *IMBDRV
.\WinPEUtils_x64\FWPIAUPD\FWPIAUPD -u -bin -ni -b -o -pia -nopc -if=usb BMC_01.17.5256.bin

echo "Update BIOS to R0041"
.\WinPEUtils_x64\IFlash32\DeviceSetup install .\WinPEUtils_x64\IFlash32\flashud.inf *int0800
.\WinPEUtils_x64\IFlash32\DeviceSetup install .\WinPEUtils_x64\IFlash32\IBSMUx64.inf *IntelUtilDeV
.\WinPEUtils_x64\IFlash32\IFlash32 /u /ni R0041.cap

echo ""
echo "Flashing ME_02_02_00_049_LC..."
.\WinPEUtils_x64\IFlash32\IFlash32 /u /ni ME_02_02_00_049_LC.cap
echo ""
echo "ME 02_02_00_049 update completed..."

echo "Update FRUSDR using FRUSDR utility"
.\WinPEUtils_x64\FRUSDR\DeviceSetup.exe install .\WinPEUtils_x64\FRUSDR\imbdrv.inf *IMBDRV
.\WinPEUtils_x64\FRUSDR\DeviceSetup.exe install .\WinPEUtils_x64\FRUSDR\ibsmux64.inf *IntelUtilDeV
.\WinPEUtils_x64\FRUSDR\frusdr -cfg MASTER.cfg

echo "Updates completed. Please reboot using the front panel button."

echo on
