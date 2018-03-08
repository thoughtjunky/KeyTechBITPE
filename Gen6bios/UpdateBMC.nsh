echo -off
cls
echo ""
echo Integrated BMC Firmware Update Package 01.04.10248
echo The BMC image being installed is revision 01.04.10248
echo ""

# Update everything including the boot block
FWPIAUPD -u -bin -ni -b -o -pia -if=usb BMC_i_r10248.bin
