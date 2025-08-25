New-Item -Type Directory -Path "C:\HWID"

Set-Location -Path "C:\HWID"

Set-ExecutionPolicy -Scope Process -ExecutionPolicy Unrestricted

Install-Script -Name Get-WindowsAutoPilotInfo

Get-WindowsAutoPilotInfo.ps1 -OutputFile AutoPilotHWID.csv

#Direct upload to intune
Get-WindowsAutoPilotInfo.ps1 -online