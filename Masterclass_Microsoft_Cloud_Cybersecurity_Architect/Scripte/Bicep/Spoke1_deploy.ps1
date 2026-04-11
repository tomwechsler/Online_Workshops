$pub = Get-Content "$HOME/.ssh/id_rsa.pub" -Raw
$parameters = @{
  vnetName = 'ctt-spoke1-vnet'
  vnetResourceGroup = 'ctt-bicep-rg'
  subnetName = 'spoke1-subnet'
  subnetPrefix = '10.1.1.0/24'
  vmCount = 3
  adminUsername = 'azureuser'
  adminPublicKey = $pub
  vmSize = 'Standard_B1s'
  location = 'westeurope'
  vmPrefix = 'spoke1'
}

New-AzResourceGroupDeployment -ResourceGroupName 'ctt-bicep-rg' -TemplateFile '.\Spoke1_deploy.bicep' -TemplateParameterObject $parameters