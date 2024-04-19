New-AzResourceGroupdeployment -Name Storage -ResourveGroupName ctt-prod-sta-rg -TemplateFile .\storage_account.json

New-AzResourceGroupdeployment -Name Storage -ResourveGroupName ctt-prod-sta-rg -TemplateFile .\storage_account.bicep -whatif