@echo off
@if "%1c"=="c" goto usage
@goto install

:usage
@echo.
@echo USAGE: Install [current-working-directory]
@echo The current-working-directory is the full path containing all the
@echo IMB driver installation files, including this command file.
@echo.
@echo Example:
@echo.
@echo         Install C:\IMBDRV\Test
@echo.
@goto error

:install
@set INSTALL_DIR=%1
@echo.
DeviceSetup.exe -v install flashud.inf *INT0800
DeviceSetup.exe -v install IBSMUx64.inf *IntelUtilDeV
@echo.
@echo Installing IMB driver...
@echo.
devicesetup updateonly imbdrv.inf *IMBDRV >NUL 1>&2

if errorlevel 0 echo "IMBDriver upgraded successfully"  && goto exit

wmic /NAMESPACE:\\root\wmi class Microsoft_IPMI > %tmp%\ms.txt 2>&1

find "No Instance(s) Available." %tmp%\ms.txt >NUL

if errorlevel 1 echo "MSIPMI Driver detected. Skipping IMBDRV installation" && goto exit


devicesetup.exe -v install imbdrv.inf *IMBDRV

:done
@echo Done!
@echo.
@echo Installation Successful
@echo.
@goto exit

:error
@echo.
@echo @@@@ Installation Failed @@@@
@echo.

:exit

rem rem rem rem rem rem rem rem rem rem 
rem MSIPMI detection script. Commented for Build 6
rem rem rem rem rem rem rem rem rem rem 
rem devicesetup updateonly imbdrv.inf *IMBDRV >NUL 1>&2
rem if errorlevel 0 echo "IMBDriver upgraded successfully"  && goto exit
rem wmic /NAMESPACE:\\root\wmi class Microsoft_IPMI >ms.txt 2>&1
rem find "No Instance(s) Available." ms.txt >NUL
rem if errorlevel 1 echo "MSIPMI Driver detected. Skipping IMBDRV installation" && goto exit
rem devicesetup install imbdrv.inf *IMBDRV
rem if errorlevel 0 echo "IMBDriver Installed Successfully" && goto exit
rem echo "Installation of IMBDRV failed"
rem :exit
rem if exist %tmp%\ms.txt del ms.txt > NUL 2>&1