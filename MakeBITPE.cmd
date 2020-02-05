@echo off

setlocal

::
:: Assign local variables
::
set tmpl=media
set DskPrtScrpt=%tmp%\FrmtDskScrpt.txt
set WrkngDir=%~dp0
set /p DEST=Drive to install to?
echo.

::
:: Ensure working directory is valid
::
if not exist "%WrkngDir%%tmpl%" (
	echo ERROR: Working directory is not valid: %WrkngDir%.
	pause >nul
	exit /b 1
)
if not defined %tmp% (
  set DskPrtScrpt=.\FrmtDskScrpt.txt
)

::
:: Enure user has administrator privileges
:: This is necessary to format drive and set boot code
::
set testdir="%WINDIR%\System32\Test_%RANDOM%"
mkdir "%testdir%" 2>nul
if errorlevel 1 (
	echo ERROR: You must run this command with administrator privileges.
	pause >nul
	exit /b 1
  ) else (
	rd /s /q "%testdir%"
  )

::
:: Ensure destination refers to a storage drive,
:: and not another type of path
::
echo %DEST%| findstr /B /E /I "[A-Z]" >nul
if errorlevel 1 (
	echo ERROR: Destination must be a drive letter
	pause >nul
	exit /b 1
  )

::
:: Ensure Destination path exists
::
if not exist "%DEST%:" (
	echo ERROR: Destination drive %DEST% does not exist.
	pause >nul
	exit /b 1
  )

::
:: Confirm from user that they want to format drive
::
echo WARNING, ALL DATA ON DISK DRIVE %DEST% WILL BE LOST!
choice /M "Proceed with Format "
echo.
if errorlevel 2 goto NoFormat
if errorlevel 1 goto Format

:NoFormat
echo %DEST% will not be formatted; press any key to exit.
pause >nul
exit /b 0

:Format
::
:: Format volume as FAT32 with diskpart
::
echo select volume=%DEST% > "%DskPrtScrpt%"
echo format fs=fat32 label="WinPE" quick >> "%DskPrtScrpt%"
echo active >> "%DskPrtScrpt%"
echo Formatting %DEST%
echo.
diskpart /s "%DskPrtScrpt%" >nul
set DPERR=%ERRORLEVEL%

del /F /Q "%DskPrtScrpt%"
if errorlevel 1 (
	echo WARNING: Failed to delete temporary DiskPart script %DskPrtScrpt%.
  )

if %DPERR% NEQ 0 (
	echo ERROR: Failed to format %DEST%; DiskPart errorlevel %DPERR%.
	pause >nul
	exit /b 1
  )

::
:: Set boot code with bootsect

::
echo Setting boot code on %DEST%
echo.
bootsect.exe /nt60 %DEST%: /force /mbr >nul
if errorlevel 1 (
	echo ERROR: Failed to set boot code on %DEST%.
	pause >nul
	exit /b 1
  )

::
:: decompress media files to avoid an issue with xcopy
::  in case of a compressed NTFS source directory.
::
compact /u "%WrkngDir%%tmpl%" >nul
if errorlevel 1 (
	echo ERROR: Failed to decompress %WrkngDir%%tmpl%.
	pause >nul
	exit /b 1
  )

::
:: Copy media files to destination
::
echo Copying files to %DEST%, this may take up to 4 minutes...
echo.
xcopy /herky "%WrkngDir%%tmpl%" "%DEST%:\" >nul
if errorlevel 1 (
	echo ERROR: Failed to copy files to %DEST%\.
	pause >nul
	exit /b 1
  )

:Done

endlocal
echo.
echo Success!
echo.
echo Press any key to exit.
pause >nul