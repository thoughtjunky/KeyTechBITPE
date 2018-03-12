@echo off
REM
REM Usage
REM bupcfg [ iflash32 | syscfg ] [ 4 | 5 | 6 ]
REM Supported motherboards: S1200BT (syscfg only), S1200RP, S1200SP
REM

goto %1

:iflash32
pushd "%ProgramFiles%\iflash32\Gen%2"
if "%verbose%" == "true" (
	call install.cmd
  ) else (
	call install.cmd nul nul >nul 2>&1
  )

REM
REM Gen 4 is broken
REM
if "%2" == "4" echo "Gen 4 is broken, how did you even get here?!?" && goto end
iflash32.exe /u %3 UpdateBackupBios
	if errorlevel 1 (
		call colorecho 0c "Something went wrong flashing BIOS"
		exit /b 1
	  )
goto end


:syscfg
pushd "%ProgramFiles%\syscfg\Gen%2"
if "%verbose%" == "true" (
	call install.cmd
  ) else (
	call install.cmd nul nul >nul 2>&1
  )

syscfg.exe /bcs "" "USB Configuration" "Make USB Devices Non-Bootable" 1 >nul 2>&1
	if errorlevel 1 (
		call colorecho 0c "Something went wrong setting BIOS config"
		exit /b 1
	  )
syscfg.exe /prp on >nul 2>&1
	if errorlevel 1 (
		call colorecho 0c "Something went wrong setting BIOS config"
		exit /b 1
	  )

:end
echo.
popd
exit /b
