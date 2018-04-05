<#
.COPYRIGHT
Copyright (c) Brian A. Randell. All rights reserved. Licensed under the MIT license.
See LICENSE in the project root for license information.
#>

$sw = [Diagnostics.Stopwatch]::StartNew()

$vms = Get-VM

# A Directory
$exportDir =  "D:\ExportDir"
# A single VM to Skip
$skipVM = "XW7"

foreach ($vm in [array] $vms) 
{
    if ($vm.Name -eq $skipVM)
    {
        Write-Host "Skipping VM " $vm.Name
    }
    else
    {
        $vhds = $vm | Get-VMHardDiskDrive | Where-Object { !$_.Path.EndsWith(".avhd") -and !$_.Path.EndsWith(".avhdx") } | get-vhd | Sort-Object path | Select-Object
     
        foreach ($vhd in [array] $vhds) 
        {
            Write-Host "VHD:" $vhd.Path
        }

        $swInner = [Diagnostics.Stopwatch]::StartNew()

        Write-Host "Exporting " $vm.Name
        Export-VM -Name $vm.Name -Path $exportDir

        $swInner.Stop()
        Write-Host "Export done of" $vm.Name "in" $swInner.Elapsed
    }
}

$sw.Stop()
Write-Host "Total Time elapsed: " $sw.Elapsed