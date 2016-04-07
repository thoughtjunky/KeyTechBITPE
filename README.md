# KeyTechBITPE

#Overview
This is my project to automate G6 Computer validation For Key Technology using WinPE 4.0, BurnInTest 7.1, syscfg, and iFlash32 in one bootable flash drive. My goal is to have the ability to update and configure the BIOS and run a 30 minute reliability test and have that test logged. This needs to work on both Gen 4 and 5 systems (not 1-3 since they are no longer supported) and potentially future systems as well.

#Detailed Description
This project is the reason I created a GitHub account. I'm just looking for a place to organize my work. I don't have much scripting or programming experience to speak of, and notepad/wordpad isn't cutting it. I'm also trying to integrate Notepad++ into my use of GitHub. I intend to work on it alone, as it is designed for specific hardware and doesn't need to be applicable to anything else. I will not be uploading all aspecs of the project, just the my scripts and batches that work with startnet.cmd 

#Known Issues
1. WinPE 4.0 is not supported by iFlash 10 or 11 which means I may not be able to update Gen4 BIOS from WinPE, but I'll see if I can find a way to overcome the error with ipmi enumeration.
2. Since USB drives are mapped ahead of Firewire drives on Gen 5 but not 4, my method for keeping drive assignment consistent is getting complicated and potentially unreliable. I wonder if there's a way to pull drive or physical connection info and use that to discern appropriate drive assignment more reliably... =/
3. Before Gen 5, I was pulling the flash drive as soon as WinPE was booted so I could plug in the USB loopback plug, but the drive assignment thing is going to make that an issue, so it looks like I'll have to make sure to keep it in until the Serial Number input step. Fortunately, this won't be an issue for our vender since they keep the flash drive plugged in for the test and are not logging tests over a network.
