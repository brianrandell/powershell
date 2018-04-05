<#
.COPYRIGHT
Copyright (c) Brian A. Randell. All rights reserved. Licensed under the MIT license.
See LICENSE in the project root for license information.
#>
param (
    [string]$inputlist = $(throw "-inputlist file name is required.")
 )

function StartVMAndWait($vmToStart)
{
    Start-VM $vmToStart
    do 
    {   
        Start-Sleep -milliseconds 100
    } 
    until 
    (
        (Get-VMIntegrationService $vmToStart | Where-Object {$_.name -eq "Heartbeat"}).PrimaryStatusDescription -eq "OK"
    )
}

$sw = [Diagnostics.Stopwatch]::StartNew()

$vms = Get-Content -Path $inputlist | Sort-Object

foreach ($vm in [array] $vms) 
{
    
    Write-Host "Starting " $vm
    StartVMAndWait($vm)
    Write-Host "Start complete for " $vm
}

$sw.Stop()
Write-Host "Time elapsed: " $sw.Elapsed