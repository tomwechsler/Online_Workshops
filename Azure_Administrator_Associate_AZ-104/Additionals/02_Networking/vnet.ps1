Install-Module -Name Az -AllowClobber -Verbose -Force

Connect-AzAccount

$rg = @{
    Name = 'hub-spoke-rg'
    Location = 'westeurope'
}
New-AzResourceGroup @rg

$vnet = @{
    Name = 'hub-vnet-1'
    ResourceGroupName = 'hub-spoke-rg'
    Location = 'westeurope'
    AddressPrefix = '10.50.0.0/16'
}
$virtualNetwork = New-AzVirtualNetwork @vnet

$subnet = @{
    Name = 'subnet-1'
    VirtualNetwork = $virtualNetwork
    AddressPrefix = '10.50.0.0/24'
}
$subnetConfig = Add-AzVirtualNetworkSubnetConfig @subnet

$virtualNetwork | Set-AzVirtualNetwork