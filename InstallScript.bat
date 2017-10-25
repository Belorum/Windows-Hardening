@echo off

reg Query "HKLM\Hardware\Description\System\CentralProcessor\0" | find /i "x86" > NUL && set OS=32 || set OS=64

if %OS%==32 (

  REM Disables Script files from using Windows Script Host
  echo Disabling Windows Script Host
  echo -----------------------------
  REG IMPORT "Registry Items\Disable Windows Script Host" /reg:32
  echo.

  REM DDEAUTO in Microsoft Office to prevent DDEAUTO Attacks
  echo Disabling DDEAUTO from Microsoft Office
  echo ---------------------------------------
  REG IMPORT "Registry Items\DDEAUTO" /reg:32
  echo.
  )
if %OS%==64 (

  REM Disables Script files from using Windows Script Host
  echo Disabling Windows Script Host
  echo -----------------------------
  REG IMPORT "%~dp0Registry Items\Disable Windows Script Host.reg" /reg:64
  echo.

  REM Disable DDEAUTO in Microsoft Office to prevent DDEAUTO Attacks
  echo Disabling DDEAUTO from Microsoft Office
  echo ---------------------------------------
  REG IMPORT "%~dp0Registry Items\DDEAUTO.reg" /reg:64
  echo.
  )

echo Starting Bad Rabbit Ransomware Prevention
echo -----------------------------------------
CALL "%~dp0Ransomware Prevention\Badrabbit Prevention.bat"

pause
