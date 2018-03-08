echo off
echo ""
echo S2600JF Integrated BMC Firmware Update rev 01.17.5256
echo Performing a signed image update of the Integreated BMC Firmware.
echo ""
.\WinPEUtils_x86\FWPIAUPD\Devicesetup.exe remove *IPI0001
.\WinPEUtils_x86\FWPIAUPD\DeviceSetup install .\WinPEUtils_x86\FWPIAUPD\IMBDrv.inf *IMBDRV
.\WinPEUtils_x86\FWPIAUPD\FWPIAUPD -u -bin -ni -b -o -pia -nopc -if=usb BMC_01.17.5256.bin

echo "Update BIOS to R0041"
.\WinPEUtils_x86\IFlash32\DeviceSetup install .\WinPEUtils_x86\IFlash32\flashud.inf *int0800
.\WinPEUtils_x86\IFlash32\DeviceSetup install .\WinPEUtils_x86\IFlash32\IBSMUtil.inf *IntelUtilDeV
.\WinPEUtils_x86\IFlash32\IFlash32 /u /ni R0041.cap

echo ""
echo "Flashing ME_02_02_00_049_LC..."
.\WinPEUtils_x86\IFlash32\IFlash32 /u /ni ME_02_02_00_049_LC.cap
echo ""
echo "ME 02_02_00_049 update completed..."

echo "Update FRUSDR using FRUSDR utility"
.\WinPEUtils_x86\FRUSDR\DeviceSetup.exe install .\WinPEUtils_x86\FRUSDR\imbdrv.inf *IMBDRV
.\WinPEUtils_x86\FRUSDR\DeviceSetup.exe install .\WinPEUtils_x86\FRUSDR\IBSMUtil.inf *IntelUtilDeV
.\WinPEUtils_x86\FRUSDR\frusdr -cfg MASTER.cfg

echo "Updates completed. Please reboot using the front panel button."

echo on
