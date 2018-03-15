# FORCE_EFI_BOOT
echo -off
# +
# + ============================================================== +
#  Copyright (c) 2015, Intel Corporation.

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

#  Module Name:  startup.nsh

#  Abstract:  Script file for invoking iflash.

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
echo ==========================================================================
echo "This utility will allow you to update the BMC 1.12, FRUSDR 1.07," 
echo "BIOS Rev 02.02.0005 in the Intel(R)Server Board S1200V3RPO_S1200V3RPL_S1200RPM"
echo ""
echo "Note:!!!!********************************************************!!!!"
echo "If BIOS Rev 02.01.0002 is not pre-installed then please install that release first"
echo "prior to installing this release. The BIOS Rev 02.01.0002 contains"
echo "a critical update which must be present before installing this release."
echo "     !!!!********************************************************!!!!"
echo ""
echo "If you want to do all these functions, press Enter. If not, hit 'q'."
echo ""
echo "if you want to update single component like BMC/BIOS separately,"
echo "please go to refer the specified scripts in the same folder"
echo "separately, and follow below update process to ensure trouble free update"
echo "  1): BMC firmware update to 1.13;"
echo "  2): BIOS update to 03.01.0002;"
echo "  3): ME update to 03.00.07.018;"
echo "  4): FRUSDR update to 1.08;"
echo ""
echo "Do NOT reboot during this process until you see Updates completed."

echo ==========================================================================
pause

echo ""
echo Integrated BMC and Intel Remote Management Module 4 firmware update rev 1.13.7782
echo ""
fWpiaupd -u -bin -ni -nopc -b -o -pia -if=usb BMC_i_0113r7782.bin
echo ""
echo "BMC Update completed"


echo ""
echo "Flashing BIOS R03.01.0002..."
IFlash32.efi R03.01.0002.cap /u /ni
echo ""
echo "Flashing BackupBIOS R03.01.0002..."
iflash32 -u R03.01.0002.cap UpdateBackupBios -ni
echo ""
echo "BIOS update completed..."

echo ""
echo "Flashing ME 03.00.07.018 ..."
iflash32 /u /ni MEComplete_03.00.07.018.cap
echo ""
echo "ME update completed..."


echo ""
echo "Update FRUSDR using FRUSDR utility"
cls
frusdr -cfg master.cfg
echo ""
echo "FRUSDR Update completed..."

echo ""
echo ""
echo "Updates completed. Please reboot using the front panel button."
:END

