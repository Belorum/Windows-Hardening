@echo off
REM Prevents Bad Rabbit Ransomware
REM Vaccine by Amit Serper @0xAmit
REM I added a line that removes inheritance from the command line instead of editing via the GUI

REM Creates infpub.dat and cscc.dat in the C:\Windows directory
echo This file is a vaccine for Bad Rabbit Ransomware, please do not remove. > C:\Windows\infpub.dat && echo This file is a vaccine for Bad Rabbit Ransomware, please do not remove. > C:\Windows\cscc.dat

REM Removes inheritance from previously created files
icacls C:\Windows\infpub.dat /inheritance:r /remove Administrators /Q && icacls C:\Windows\cscc.dat /inheritance:r /remove Administrators /Q

echo.
echo Bad Rabbit Vaccination Complete
