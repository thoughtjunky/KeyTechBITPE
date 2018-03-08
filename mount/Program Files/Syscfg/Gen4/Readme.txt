Release Note for SYSCFG Utility 
Version 10.0 Build 6

March 15, 2011

Copyright (c) 2010-11 Intel Corporation.

=====================================

Contents
--------

1. Introduction
2. Supported Platforms
3. Supported Operating Systems
4. Pre-requisites
5. Getting started
6. Usage
7. Reference Documentation
8. Known Issues
9. Unsupported Features
10. Legal Information


1. Introduction
---------------
   
The Save and Restore System Configuration utility (syscfg) is used for saving and restoring Firmware and BIOS settings to a binary file, 
and for configuring Firmware and BIOS settings via a command line interface.

2. Supported Platforms
----------------------

    Intel (R) S1200BTL series of platforms.
    Intel (R) S1200BTS series of platforms.

   
3. Supported Operating Systems
------------------------------
    UEFI 2.0
    RHEL 6 (32 bit & EM64T)
    Windows Server 2008 (32 bit & EM64T)
    SUSE 11 SP1 (32 bit & EM64T)

4. Pre-requisites
-----------------

   1. For UEFI: Boot to UEFI 2.0 image

5. Getting started
------------------
   
   1. Master syscfg package SysCfgV11.0-BuildXX_AllOS.zip has all the executables intact with the following folder structure:

      SysCfgV10.0-BuildXX_AllOS
      |
      |----UEFI_x64
      |        |---syscfg.efi
      |        |---ipmi.efi
      |        |---Nshell.efi
      |        |
      |---Licenses
      |    |--EFIToolKit
      |    |    |--BSD-License-From-Intel.txt
      |    |--Others
      |    |    |--AES-License.txt.txt
      |    |    |--MD5_Message-Digest-License.txt
      |    |    |--SSL Implementation-License.txt
      |    |
      |    |----INTEL SOFTWARE LICENSE AGREEMENT WITH.doc
      |    |----license.txt 
      |----SysCfg.txt
      |    |
      |----Drivers
      |        |---Win
      |             |---x64
      |             |    |--DeviceSetup.exe
      |             |    |--flashud.cat
      |             |    |--flashud.inf
      |             |    |--FLASHUD.sys
      |             |    |--ibsmutil.cat
      |             |    |--IBSMUtil.sys
      |             |    |--IBSMUx64.inf
      |             |    |--imbdrv.cat
      |             |    |--IMBDrv.inf
      |             |    |--imbdrv.sys
      |             |    |--install.cmd
      |             |    |--uninstall.cmd
      |             |
      |             |---x86
      |                  |--DeviceSetup.exe
      |                  |--flashud.cat
      |                  |--flashud.inf
      |                  |--FLASHUD.sys
      |                  |--ibsmutil.cat
      |                  |--IBSMUtil.sys
      |                  |--IBSMUtil.inf
      |                  |--imbdrv.cat
      |                  |--IMBDrv.inf
      |                  |--imbdrv.sys
      |                  |--install.cmd
      |                  |--uninstall.cmd
      |
      |----RHEL
      |       |---syscfg.zip
      |
      |----SLES
      |       |---syscfg.zip
      |
      |----Win_x86
      |       |---syscfg.exe
      |       |---imbapi.dll
      |       |---msipmi.dll
      |
      |----Win_x64
              |---syscfg.exe
              |---imbapi.dll
              |---msipmi.dll

   2. For 32 bit windows, go to folder "SysCfgVXX.X-BuildXX_AllOS\Drivers\win\x86" and run install.cmd to install ipmi, smi and memory map drivers.
   3. For 64 bit windows, go to folder "SysCfgVXX.X-BuildXX_AllOS\Drivers\win\x64" and run install.cmd to install ipmi, smi and memory map drivers.
   4. For all Linux OS version, the executables can be executed directly.
        
6. Usage
--------
   1. Command line Interface

      Linux Shell>> ./syscfg [Switches] [parameters]
			 			 
      Examples
      --------
      a. To display the system BIOS/BMC Version:

             >> ./syscfg -i

      b. To display the BIOS Parameters:

             >> ./syscfg /d bios


      Windows and UEFI Shell>> syscfg [Switches] [parameters]
			 			 
      Examples
      --------
      a. To display the system BIOS/BMC Version:

             >> syscfg -i

      b. To display the BIOS Parameters:

             >> syscfg /d bios

7. Reference Documentation
--------------------------
  
    IPMI v2.0 specification
    SYSCFG Utility User Guide
    
8. Known Issues
---------------
  
   1. Standard Error Messaging features are not fully supported in this release. Only a subset of error messages will be printed.

   2. /bcr, /bht, /bpep and bqb switch is not supported on S1200BT platforms instead use advance BIOS switch (/d biossettings & /bcs) for configuring "console redirection" and "Hyper-Threading" variables.

   3. Enabling Serial A or Serial B under Serial Port Configuration will fail if one or both Serial A or Serial B are disable, user needs to restart and enable these settings from F2 screen. 

   4. Restore of "Quiet Boot" variable is not supported using .SCF file.  
   
       
9. Supported Features
-----------------------

   1. Added support for Intel (R) S1200BTS platform series.

  
10. Legal Information
---------------------

==============================================================================

                               LEGAL INFORMATION

==============================================================================

Information in this document is provided in connection with Intel Products

and for the purpose of supporting Intel developed server boards and systems.

No license, express or implied, by estoppel or otherwise, to any intellectual 

property rights is granted by this document. Except as provided in Intel's 

Terms and Conditions of Sale for such products, Intel assumes no liability 

whatsoever, and Intel disclaims any express or implied warranty, relating to 

sale and/or use of Intel products including liability or warranties relating 

to fitness for a particular purpose, merchantability, or infringement of any 

patent, copyright or other intellectual property right. Intel Corporation may 

have patents or pending patent applications, trademarks, copyrights, or other 

intellectual property rights that relate to the presented subject matter.  

The furnishing of documents and other materials and information does not 

provide any license, express or implied, by estoppel or otherwise, to any 

such patents, trademarks, copyrights, or other intellectual property rights.  

Intel products are not intended for use in medical, life saving, or life 

sustaining applications. Intel may make changes to specifications and product 

descriptions at any time, without notice.

 

Intel is a registered trademark of Intel Corporation. 

 

*Other names and brands are the property of their respective owners.

 

Copyright (c) 2011 Intel Corporation.



(end)
