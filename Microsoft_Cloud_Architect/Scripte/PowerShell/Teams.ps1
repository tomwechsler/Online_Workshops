Set-Location C:\
Clear-Host

#We need the module (without the parameter for a specific version)
Install-Module MicrosoftTeams -AllowClobber -Force -Verbose

#Let's import the module
Import-Module MicrosoftTeams

#Check the version (if you have not selected a version)
Get-InstalledModule -Name MicrosoftTeams

#Connect to Microsoft Teams
Connect-MicrosoftTeams

#All Teams
Get-Team

#Create new team
New-Team -DisplayName "Logistik" -Visibility Public

#Use the New-TeamChannel cmdlet to create a new standard channel
Get-Team -DisplayName "Logistik" | New-TeamChannel -DisplayName "Wartung" -Description "A channel for maintenance."

#To list all channels of a specific team
Get-Team -DisplayName "Logistik" | Get-TeamChannel

#To modify a channel, use the Set-TeamChannel
Get-Team -DisplayName "Logistik" | Set-TeamChannel -CurrentDisplayName "Wartung" -NewDisplayName "Maintenance2020"

#Remove a channel, by using the Remove-TeamChannel
Get-Team -DisplayName "Logistik" | Remove-TeamChannel -DisplayName "Maintenance2020"