<#
.COPYRIGHT
Copyright (c) Brian A. Randell. All rights reserved. Licensed under the MIT license.
See LICENSE in the project root for license information.
#>

param (
    [string]$inputlist = $(throw "-inputlist file name is required."),
    [string]$checkpointPrefix = $(throw "-checkpointPrefix name is required.")
 )

$sw = [Diagnostics.Stopwatch]::StartNew();

$vmNames = Get-Content -Path $inputlist | Sort-Object

foreach ($vmName in [array] $vmNames) 
{
    $cps = Get-VMSnapshot -VMName $vmName
    $cpRemoved = $false;
    
    Write-Host "Locating checkpoints for:" $vmName;

    foreach ($cp in [array] $cps)
    {
        $cpName = $cp.Name;

        if ($cpRemoved)
        {
            break;
        }

        $cpfound = $false;
        if ($cpName.StartsWith($checkpointPrefix))
        {
            Write-Host "  Checkpoint found for:" $vmName;
            $cpfound = $true;
        }
        if ($cpfound)
        {
            Remove-VMSnapshot -VMName $vmName -Name $cp.Name -IncludeAllChildSnapshots -Confirm:$false;
            Write-Host "    Removed " $cpName;
            $cpRemoved = $true;
            break;
        }
        else
        {
            Write-Host "  Checkpoint located does not match prefix:" $cpName;
        }
    }
}


$sw.Stop();
Write-Host "Time elapsed: " $sw.Elapsed;