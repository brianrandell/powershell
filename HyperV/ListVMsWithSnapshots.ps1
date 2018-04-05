<#
.COPYRIGHT
Copyright (c) Brian A. Randell. All rights reserved. Licensed under the MIT license.
See LICENSE in the project root for license information.
#>

$sw = [Diagnostics.Stopwatch]::StartNew();

$vms = Get-VM

foreach ($vm in [array] $vms) 
{
    $vmName = $vm.Name
    $cps = Get-VMSnapshot -VMName $vmName
    

    $sscount = 0
    foreach ($cp in [array] $cps)
    {
        $sscount++
    }
    if ($sscount -gt 0)
    {
        Write-Output $vmName
    }
}

$sw.Stop();
$et = $sw.Elapsed
Write-Output "Time elapsed: $et"