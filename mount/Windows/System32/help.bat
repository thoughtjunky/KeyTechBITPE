@Echo off
@echo help		Displays this page
@echo formatc		Clean disk 0, quick format, assign letter C
@echo formatfw4	Clean disks 1-2, quick format, assign letters E-F
@echo formatfw5	Clean disks 2-3, quick format, assign letters E-F
@echo cleanc		Romove all partition data from disk 0
@echo mapn		Force attempt to map network drive N:\ for storing log files
@echo g5update	Manually update Gen 5 Firmware
@echo startnet [v]	Rerun script. v parameter turns Echo ON for troubleshooting
@echo bit		Open BurnInTest
@echo taskmgr		Run the task manager
@echo snap [path]	Take screenshots. path must include full filename 
@echo			i.e. G:\capture.png
::diskpart
::dism
::ipconfig
::net
::netcfg
::netsh
::notepad
::ping
::regedt32
::replace
::robocopy
::services
::wdscapture
::wdsclient
::wdsmcast
