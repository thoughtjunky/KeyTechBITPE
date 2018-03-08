echo -off
cls
echo ""
echo Integrated BMC Firmware Update Package 01.19
echo The BMC image being installed is revision 01.19.5018
echo ""

# Update everything including the boot block
FWPIAUPD -u -bin -ni -b -o -pia -nopc -if=usb BMC_i_0119r5018.bin
