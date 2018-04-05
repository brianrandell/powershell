<#
.COPYRIGHT
Copyright (c) Brian A. Randell. All rights reserved. Licensed under the MIT license.
See LICENSE in the project root for license information.
#>

param (
    [string]$inputlist = $(throw "-inputlist file name is required.")
 )

function StopVMAndWait($vmToStop)
{
    Stop-VM $vmToStop
    do 
    {
        Start-Sleep -milliseconds 100
    } 
    until ((Get-VM $vmToStop | Where-Object state -eq 'off'))
}

$sw = [Diagnostics.Stopwatch]::StartNew()

$vms = Get-Content -Path $inputlist | Sort-Object -Descending

foreach ($vm in [array] $vms) 
{
    
    Write-Host "Stopping " $vm
    StopVMAndWait($vm)
    Write-Host "Stop complete for " $vm
}

$sw.Stop()

Write-Host "Time elapsed: " $sw.Elapsed