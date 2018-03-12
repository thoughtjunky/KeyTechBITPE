
:ColorEcho Color String
REM
REM Prints String in color specified by Color.
REM
REM   Color should be 2 hex digits
REM     The 1st digit specifies the background
REM     The 2nd digit specifies the foreground
REM     See COLOR /? for more help
REM
REM   String is the text to print. All quotes will be stripped.
REM     The string cannot contain any of the following: * ? < > | : \ /
REM     Also, any trailing . or <space> will be stripped.
REM
REM   The string is printed to the screen without issuing a <newline>,
REM   so multiple colors can appear on one line. To terminate the line
REM   without printing anything, use the ECHO( command.
REM
setlocal
pushd %temp%
for /F "tokens=1 delims=#" %%a in ('"prompt #$H#$E# & echo on & for %%b in (1) do REM"') do (
  <nul set/p"=%%a" >"%~2"
)
findstr /v /a:%1 /R "^$" "%~2" nul
del "%~2" > nul 2>&1
popd
exit /b