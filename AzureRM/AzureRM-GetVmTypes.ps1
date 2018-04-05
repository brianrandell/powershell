<#
.COPYRIGHT
Copyright (c) Brian A. Randell. All rights reserved. Licensed under the MIT license.
See LICENSE in the project root for license information.
#>

# FIND VALID VM LOCATIONS AND TYPES FOR SUBSCRIPTION
# Get Vm Resource Provider
$resources = Get-AzureRmResourceProvider -ProviderNamespace Microsoft.Compute;
# List Valid Locations
$resources.ResourceTypes.Where{($_.ResourceTypeName -eq 'virtualMachines')}.Locations;
# Get List of Vms in a specific Region
$vmLoc = 'West US 2';
Get-AzureRmVmSize -Location $vmLoc | Sort-Object Name | Format-Table Name, NumberOfCores, MemoryInMB, MaxDataDiskCount -AutoSize;