#We need the cmdlets
Install-Module Microsoft.Graph -Verbose -AllowClobber -Force

#Import the module
Import-Module Microsoft.Graph

#Connect to your Microsoft 365 tenant
Connect-MgGraph -Scopes "User.ReadWrite.All"

#Did it work?
Get-MgUser -Top 1

#To create an individual account, use the following
$PasswordProfile = New-Object -TypeName Microsoft.Graph.PowerShell.Models.MicrosoftGraphPasswordProfile
$PasswordProfile.Password = "3Rv0y1q39/chsy"
New-MgUser -DisplayName "John Doe" -GivenName "John" -Surname "Doe" -UserPrincipalName john.doe@cloudtrain.tech -UsageLocation "CH" -MailNickname "johnd" -PasswordProfile $PasswordProfile -AccountEnabled $true

#Verify the account
Get-MgUser -UserId john.doe@cloudtrain.tech

#Create multiple user accounts
# Import the CSV file
$users = Import-Csv -Path "C:\Temp\NewAccounts.csv"

# Create a password profile
$PasswordProfile = @{
    Password = 'Password123'
    }

# Loop through each user in the CSV file
foreach ($user in $users) {
    # Create a new user
    $newUser = New-MgUser -DisplayName $user.DisplayName -GivenName $user.FirstName -Surname $user.LastName -UserPrincipalName $user.UserPrincipalName -UsageLocation $user.UsageLocation -MailNickname $user.MailNickname -PasswordProfile $passwordProfile -AccountEnabled

# Assign a license to the new user
    $e5Sku = Get-MgSubscribedSku -All | Where-Object SkuPartNumber -eq 'SPE_E5'
    Set-MgUserLicense -UserId $newUser.Id -AddLicenses @{SkuId = $e5Sku.SkuId} -RemoveLicenses @()
}

# Export the results to a CSV file
$users | Export-Csv -Path "C:\Temp\NewAccountResults.csv" -NoTypeInformation