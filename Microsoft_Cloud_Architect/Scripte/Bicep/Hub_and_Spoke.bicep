@description('Location for all resources')
param location string = resourceGroup().location

@description('Prefix for resource naming')
param prefix string = 'ctt'

@description('Address space for the hub network')
param hubAddressSpace string = '10.0.0.0/16'

@description('Address space for spoke1 (Dev)')
param spoke1AddressSpace string = '10.1.0.0/16'

@description('Hub subnet: GatewaySubnet prefix')
param gatewaySubnetPrefix string = '10.0.0.0/27'

@description('Hub subnet: AzureFirewallSubnet prefix')
param azureFirewallSubnetPrefix string = '10.0.1.0/26'

@description('Hub subnet: RouteServerSubnet prefix')
param routeServerSubnetPrefix string = '10.0.2.0/27'

@description('Hub subnet: AzureBastionSubnet prefix')
param azureBastionSubnetPrefix string = '10.0.3.0/27'

@description('Additional hub subnets as array of objects { name: string, prefix: string }')
param hubAdditionalSubnets array = []

var hubSubnets = concat([
	{
		name: 'GatewaySubnet'
		prefix: gatewaySubnetPrefix
	}
	{
		name: 'AzureFirewallSubnet'
		prefix: azureFirewallSubnetPrefix
	}
	{
		name: 'RouteServerSubnet'
		prefix: routeServerSubnetPrefix
	}
	{
		name: 'AzureBastionSubnet'
		prefix: azureBastionSubnetPrefix
	}
], hubAdditionalSubnets)

@description('Address space for spoke2 (Prod)')
param spoke2AddressSpace string = '10.2.0.0/16'

resource hubVnet 'Microsoft.Network/virtualNetworks@2023-04-01' = {
	name: '${prefix}-hub-vnet'
	location: location
	properties: {
		addressSpace: {
			addressPrefixes: [hubAddressSpace]
		}
		subnets: [for s in hubSubnets: {
			name: s.name
			properties: {
				addressPrefix: s.prefix
			}
		}]
	}
}

resource spoke1Vnet 'Microsoft.Network/virtualNetworks@2023-04-01' = {
name: '${prefix}-spoke1-vnet'
location: location
properties: {
addressSpace: {
addressPrefixes: [spoke1AddressSpace]
}
}
}

resource spoke2Vnet 'Microsoft.Network/virtualNetworks@2023-04-01' = {
name: '${prefix}-spoke2-vnet'
location: location
properties: {
addressSpace: {
addressPrefixes: [spoke2AddressSpace]
}
}
}

resource hubToSpoke1 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2023-04-01' = {
name: 'hub-to-spoke1'
parent: hubVnet
properties: {
remoteVirtualNetwork: {
id: spoke1Vnet.id
}
allowVirtualNetworkAccess: true
allowForwardedTraffic: true
allowGatewayTransit: false
useRemoteGateways: false
}
}

resource spoke1ToHub 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2023-04-01' = {
name: 'spoke1-to-hub'
parent: spoke1Vnet
properties: {
remoteVirtualNetwork: {
id: hubVnet.id
}
allowVirtualNetworkAccess: true
allowForwardedTraffic: true
allowGatewayTransit: false
useRemoteGateways: false
}
}

resource hubToSpoke2 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2023-04-01' = {
name: 'hub-to-spoke2'
parent: hubVnet
properties: {
remoteVirtualNetwork: {
id: spoke2Vnet.id
}
allowVirtualNetworkAccess: true
allowForwardedTraffic: true
allowGatewayTransit: false
useRemoteGateways: false
}
}

resource spoke2ToHub 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2023-04-01' = {
name: 'spoke2-to-hub'
parent: spoke2Vnet
properties: {
remoteVirtualNetwork: {
id: hubVnet.id
}
allowVirtualNetworkAccess: true
allowForwardedTraffic: true
allowGatewayTransit: false
useRemoteGateways: false
}
}
