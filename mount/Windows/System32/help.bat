@Echo off
@echo.
@echo help		Displays this page
@echo.
@echo snap [path]	Take screenshots. path must include full filename 
@echo			i.e. G:\capture.png
@echo.
@echo formatc		Clean disk 0, quick format, assign letter C
@echo.
@echo formatfw4	Clean disks 1-2, quick format, assign letters E-F
@echo.
@echo formatfw5	Clean disks 2-3, quick format, assign letters E-F
@echo.
@echo cleanc		Romove all partition data from disk 0
@echo.
@echo mapn		Force attempt to map network drive N:\ for storing log files
@echo.
@echo g5update	Manually update Gen 5 Firmware
@echo.
@echo startnet [v]	Rerun script. v parameter turns Echo ON for troubleshooting
@echo.
@echo bit		Open BurnInTest
@echo.
@echo taskmgr		Run the task manager
@echo.
@echo diskpart	Windows Disk Partitioning Utility
@echo.
@echo bootsect	Manage Master Boot record
@echo.
@echo bcdedit		Boot Configuration Data Store Editor
@echo.
@echo bcdboot		Bcd boot file creation and repair tool
@echo.
@echo dism		Deployment Image Servicing and Management
@echo.
@echo ipconfig	Show network information
@echo.
@echo notepad		useful for looking at or editing the batch files
@echo.
@echo ping		test a network connection
@echo.
@echo regedit		edit the registry
@echo.
@echo wpeutil		manage services, shutdown or reboot computer
@echo.
@echo.
@echo Powershell Set-CDDriveState [-Eject^|-Close]	manually eject or close the CD tray
@echo.