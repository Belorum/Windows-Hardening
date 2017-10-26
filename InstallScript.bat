@echo off

REM Checks to see if the Operating Systems is 32 or 64 Bit
REG QUERY "HKLM\Hardware\Description\System\CentralProcessor\0" | find /i "x86" > NUL && set OS=32 || set OS=64

REM Enables System Restore for the "C:\" drive
powershell "enable-computerrestore -drive 'C:\'"

REM Creates Restore Point
wmic.exe /Namespace:\\root\default Path SystemRestore Call CreateRestorePoint "Restore Point Before Hardening", 100, 7
echo.

REM Sets Powershells Execution Policy for LocalMachine to Restricted
powershell "Set-ExecutionPolicy -ExecutionPolicy RESTRICTED -Force"

echo Powershell Scope and Execution Policy
powershell "Get-ExecutionPolicy -list"
echo.

if %OS%==32 (

  REM Disables Script files from using Windows Script Host
  echo Disabling Windows Script Host
  echo -----------------------------
  REG IMPORT "%~dp0Registry Items\Disable Windows Script Host" /reg:32
  echo.

  REM DDEAUTO in Microsoft Office to prevent DDEAUTO Attacks
  echo Disabling DDEAUTO from Microsoft Office
  echo ---------------------------------------
  REG IMPORT "%~dp0Registry Items\DDEAUTO" /reg:32
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

REM Disable Windows Guest Account
echo Disabling Windows Guest Account
echo -------------------------------
net user guest /active:no

echo Starting Bad Rabbit Ransomware Prevention
echo -----------------------------------------
CALL "%~dp0Scripts\Ransomware Prevention\Badrabbit Prevention.bat"
echo.

pause
