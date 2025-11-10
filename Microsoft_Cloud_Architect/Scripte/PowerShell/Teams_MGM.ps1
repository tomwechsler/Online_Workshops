Set-Location C:\
Clear-Host

# We need the module (without the parameter for a specific version)
Install-Module MicrosoftTeams -AllowClobber -Force -Verbose

# Let's import the module
Import-Module MicrosoftTeams

# Check the version (if you have not selected a version)
Get-InstalledModule -Name MicrosoftTeams

# Connect to Microsoft Teams
Connect-MicrosoftTeams

# List the teams
Get-Team

# Create a new Team
New-Team `
    -DisplayName "Accounting Team" `
    -Description "Internal Collaboration place for the Accounting Team" `
    -Visibility Public

# Some team settings
Set-Team -GroupId cabee088-ba80-4e7b-aab7-446e555f5491 `
	-Visibility Public `
	-AllowChannelMentions $false `
	-AllowCreateUpdateChannels $false `
    -AllowUserDeleteMessages $false `
    -AllowUserEditMessages $false `
    -AllowGiphy $false `
	-AllowStickersAndMemes $false

# Add a channel
New-TeamChannel `
    -GroupId cabee088-ba80-4e7b-aab7-446e555f5491 `
	-DisplayName "Milestones" `
    -MembershipType Private

# Some channel settings
Set-TeamChannel -GroupId cabee088-ba80-4e7b-aab7-446e555f5491 `
	-CurrentDisplayName "Milestones" `
	-NewDisplayName "Targets" `
	-Description "Use this channel to share the project targets"

# List owner
Get-TeamUser -GroupId cabee088-ba80-4e7b-aab7-446e555f5491 -Role Owner

# List member
Get-TeamUser -GroupId cabee088-ba80-4e7b-aab7-446e555f5491 -Role Member

# Add a member
Add-TeamUser -GroupId cabee088-ba80-4e7b-aab7-446e555f5491 `
    -User james.prio@cloudtrain.tech

# Add an owner
Add-TeamUser -GroupId cabee088-ba80-4e7b-aab7-446e555f5491 `
    -User sina.doovi@cloudtrain.tech `
    -Role Owner

# Remove a team
Remove-Team -GroupId cabee088-ba80-4e7b-aab7-446e555f5491