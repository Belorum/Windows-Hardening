@echo off

REM Inputs first part of XML file for scheduled task
type "%~dp0P1" > SetsAllNetworksToPublic.xml

REM Gets Administrators SID to input into XML file
for /f "delims= " %%a in ('"wmic path win32_useraccount where name='Administrator' get sid"') do (
   if not "%%a"=="SID" (          
      set SID=%%a
	  goto loop
      )   
)
:loop

echo. >> SetsAllNetworksToPublic.xml
echo       ^<UserId^>%SID%^</UserId^> >> SetsAllNetworksToPublic.xml

REM Inputs second part of XML file for scheduled task
type "%~dp0P2" >> SetsAllNetworksToPublic.xml

REM Imports an XML file that will run a powershell command to set all networks to public
schtasks /create /xml "%~dp0SetsAllNetworksToPublic.xml" /tn "Sets All Networks to Public"
