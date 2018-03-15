echo -off
cls
echo ""
echo S1200BTL Integrated BMC Firmware Update rev 01.17.5256
echo Performing image update of the Integrated BMC Firmware.
echo ""


FWPIAUPD -u -bin -ni -nopc -b -o -pia -if=usb BMC_01.17.5256.bin
