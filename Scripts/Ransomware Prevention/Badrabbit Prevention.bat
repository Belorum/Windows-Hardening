REM Prevents Bad Rabbit Ransomware
REM Vaccine by Amit Serper @0xAmit
REM I added a line that removes inheritance from the command line instead of editing via the GUI

REM Creates infpub.dat and cscc.dat in the C:\Windows directory
echo > C:\Windows\infpub.dat && echo > C:\Windows\cscc.dat

REM Removes inheritance from previously created files
icacls C:\Windows\infpub.dat /inheritance:r && icacls C:\Windows\cscc.dat /inheritance:r
