<#
.COPYRIGHT
Copyright (c) Brian A. Randell. All rights reserved. Licensed under the MIT license.
See LICENSE in the project root for license information.
#>

Login-AzureRmAccount;

## Set Variables
# You must fix all of these variables
# Get-AzureRMLocation will get you the valid $rgLoc and $dnsLoc values for your sub
$rgName = 'resourceGroupName';
$rgLoc = 'East US 2';
$pre = 'abc';
$vmName = 'vmname';
$osDiskVhdUri = 'https://account.blob.core.windows.net/folder/vm.vhd';
$vmDns = "vmdnsname";
$dnsLoc = 'eastus2';

# You must create the diagnostics storage account before running the script. 
# If you want it in the same resource group, you would need to add:
# New-AzureRmStorageAccount -ResourceGroupName $rgName -Name $diagStorRgName -Location $rgLoc -SkuName Standard_LRS -Kind StorageV1
# And modify this line:
# Set-AzureRmVMBootDiagnostics -VM $vmConfig -Enable -ResourceGroupName $rgName -StorageAccountName $diagStorageAccountName;
$diagStorRgName = "storageAccountName resourceGroupName"
$diagStorageAccountName = 'storageAccountName';

# Make sure you use a valid size for your subscription & location
# Use Get-AzureRmVMSize -Location $rgLoc
$vmSize = 'Standard_E4s_v3';

# Start Script
# Use Test-AzureRmDnsAvailability to check Dns Name
$goodDns = Test-AzureRmDnsAvailability -DomainNameLabel $vmDns -Location $dnsLoc;

if ($goodDns -ne $true) {
    Write-Error -Message 'DNS Name is bad';    
}
else {
    Write-Output 'DNS Name is good, creating VM';    
    
    # Create Resource Group
    New-AzureRmResourceGroup -Name $rgName -Location $rgLoc;

    ## Create Network Objects
    # Define Subnet
    $subnetName = $pre + 'sn';
    $subnetCfg = New-AzureRmVirtualNetworkSubnetConfig -Name $subnetName -AddressPrefix 192.168.1.0/24;

    # Define Virtual Network
    $vNetName = $pre + 'vNet';
    $vNet = New-AzureRmVirtualNetwork -ResourceGroupName $rgName -Location $rgLoc -Name $vNetName -AddressPrefix 192.168.0.0/16 -Subnet $subnetCfg;

    # Get a public IP address and define a DNS name
    $pipName = $pre + 'pip';
    $pip = New-AzureRmPublicIpAddress -Name $pipName -ResourceGroupName $rgName -Location $rgLoc -DomainNameLabel $vmDns -AllocationMethod Static -IdleTimeoutInMinutes 4 

    # Define an inbound network security group rule for port 3389 (Remote Desktop)
    $nsgRuleName = $pre + 'nsrRDP';
    $nsgRuleRDP = New-AzureRmNetworkSecurityRuleConfig -Name $nsgRuleName -Protocol Tcp -Direction Inbound -Priority 1000 -SourceAddressPrefix * -SourcePortRange * -DestinationAddressPrefix * -DestinationPortRange 3389 -Access Allow;

    # Define a network security group
    $nsgName = $pre + 'nsg';
    $nsg = New-AzureRmNetworkSecurityGroup -ResourceGroupName $rgName -Location $rgLoc -Name $nsgName -SecurityRules $nsgRuleRDP;

    # Define a virtual network card and link it with the already created public IP address and NSG
    $nicName = $pre + 'nic';
    $nic = New-AzureRmNetworkInterface -Name $nicName -ResourceGroupName $rgName -Location $rgLoc -SubnetId $vnet.Subnets[0].Id -PublicIpAddressId $pip.Id -NetworkSecurityGroupId $nsg.Id;

    # Define a virtual machine configuration
    
    # Configure Disk
    $osDiskName = $vmname + '_osDisk';
    $osDiskCaching = 'ReadWrite';

    # Define Vm Configuration
    $vmConfig = New-AzureRmVMConfig -VMName $vmName -VMSize $vmSize | Add-AzureRmVMNetworkInterface -Id $nic.Id;
    $vmConfig = Set-AzureRmVMOSDisk -VM $vmConfig -VhdUri $osDiskVhdUri -name $osDiskName -CreateOption attach -Windows -Caching $osDiskCaching;

    Set-AzureRmVMBootDiagnostics -VM $vmConfig -Enable -ResourceGroupName $diagStorRgName -StorageAccountName $diagStorageAccountName;

    # Create the Vm; the Vm will be started when done
    $userName = 'Brian'
    $purpose = "Workshop Testing"
    New-AzureRmVM -ResourceGroupName $rgName -Location $rgLoc -VM $vmConfig -Tags @{ User=$userName; Purpose=$purpose};
}