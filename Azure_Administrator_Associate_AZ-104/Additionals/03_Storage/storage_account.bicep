param location string = resourceGroup().location
param storageAccountName string = 'ctt${uniqueString(resourceGroup().id)}'
resource storageaccount 'Microsoft.Storage/storageAccounts@2021-02-01' = {
  name: storageAccountName
  location: location
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
}
