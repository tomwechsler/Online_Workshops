// Spoke1_deploy.bicep
// Erstellt ein Subnetz in einem bestehenden VNet (z.B. ctt-spoke1-vnet)
// und 3 Linux-VMs (SSH-Key auth). Übergabe der SSH-Public-Key ist erforderlich.

@description('Name des existierenden VNet (Standard: ctt-spoke1-vnet)')
param vnetName string = 'ctt-spoke1-vnet'
@description('Resource Group des existierenden VNet (Standard: aktuelle RG)')
param vnetResourceGroup string = resourceGroup().name
@description('Name des zu erstellenden Subnetzes')
param subnetName string = 'spoke1-subnet'
@description('Adresspräfix für das Subnetz')
param subnetPrefix string = '10.1.1.0/24'
@description('Anzahl VMs (standard 3)')
param vmCount int = 3
@minLength(1)
param adminUsername string
@description('SSH public key (ssh-rsa ... )')
param adminPublicKey string
@description('VM-Größe')
param vmSize string = 'Standard_B1s'
@description('Standort (default: Resource Group location)')
param location string = resourceGroup().location
@description('Präfix für Ressourcen-/VM-Namen')
param vmPrefix string = 'spoke1'

// Referenz auf das existierende VNet (kann in anderer RG liegen)
resource vnet 'Microsoft.Network/virtualNetworks@2021-05-01' existing = {
  name: vnetName
  scope: resourceGroup(vnetResourceGroup)
}

// Subnetz im existierenden VNet anlegen (in der RG des existierenden VNet)
// Subnetz als Modul in der RG des existierenden VNet bereitstellen (vermeidet BCP165)
module createSubnet 'Spoke1_subnet.bicep' = {
  name: 'createSubnet'
  scope: resourceGroup(vnetResourceGroup)
  params: {
    vnetName: vnetName
    subnetName: subnetName
    subnetPrefix: subnetPrefix
  }
}

// Subnet ID für NICs (setzt voraus, dass das Modul das Subnetz erstellt)
var subnetId = resourceId(vnetResourceGroup, 'Microsoft.Network/virtualNetworks/subnets', vnetName, subnetName)

// Network Security Group mit SSH erlaubt
resource nsg 'Microsoft.Network/networkSecurityGroups@2021-02-01' = {
  name: '${vmPrefix}-nsg'
  location: location
  properties: {
    securityRules: [
      {
        name: 'Allow-SSH'
        properties: {
          priority: 1000
          protocol: 'Tcp'
          access: 'Allow'
          direction: 'Inbound'
          sourceAddressPrefix: '*'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRange: '22'
        }
      }
    ]
  }
}

// Public IPs (dynamisch) für jede VM
resource publicIPs 'Microsoft.Network/publicIPAddresses@2021-02-01' = [for i in range(0, vmCount): {
  name: '${vmPrefix}-pip-${i + 1}'
  location: location
  sku: {
    name: 'Basic'
  }
  properties: {
    publicIPAllocationMethod: 'Dynamic'
  }
}]

// Network Interfaces, jeweils mit Zuordnung zum Subnetz und NSG
resource nics 'Microsoft.Network/networkInterfaces@2021-03-01' = [for i in range(0, vmCount): {
  name: '${vmPrefix}-nic-${i + 1}'
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          subnet: {
            id: subnetId
          }
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: publicIPs[i].id
          }
        }
      }
    ]
    networkSecurityGroup: {
      id: nsg.id
    }
  }
  dependsOn: [
    createSubnet
  ]
}]

// Image-Definition (Ubuntu LTS)
var imageRef = {
  publisher: 'Canonical'
  offer: '0001-com-ubuntu-server-focal'
  sku: '20_04-lts-gen2'
  version: 'latest'
}

// Virtual Machines (Loop)
resource virtualMachines 'Microsoft.Compute/virtualMachines@2021-07-01' = [for i in range(0, vmCount): {
  name: '${vmPrefix}-vm-${i + 1}'
  location: location
  properties: {
    hardwareProfile: {
      vmSize: vmSize
    }
    osProfile: {
      computerName: '${vmPrefix}-vm-${i + 1}'
      adminUsername: adminUsername
      linuxConfiguration: {
        disablePasswordAuthentication: true
        ssh: {
          publicKeys: [
            {
              path: '/home/${adminUsername}/.ssh/authorized_keys'
              keyData: adminPublicKey
            }
          ]
        }
      }
    }
    storageProfile: {
      imageReference: imageRef
      osDisk: {
        createOption: 'FromImage'
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: nics[i].id
        }
      ]
    }
  }
  dependsOn: [
    nics[i]
  ]
}]

output vmNames array = [for i in range(0, vmCount): virtualMachines[i].name]
output publicIpIds array = [for i in range(0, vmCount): publicIPs[i].id]
