@echo off

REM
REM Allow powershell scripting (used for ejecting the CD)
REM
powershell set-executionpolicy unrestricted
	if errorlevel 1 (
		call colorecho 0c "Failed to set Powershell Execution Policy"
		@echo.
		call colorecho 0c "this is required for automatic ejection of the CD upon test completion"
		@echo.
		@echo.
		)

REM
REM Eject the CD
REM
powershell Set-CDDriveState -eject >nul 2>&1
if errorlevel 1 (
	call colorecho 0c "Unable to eject CD"
	goto cmdline
	) else (
	call colorecho 0a "CD Ejected"
	)
	@echo.
	@echo.

exit /b