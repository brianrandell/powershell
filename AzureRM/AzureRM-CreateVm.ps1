<#
.COPYRIGHT
Copyright (c) Brian A. Randell. All rights reserved. Licensed under the MIT license.
See LICENSE in the project root for license information.
#>

### GETTING CONNECTED
## GET AZURE POWERSHELL (RUN AS ADMINISTRATOR)
# By default, this command will warn of untrusted repo.
# Must accept gallery warning to continue
Install-Module AzureRM -AllowClobber;
Import-Module AzureRM;
# See https://aka.ms/instazpowershelldocs for more details

## LOGIN
Login-AzureRmAccount;

## POWERSHELL IN THE BROWSER
https://portal.azure.com

### CREATING A VM
## FIND VALID VM LOCATIONS AND TYPES FOR SUBSCRIPTION
# Get Vm Resource Provider and List Valid Locations
$resources = Get-AzureRmResourceProvider -ProviderNamespace Microsoft.Compute;
$resources.ResourceTypes.Where{($_.ResourceTypeName -eq 'virtualMachines')}.Locations;
# Get List of Vms in a specific Region
$vmLoc = 'West US 2';
Get-AzureRmVmSize -Location $vmLoc | Sort-Object Name | Format-Table Name, NumberOfCores, MemoryInMB, MaxDataDiskCount -AutoSize;

## CREATE A RESOURCE GROUP
$rgName = 'yournamehere';
$rgLoc = 'West US 2';

New-AzureRmResourceGroup -Name $rgName -Location $rgLoc;

## BUILD OBJECTS FOR A VM
# Resource Group Variables (script assumes you've crated the group)
$rgName = 'yournamehere';
$rgLoc = 'West US 2';

# Define Subnet
$subnetName = "PSRsn";
$subnetCfg = New-AzureRmVirtualNetworkSubnetConfig -Name $subnetName -AddressPrefix 192.168.1.0/24;

# Define Virtual Network
$vNetName = 'PSRvNet';
$vNet = New-AzureRmVirtualNetwork -ResourceGroupName $rgName -Location $rgLoc -Name $vNetName -AddressPrefix 192.168.0.0/16 -Subnet $subnetCfg;

# Get a public IP address and define a DNS name
$vmDns = "yourvmname$(Get-Random)";
$pip = New-AzureRmPublicIpAddress -ResourceGroupName $rgName -Location $rgLoc -AllocationMethod Static -IdleTimeoutInMinutes 4 -Name $vmDns;

# Define an inbound network security group rule for port 3389 (Remote Desktop)
$nsgRuleName = 'PSRnsrRDP';
$nsgRuleRDP = New-AzureRmNetworkSecurityRuleConfig -Name $nsgRuleName -Protocol Tcp -Direction Inbound -Priority 1000 -SourceAddressPrefix * -SourcePortRange * -DestinationAddressPrefix * -DestinationPortRange 3389 -Access Allow;

# Define a network security group
$nsgName = 'PSRnsg';
$nsg = New-AzureRmNetworkSecurityGroup -ResourceGroupName $rgName -Location $rgLoc -Name $nsgName -SecurityRules $nsgRuleRDP;

# Define a virtual network card and link it with the already created public IP address and NSG
$nicName = 'PSRnic';
$nic = New-AzureRmNetworkInterface -Name $nicName -ResourceGroupName $rgName -Location $rgLoc -SubnetId $vnet.Subnets[0].Id -PublicIpAddressId $pip.Id -NetworkSecurityGroupId $nsg.Id;

# Define a virtual machine configuration
$vmName = 'yourvmname';
$computerName = 'yourcomputername';
# Make sure you use a valid size for your subscription & location
$vmSize = 'Standard_D2_v2';

# Define a credential object 
# (this will prompt you for a user name and password)
$cred = Get-Credential;

# Define Vm Configuration
$vmConfig = New-AzureRmVMConfig -VMName $vmName -VMSize $vmSize | `
Set-AzureRmVMOperatingSystem -Windows -ComputerName $computerName -Credential $cred | `
Set-AzureRmVMSourceImage -PublisherName MicrosoftWindowsServer -Offer WindowsServer `
-Skus 2016-Datacenter -Version latest | Add-AzureRmVMNetworkInterface -Id $nic.Id;

# Create the Vm; the Vm will be started when done
New-AzureRmVM -ResourceGroupName $rgName -Location $rgLoc -VM $vmConfig;

## STOP A VM
# Assumes you’ve created a VM
$rgName = 'yournamehere';
$vmName = 'yourvmname';
Stop-AzureRmVM -ResourceGroupName $rgName -Name $vmName;

## START A VM
# Assumes you’ve created a VM
$rgName = 'yournamehere';
$vmName = 'yourvmname';
Start-AzureRmVM -ResourceGroupName $rgName -Name $vmName;