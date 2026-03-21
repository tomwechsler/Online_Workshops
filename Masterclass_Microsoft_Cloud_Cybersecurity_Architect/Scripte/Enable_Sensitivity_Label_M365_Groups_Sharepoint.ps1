Set-Location C:\
Clear-Host

#We need the cmdlets
Install-Module Microsoft.Graph -Verbose -AllowClobber -Force
Install-Module Microsoft.Graph.Beta -Verbose -AllowClobber -Force

#Import the module
Import-Module Microsoft.Graph

#Let's connect
Connect-MgGraph -Scopes "Directory.ReadWrite.All"

#Did it work?
Get-MgUser -Top 1

#Next, run the following commands to enable sensitivity labels for Microsoft 365 groups and SharePoint sites
$grpUnifiedSetting = Get-MgBetaDirectorySetting | Where-Object { $_.Values.Name -eq "EnableMIPLabels" }
$grpUnifiedSetting.Values

#If the variable is empty, follow the steps below to create the setting

#All the available templates
Get-MgBetaDirectorySettingTemplate

#Call the template we need
$TemplateId = (Get-MgBetaDirectorySettingTemplate | Where-Object { $_.DisplayName -eq "Group.Unified" }).Id
$Template = Get-MgBetaDirectorySettingTemplate | Where-Object -Property Id -Value $TemplateId -EQ

#Create a new object based on the template
$params = @{
   templateId = "$TemplateId"
   values = @(
      @{
         name = "UsageGuidelinesUrl"
         value = "https://guideline.cloudtrain.tech"
      }
      @{
         name = "EnableMIPLabels"
         value = "True"
      }
   )
}

#Create the directory setting
New-MgBetaDirectorySetting -BodyParameter $params

#Verify the setting
$Setting = Get-MgBetaDirectorySetting | Where-Object { $_.DisplayName -eq "Group.Unified"}
$Setting.Values

#Get the current settings from the Group.Unified SettingsTemplate
$Setting = Get-MgBetaDirectorySetting | Where-Object { $_.DisplayName -eq "Group.Unified"}

#To change the value of UsageGuidelinesUrl

#Check the current settings
$Setting.Values

#To remove the value of UsageGuideLinesUrl
$params = @{
   Values = @(
      @{
         Name = "UsageGuidelinesUrl"
         Value = ""
      }
   )
}

#Update the value
Update-MgBetaDirectorySetting -DirectorySettingId $Setting.Id -BodyParameter $params