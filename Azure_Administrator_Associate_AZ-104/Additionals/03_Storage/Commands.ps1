New-AzResourceGroupdeployment -Name Storage -ResourceGroupName ctt-prod-sta-rg -TemplateFile .\storage_account.json

New-AzResourceGroupdeployment -Name Storage -ResourceGroupName ctt-prod-sta-rg -TemplateFile .\storage_account.bicep -whatif