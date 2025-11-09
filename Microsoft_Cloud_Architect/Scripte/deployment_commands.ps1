#Install the Azure PowerShell Module
Install-Module -Name Az -AllowClobber -Verbose -Force

#Connect to Azure
Connect-AzAccount

#List all resource groups
Get-AzResourceGroup

#Create a new resource group
New-AzResourceGroup -Name "cttdemorg" -location "westeurope"

#Deploy the armtemplate file
New-AzResourceGroupDeployment -name "armtemplate" -ResourceGroupName "clidemorg" -TemplateFile "Bicep/Hub_and_Spoke.bicep" -WhatIf

#Delete the resource group
Remove-AzResourceGroup -Name "cttdemorg" -Force