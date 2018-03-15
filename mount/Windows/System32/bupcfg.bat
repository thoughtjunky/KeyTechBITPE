@echo off
goto %1 || exit /b
REM
REM Usage
REM bupcfg [ iflash32 | syscfg ] [ 4 | 5 | 6 ]
REM Supported motherboards: S1200BT (syscfg only), S1200RP, S1200SP
REM


:iflash32
pushd "%ProgramFiles%\%1\Gen%2"
call install nul nul >nul 2>&1

REM
REM Gen 4 is broken
REM
if "%2" == "4" echo "Gen 4 is broken, how did you even get here?!?" & goto end
%1 /u %3 UpdateBackupBios ^
	|| call colorecho 0c "Something went wrong flashing BIOS"
goto end


:syscfg
pushd "%ProgramFiles%\%1\Gen%2"
call install nul nul >nul 2>&1
%1 /bcs "" "USB Configuration" "Make USB Devices Non-Bootable" 1 >nul 2>&1 && %1 /prp on >nul 2>&1 ^
	|| call colorecho 0c "Something went wrong setting BIOS config"

	
:end
echo.
popd
exit /b
