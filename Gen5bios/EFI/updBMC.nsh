echo -off
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

#  Module Name:  updBMC.nsh

#  Abstract:  Script file for invoking iflash.

# + ============================================================== +
#    Program all blocks of Integrated BMC from capsule file 
# + ============================================================== +


echo -off
cls
echo ""
echo S1200V3RP Integrated BMC Firmware Update rev 01.13
echo Performing image update of the Integrated BMC Firmware.
echo ""


FWPIAUPD -u -bin -ni -b -o -pia -nopc -if=usb BMC_i_0113r7782.bin
