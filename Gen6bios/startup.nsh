# FORCE_EFI_BOOT

echo -off
# +
# + ============================================================== +
#  Copyright (c) 2016 Intel Corporation.

#  This source code and any documentation accompanying it ("Material") is furnished
#  under license and may only be used or copied in accordance with the terms of that
#  license.  No license, express or implied, by estoppel or otherwise, to any
#  intellectual property rights is granted to you by disclosure or delivery of these
#  Materials.  The Materials are subject to change without notice and should not be
#  construed as a commitment by Intel Corporation to market, license, sell or support
#  any product or technology.  Unless otherwise provided for in the license under which
#  this Material is provided, the Material is provided AS IS, with no warranties of
#  any kind, express or implied, including without limitation the implied warranties
#  of fitness, merchantability, or non-infringement.  Except as expressly permitted by
#  the license for the Material, neither Intel Corporation nor its suppliers assumes
#  any responsibility for any errors or inaccuracies that may appear herein.  Except
#  as expressly permitted by the license for the Material, no part of the Material
#  may be reproduced, stored in a retrieval system, transmitted in any form, or
#  distributed by any means without the express written consent of Intel Corporation.

#  Module Name:  Startup.nsh

#  Abstract:  UEFI Script file for invoking system software updates.

# + ============================================================== +
#    Program all blocks of BIOS from capsule file 
# + ============================================================== +

@echo -off
mode 80 25
;foundimage section is simply to locate the correct drive
cls
if exist .\ipmi.efi then
 goto FOUNDIMAGE
endif
if exist fs0:\ipmi.efi then
 fs0:
 echo Found Update Packages on fs0:
 goto FOUNDIMAGE
endif
if exist fs1:\ipmi.efi then
 fs1:
 echo Found Update Packages on fs1:
 goto FOUNDIMAGE
endif
if exist fs2:\ipmi.efi then
 fs2:
 echo Found Update Packages on fs2:
 goto FOUNDIMAGE
endif
 echo "Unable to find Update Packages".  
 echo "Please mount the drive with the update package".
 echo ""
 goto END
:FOUNDIMAGE
load ipmi.efi > null 

echo "================================================================================"
echo "This utility will update the BMC Firmware, system BIOS (Primary & Backup Images)"
echo "ME Firmware, and FRU & SDR data on the following Intel products only:"
echo ""
echo "      - Intel(R) Server Board S1200SP Family"
echo ""
echo ""
echo "Do NOT interrupt or reboot the system during any update process. Updates that"
echo "have completed successfully will display an update completion message."
echo ""
echo " *** If you have not read the README file providing the Update Instructions,"
echo "     it is highly advisable you do that before continuing with this update. ***"
echo ""
echo "================================================================================"

pause

echo ""
echo "Starting System Update......"

echo ""
UpdateBMC.nsh

echo ""
updateAll.nsh
@echo -off

echo ""
echo "Loading FRU and SDR revision 0.22 data"
frusdr /cfg master.cfg
echo ""

echo "The system software stack update process is now complete and the USB Device"
echo "can be removed."
echo ""
echo "The onboard BMC will verify installed firmware levels of the Power Supplies"
echo "and Hot-Swap Backplanes. If the firmware of these devices is not current, the"
echo "BMC will update the firmware of these devices in the background. The system"
echo "can be rebooted at this time using the CTRL-ALT-DEL keys or using the Power"
echo "Button on the front panel, however DO NOT REMOVE THE AC POWER from the system"
echo "for at least 5 minutes."
echo ""
echo "*****************************************************************************"
echo "**********************Do not remove AC power*********************************"
echo "*****************************************************************************"
echo ""
echo "READ THIS: When the system is rebooted, the screen will be blank for"
echo "approximately 2 minutes while the backup BIOS image is being loaded. "
echo "DO NOT power off or reboot your system during this 2 minute window."
echo "A brief message will appear on the screen when the update has completed,"
echo "the system will continue to boot." 
echo ""
echo "BIOS Setup options can be set by entering the F2 BIOS Setup Utility during" 
echo "POST when the system is rebooted."
echo ""
:END
pause

