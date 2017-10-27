@echo off

REM Imports an XML file that will run a powershell command to set all networks to public
schtasks /create /xml "%~dp0SetNetworksToPublic.xml" /tn "Sets All Networks to Public"
