if not defined %1 goto usage
if "%1" == "/?" goto usage
goto update

:usage
@echo.
@echo Updates motherboard firmware
@echo.
@echo update [#]
@echo.
@echo 	#		G6 version number (4, 5, or 6) but 4 will fail
@echo 			  if this is WinPE 4.0+
@echo.
@echo note: assumes flash drive assigned letter G
@echo.
exit /b

:update
pushd G:\Gen%1bios
WinPE_x64_Update.bat
popd