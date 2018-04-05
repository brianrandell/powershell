<#
.COPYRIGHT
Copyright (c) Brian A. Randell. All rights reserved. Licensed under the MIT license.
See LICENSE in the project root for license information.
#>

param (
    [string]$exportDir = $(throw "-exportDir directory path is required."),
    [string]$inputlist = $(throw "-inputlist file name is required.")
 )

$sw = [Diagnostics.Stopwatch]::StartNew()

$vms = Get-Content -Path $inputlist

foreach ($vm in [array] $vms) 
{
    
    Write-Host "Exporting " $vm
    Export-VM -Name $vm -Path $exportDir
    Write-Host "Export done of " $vm
}

$sw.Stop()
Write-Host "Time elapsed: " $sw.Elapsed