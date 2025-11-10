Set-Location C:\
Clear-Host

#We need the module (without the parameter for a specific version)
Install-Module -Name ExchangeOnlineManagement -AllowClobber -Force -Verbose

#Let's import the module
Import-Module ExchangeOnlineManagement

#Check the version (if you have not selected a version)
Get-InstalledModule -Name ExchangeOnlineManagement

#Now we connect to Exchange Online
Connect-ExchangeOnline

#Use the Get-OrganizationConfig cmdlet to get configuration data for an Exchange organization
Get-OrganizationConfig

#Exporting the organization data to an XML file
Get-OrganizationConfig | Export-CliXML C:\Data\MyFile.xml

#Configure the external postmaster address in Exchange Online
#Let's look at the values of the Organization
Get-TransportConfig | Format-List


#Let's look at the settings of the organization for SendFromAliasEnabled
Get-OrganizationConfig | Format-List

Get-OrganizationConfig | Select-Object SendFromAliasEnabled

(Get-OrganizationConfig).SendFromAliasEnabled

#Enable Send from Alias in Microsoft 365 tenant
Set-OrganizationConfig -SendFromAliasEnabled $True

#Did it work?
(Get-OrganizationConfig).SendFromAliasEnabled


#When the sender adds a distribution group that has more members than the configured large audience size, they are shown the Large Audience MailTip
#Let's look at the settings of the organization for MailTipsLargeAudienceThreshold
Get-OrganizationConfig | Format-List

(Get-OrganizationConfig).MailTipsLargeAudienceThreshold

#We set the value to 5
Set-OrganizationConfig -MailTipsLargeAudienceThreshold 5


#Change how long permanently deleted items are kept
#Let's look at Jon's Mailbox
Get-Mailbox -Identity "dave.molina" | Select-Object RetainDeletedItemsFor

#Set Jon Prime's mailbox to keep deleted items for 30 days
Set-Mailbox -Identity "dave.molina" -RetainDeletedItemsFor 30

#Did it work?
Get-Mailbox -Identity "dave.molina" | Select-Object RetainDeletedItemsFor

#Set all user mailboxes in the organization to keep deleted items for 30 days
Get-Mailbox -ResultSize unlimited -Filter "RecipientTypeDetails -eq 'UserMailbox'" | Set-Mailbox -RetainDeletedItemsFor 30

#Did it work?
Get-Mailbox -ResultSize unlimited -Filter "RecipientTypeDetails -eq 'UserMailbox'" | Format-List Name,RetainDeletedItemsFor

#But what about the mailboxes that are newly created?
#Let's take a look at the mailbox plans
Get-MailboxPlan | Format-Table -AutoSize

#What is the value in these plans?
Get-MailboxPlan | Select-Object Name, RetainDeletedItemsFor

#Let us now set the value to 30 for all plans
Get-MailboxPlan | Set-MailboxPlan -RetainDeletedItemsFor 30

#Did it work?
#Now when a new mailbox is created, the deleted objects are kept for 30 days
Get-MailboxPlan | Select-Object Name, RetainDeletedItemsFor

#Configure Focused Inbox for everyone in your organization
#What is the current value? No value is returned, the feature is active
Get-OrganizationConfig | Format-List Focused*

#We can turn off this feature for the whole organization
Set-OrganizationConfig -FocusedInboxOn $false

#Did it work?
Get-OrganizationConfig | Format-List Focused*