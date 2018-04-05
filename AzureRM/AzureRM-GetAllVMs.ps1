<#
.COPYRIGHT
Copyright (c) Brian A. Randell. All rights reserved. Licensed under the MIT license.
See LICENSE in the project root for license information.
#>

# AzureRM-GetAllVMs
Get-AzureRmContext

$subs = Get-AzureRmSubscription

$vmarrayx = @()

foreach ($sub in $subs)
 {
    Set-AzureRmContext -Subscription $sub.Name
    
    # Get all of the VM's: 
    $rmvms=Get-AzureRmVM 
    # $smvms=Get-AzureVM

    # $vmarray = @()
    # foreach ($vm in $smvms) 
    # { 
    #     $vmarray += New-Object PSObject -Property @{`
    #         Subscription=$sub.Name;`
    #         AzureMode="Service_Manager";`
    #         Name=$vm.InstanceName;`
    #         PowerState=$vm.PowerState;`
    #         Size=$vm.InstanceSize} 
    # }

    # $vmarray | Format-Table

    foreach ($vm in $rmvms) 
    {     
        # Get status (does not seem to be a property of $vm, so need to call Get-AzurevmVM for each rmVM) 
        $vmstatus = Get-AzurermVM -Name $vm.Name -ResourceGroupName $vm.ResourceGroupName -Status  

        # Add values to the array: 
        $vmarrayx += New-Object PSObject -Property @{`
            Subscription=$sub.Name;`
            AzureMode="Resource_Manager";`
            Name=$vm.Name;`
            PowerState=(get-culture).TextInfo.ToTitleCase(($vmstatus.statuses)[1].code.split("/")[1]);`
            Size=$vm.HardwareProfile.VmSize} 
    }
    
  
 }

 $vmarrayx | Format-Table