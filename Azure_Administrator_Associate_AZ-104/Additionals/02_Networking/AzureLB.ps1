Connect-AzAccount

Get-AzContext

Get-AzLocation

## Create a public IP
$publicip = @{
    Name = 'ctt-public-pip'
    ResourceGroupName = 'ctt-prod-vms-rg'
    Location = 'switzerlandnorth'
    Sku = 'Standard'
    AllocationMethod = 'static'
    Zone = 1
}
New-AzPublicIpAddress @publicip

## Place public IP created in previous steps into variable. ##
$pip = @{
    Name = 'ctt-public-pip'
    ResourceGroupName = 'ctt-prod-vms-rg'
}
$publicIp = Get-AzPublicIpAddress @pip

## Create load balancer frontend configuration and place in variable. ##
$fip = @{
    Name = 'cttfrontend'
    PublicIpAddress = $publicIp 
}
$feip = New-AzLoadBalancerFrontendIpConfig @fip

## Create backend address pool configuration and place in variable. ##
$bepool = New-AzLoadBalancerBackendAddressPoolConfig -Name 'cttbackendpool'

## Create the health probe and place in variable. ##
$probe = @{
    Name = 'ctthealthprobe'
    Protocol = 'tcp'
    Port = '80'
    IntervalInSeconds = '360'
    ProbeCount = '5'
}
$healthprobe = New-AzLoadBalancerProbeConfig @probe

## Create the load balancer rule and place in variable. ##
$lbrule = @{
    Name = 'ctthttprule'
    Protocol = 'tcp'
    FrontendPort = '80'
    BackendPort = '80'
    IdleTimeoutInMinutes = '15'
    FrontendIpConfiguration = $feip
    BackendAddressPool = $bePool
}
$rule = New-AzLoadBalancerRuleConfig @lbrule -EnableTcpReset -DisableOutboundSNAT

## Create the load balancer resource. ##
$loadbalancer = @{
    ResourceGroupName = 'ctt-prod-vms-rg'
    Name = 'cttloadbalancer'
    Location = 'switzerlandnorth'
    Sku = 'Standard'
    FrontendIpConfiguration = $feip
    BackendAddressPool = $bePool
    LoadBalancingRule = $rule
    Probe = $healthprobe
}
New-AzLoadBalancer @loadbalancer

## Create public IP address for NAT gateway ##
$ip = @{
    Name = 'cttnatgatewaypip'
    ResourceGroupName = 'ctt-prod-vms-rg'
    Location = 'switzerlandnorth'
    Sku = 'Standard'
    AllocationMethod = 'Static'
}
$publicIP = New-AzPublicIpAddress @ip

## Create NAT gateway resource ##
$nat = @{
    ResourceGroupName = 'ctt-prod-vms-rg'
    Name = 'cttnatgateway'
    IdleTimeoutInMinutes = '10'
    Sku = 'Standard'
    Location = 'switzerlandnorth'
    PublicIpAddress = $publicIP
}
$natGateway = New-AzNatGateway @nat

## Create backend subnet config ##
$subnet = @{
    Name = 'cttbackendsubnet'
    AddressPrefix = '10.1.0.0/24'
    NatGateway = $natGateway
}
$subnetConfig = New-AzVirtualNetworkSubnetConfig @subnet 

## Create Azure Bastion subnet. ##
$bastsubnet = @{
    Name = 'AzureBastionSubnet' 
    AddressPrefix = '10.1.1.0/26'
}
$bastsubnetConfig = New-AzVirtualNetworkSubnetConfig @bastsubnet

## Create the virtual network ##
$net = @{
    Name = 'ctt-lb-vnet'
    ResourceGroupName = 'ctt-prod-vnet-rg'
    Location = 'switzerlandnorth'
    AddressPrefix = '10.1.0.0/16'
    Subnet = $subnetConfig,$bastsubnetConfig
}
$vnet = New-AzVirtualNetwork @net

## Create public IP address for bastion host. ##
$ip = @{
    Name = 'cttbastionpip'
    ResourceGroupName = 'ctt-prod-vnet-rg'
    Location = 'switzerlandnorth'
    Sku = 'Standard'
    AllocationMethod = 'Static'
}
$publicip = New-AzPublicIpAddress @ip

