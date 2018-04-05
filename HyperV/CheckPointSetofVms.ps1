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

$dateString = Get-Date -format "yyyy.MM.dd-HHxmm";
$checkpointName = $checkpointPrefix + " " + $dateString;

$vmNames = Get-Content -Path $inputlist | Sort-Object

foreach ($vmName in [array] $vmNames) 
{
    Checkpoint-VM -Name $vmName -SnapshotName $checkpointName;
}

$sw.Stop();
Write-Host "Time elapsed: " $sw.Elapsed;