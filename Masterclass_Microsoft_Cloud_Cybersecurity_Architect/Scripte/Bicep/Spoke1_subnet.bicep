// Modul: Spoke1_subnet.bicep
@description('Name des existierenden VNet')
param vnetName string
@description('Name des Subnetzes')
param subnetName string
@description('Adresspräfix für das Subnetz')
param subnetPrefix string

resource subnet 'Microsoft.Network/virtualNetworks/subnets@2021-05-01' = {
  name: '${vnetName}/${subnetName}'
  properties: {
    addressPrefix: subnetPrefix
  }
}

output subnetId string = subnet.id
