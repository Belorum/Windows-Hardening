@echo off

REM Batch file created by John Davis @John_Davis

REM Checks to see if running as Administrator
net session >nul 2>&1

if %errorlevel% == 0 (

    REM Checks to see if the Operating Systems is 32 or 64 Bit
    REG QUERY "HKLM\Hardware\Description\System\CentralProcessor\0" | find /i "x86" > NUL && set OS=32 || set OS=64

    REM Temporarily adds PowerShell path to path in case it is not already
    path %path%;C:\Windows\System32\WindowsPowerShell\v1.0

    REM Enables System Restore for the "C:\" drive
    powershell "enable-computerrestore -drive 'C:\'"

    REM Creates Restore Point
    wmic.exe /Namespace:\\root\default Path SystemRestore Call CreateRestorePoint "Restore Point Before Hardening", 100, 7
    echo.

    REM Sets PowerShells Execution Policy for LocalMachine to Restricted
    echo Restricting PowerShell Execution Policy on LocalMachine
    echo -------------------------------------------------------
    powershell "Set-ExecutionPolicy -ExecutionPolicy RESTRICTED -Force"

    echo PowerShell Scope and Execution Policy
    powershell "Get-ExecutionPolicy -list"
    echo.

    REM Disable PowerShell V2
    powershell "Disable-WindowsOptionalFeature -Online -FeatureName MicrosoftWindowsPowerShellV2"

    REM Disables IPv6 via Powershell
    echo Disabling IPv6
    echo --------------

    REM Disables Ethernet IPv6
    powershell "disable-netadapterbinding -name "Ethernet" -Componentid ms_tcpip6"

    REM Disables Ethernet 2 IPv6
    powershell ""disable-netadapterbinding -name 'Ethernet 2' -Componentid ms_tcpip6""

    REM Disables Wifi IPv6
    powershell "disable-netadapterbinding -name "Wi-Fi" -Componentid ms_tcpip6"

    REM Disables Bluetooth IPv6
    powershell ""disable-netadapterbinding -name 'Bluetooth Network Connection' -Componentid ms_tcpip6""

    REM Lists IPv6 Adapters
    powershell "Get-NetAdapterBinding -ComponentID ms_tcpip6"
    echo.

    REM Changes all Networks to Public
    echo Changing All Networks to Public
    echo -------------------------------
    powershell "Get-NetConnectionProfile | Set-NetConnectionProfile -NetworkCategory Public"
    powershell "Get-NetConnectionProfile"

    REM Creates a Scheduled Task that sets all networks to public whenever a new connection is made
    echo Adding Task to set all Networks to Public - Repeats when connecting to a network
    echo --------------------------------------------------------------------------------
    CALL "%~dp0Scripts\SetNetworkToPublic\SetNetworkToPublic.bat"
    echo.

    REM Disable Windows Guest Account
    echo Disabling Windows Guest Account
    echo -------------------------------
    net user guest /active:no

    echo Starting Bad Rabbit Ransomware Prevention
    echo -----------------------------------------
    CALL "%~dp0Scripts\Ransomware Prevention\Badrabbit Prevention.bat"
    echo.

    echo Starting Petya/NotPetya/SortaPetya/Petna Prevention
    echo ---------------------------------------------------
    CALL "%~dp0Scripts\Ransomware Prevention\nopetyavac.bat"
    echo.

    REM Imports Registry Keys based on Operating System Bit Rate
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

      REM Disables WDigest Clear Text Passwords that Mimikatz uses
      echo Disabling WDigest from using clear text passwords in memory
      echo -----------------------------------------------------------
      REG IMPORT "%~dp0Registry Items\Disable_WDigest" /reg:32
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

      REM Disables WDigest Clear Text Passwords that Mimikatz uses
      echo Disabling WDigest from using clear text passwords in memory
      echo -----------------------------------------------------------
      REG IMPORT "%~dp0Registry Items\Disable_WDigest" /reg:64
    )
) else (
  echo This script must be run as an administrator.
  )
pause