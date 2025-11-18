#Download AzFilesHybrid
#https://github.com/Azure-Samples/azure-files-samples/releases


##Join the Storage Account for SMB Auth Microsoft Source:
##https://learn.microsoft.com/en-us/azure/storage/files/storage-files-identity-ad-ds-enable?WT.mc_id=AZ-MVP-5004159

#Change the execution policy to unblock importing AzFilesHybrid.psm1 module  Use "Get-ExecutionPolicy -List" to view execution policy
Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope CurrentUser
Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope Process

#Navigate to where AzFilesHybrid is unzipped and stored and run to copy the files into your path
.\CopyToPSPath.ps1 

#Import AzFilesHybrid module
Import-Module -Name AzFilesHybrid -force

#Change the execution policy back to RemoteSigned
Set-ExecutionPolicy -ExecutionPolicy Undefined -Scope CurrentUser
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope Process

#Login with an Azure AD credential that has either storage account owner or contributor Azure role assignment
Connect-AzAccount


#Define parameters
$SubscriptionId = "<your-subscription-id-here>" #Azure Subscription ID
$ResourceGroupName = "<resource-group-name-here>" #Storage Account Resource Group Name
$StorageAccountName = "<storage-account-name-here>" #Storage Account Name
$OuDistinguishedName = "<ou-path-for-active-directory-object>" #OU the object will be created in
$DomainAccountType = "ComputerAccount" #ServiceLogonAccount or default ComputerAccount

#Select the target subscription for the current session
Select-AzSubscription -SubscriptionId $SubscriptionId 

#Join the storage account for SMB access using AD DS authentication
Join-AzStorageAccountForAuth `
        -ResourceGroupName $ResourceGroupName `
        -StorageAccountName $StorageAccountName `
        -DomainAccountType $DomainAccountType `
        -OrganizationalUnitDistinguishedName $OuDistinguishedName #If you don't provide the OU name as an input parameter, the AD identity that represents the storage account is created under the root directory.

#You can run the Debug-AzStorageAccountAuth cmdlet to conduct a set of basic checks on your AD configuration with the logged on AD user. This cmdlet is supported on AzFilesHybrid v0.1.2+ version. For more details on the checks performed in this cmdlet, see Azure Files Windows troubleshooting guide.
Debug-AzStorageAccountAuth -StorageAccountName $StorageAccountName -ResourceGroupName $ResourceGroupName -Verbose


#Confirm the feature is enabled
#Get the target storage account
$storageaccount = Get-AzStorageAccount `
        -ResourceGroupName $ResourceGroupName `
        -Name $StorageAccountName

#List the directory service of the selected service account
$storageAccount.AzureFilesIdentityBasedAuth.DirectoryServiceOptions

#List the directory domain information if the storage account has enabled AD DS authentication for file shares
$storageAccount.AzureFilesIdentityBasedAuth.ActiveDirectoryProperties


#####################################################################
#Mount the file share as super user with storage account key

#Define parameters
$StorageAccountName = "<storage-account-name-here>"
$ShareName = "<share-name-here>"
$StorageAccountKey = "<account-key-here>"

#Run the code below to test the connection and mount the share
Test-NetConnection -ComputerName "$StorageAccountName.file.core.windows.net" -Port 445

#Mount the storage account with the storage account key
net use T: "\\$StorageAccountName.file.core.windows.net\$ShareName" /user:Azure\$StorageAccountName $StorageAccountKey /persistent:no


#Path to the file share
#Replace storage account name and share name with your settings
#"\\<StorageAccountName>.file.core.windows.net\<ShareName>"