## Create bastion host ##
$bastion = @{
    ResourceGroupName = 'ctt-prod-vnet-rg'
    Name = 'cttbastionhost'
    PublicIpAddress = $publicip
    VirtualNetwork = $vnet
}
New-AzBastion @bastion -AsJob

## Create rule for network security group and place in variable. ##
$nsgrule = @{
    Name = 'cttnsghttprule'
    Description = 'Allow HTTP'
    Protocol = '*'
    SourcePortRange = '*'
    DestinationPortRange = '80'
    SourceAddressPrefix = 'Internet'
    DestinationAddressPrefix = '*'
    Access = 'Allow'
    Priority = '2000'
    Direction = 'Inbound'
}
$rule1 = New-AzNetworkSecurityRuleConfig @nsgrule

## Create network security group ##
$nsg = @{
    Name = 'cttlbnsg'
    ResourceGroupName = 'ctt-prod-vnet-rg'
    Location = 'switzerlandnorth'
    SecurityRules = $rule1
}
New-AzNetworkSecurityGroup @nsg

# Set the administrator and password for the VMs. ##
$cred = Get-Credential

## Place the virtual network into a variable. ##
$net = @{
    Name = 'ctt-lb-vnet'
    ResourceGroupName = 'ctt-prod-vnet-rg'
}
$vnet = Get-AzVirtualNetwork @net

## Place the load balancer into a variable. ##
$lb = @{
    Name = 'cttloadbalancer'
    ResourceGroupName = 'ctt-prod-vms-rg'
}
$bepool = Get-AzLoadBalancer @lb  | Get-AzLoadBalancerBackendAddressPoolConfig

## Place the network security group into a variable. ##
$ns = @{
    Name = 'cttlbnsg'
    ResourceGroupName = 'ctt-prod-vnet-rg'
}
$nsg = Get-AzNetworkSecurityGroup @ns

## For loop with variable to create virtual machines for load balancer backend pool. ##
for ($i=1; $i -le 2; $i++){

    ## Command to create network interface for VMs ##
    $nic = @{
        Name = "cttnicvm$i"
        ResourceGroupName = 'ctt-prod-vms-rg'
        Location = 'switzerlandnorth'
        Subnet = $vnet.Subnets[0]
        NetworkSecurityGroup = $nsg
        LoadBalancerBackendAddressPool = $bepool
    }
    $nicVM = New-AzNetworkInterface @nic

    ## Create a virtual machine configuration for VMs ##
    $vmsz = @{
        VMName = "cttvm$i"
        VMSize = 'Standard_DS1_v2'  
    }
    $vmos = @{
        ComputerName = "cttvm$i"
        Credential = $cred
    }
    $vmimage = @{
        PublisherName = 'MicrosoftWindowsServer'
        Offer = 'WindowsServer'
        Skus = '2022-Datacenter'
        Version = 'latest'    
    }
    $vmConfig = New-AzVMConfig @vmsz `
        | Set-AzVMOperatingSystem @vmos -Windows `
        | Set-AzVMSourceImage @vmimage `
        | Add-AzVMNetworkInterface -Id $nicVM.Id

    ## Create the virtual machine for VMs ##
    $vm = @{
        ResourceGroupName = 'ctt-prod-vms-rg'
        Location = 'switzerlandnorth'
        VM = $vmConfig
        Zone = "$i"
    }
    New-AzVM @vm -AsJob
}

## For loop with variable to install custom script extension on virtual machines. ##
for ($i=1; $i -le 2; $i++)
{
$ext = @{
    Publisher = 'Microsoft.Compute'
    ExtensionType = 'CustomScriptExtension'
    ExtensionName = 'IIS'
    ResourceGroupName = 'ctt-prod-vms-rg'
    VMName = "cttvm$i"
    Location = 'switzerlandnorth'
    TypeHandlerVersion = '1.8'
    SettingString = '{"commandToExecute":"powershell Add-WindowsFeature Web-Server; powershell Add-Content -Path \"C:\\inetpub\\wwwroot\\Default.htm\" -Value $($env:computername)"}'
}
Set-AzVMExtension @ext -AsJob
}

$ip = @{
    ResourceGroupName = 'ctt-prod-vms-rg'
    Name = 'ctt-public-pip'
}  
Get-AzPublicIPAddress @ip | Select-Object IpAddress