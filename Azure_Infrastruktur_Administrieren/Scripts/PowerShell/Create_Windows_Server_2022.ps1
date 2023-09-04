# Create a resource group
$rgName = "myResourceGroup"
$location = "WestEurope"
New-AzResourceGroup -Name $rgName -Location $location

# Create a virtual network and a subnet
$vnetName = "myVnet"
$subnetName = "mySubnet"
$subnetConfig = New-AzVirtualNetworkSubnetConfig -Name $subnetName -AddressPrefix "10.0.0.0/24"
New-AzVirtualNetwork -Name $vnetName -ResourceGroupName $rgName -Location $location -AddressPrefix "10.0.0.0/16" -Subnet $subnetConfig

# Create a network security group and a rule to allow RDP
$nsgName = "myNsg"
$rdpRule = New-AzNetworkSecurityRuleConfig -Name "AllowRDP" -Protocol Tcp -Direction Inbound -Priority 1000 -SourceAddressPrefix * -SourcePortRange * -DestinationAddressPrefix * -DestinationPortRange 3389 -Access Allow
$nsg = New-AzNetworkSecurityGroup -ResourceGroupName $rgName -Location $location -Name $nsgName -SecurityRules $rdpRule

# Associate the network security group to the subnet
Set-AzVirtualNetworkSubnetConfig -VirtualNetwork $vnet -Name $subnetName -NetworkSecurityGroup $nsg

# Create a public IP address
$pipName = "myPublicIp"
$pip = New-AzPublicIpAddress -ResourceGroupName $rgName -Location $location -AllocationMethod Static -IdleTimeoutInMinutes 4 -Name $pipName

# Create a network interface card
$nicName = "myNic"
$nic = New-AzNetworkInterface -Name $nicName -ResourceGroupName $rgName -Location $location -SubnetId $vnet.Subnets[0].Id -PublicIpAddressId $pip.Id

# Specify the image to use for the VM
$image = Get-AzVMImagePublisher | Where-Object {$_.PublisherName.Contains("MicrosoftWindowsServer")} | Get-AzVMImageOffer | Where-Object {$_.Offer.Contains("WindowsServer")} | Get-AzVMImageSku | Where-Object {$_.Sku.Contains("2022-datacenter-azure-edition")}

# Specify the credentials for the VM
$cred = Get-Credential

# Create the VM configuration
$vmConfig = New-AzVMConfig -VMName "myVM" -VMSize "Standard_D2s_v3" | Set-AzVMOperatingSystem -Windows -ComputerName "myVM" -Credential $cred | Set-AzVMSourceImage -PublisherName $image.PublisherName `
-Offer $image.Offer `
-Skus $image.Skus `
-Version "latest" | Add-AzVMNetworkInterface `
-Id $nic.Id

# Create the VM
New-AzVM -ResourceGroupName $rgName `
-Location $location `
-VM $vmConfig