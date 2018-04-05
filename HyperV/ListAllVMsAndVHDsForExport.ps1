<#
.COPYRIGHT
Copyright (c) Brian A. Randell. All rights reserved. Licensed under the MIT license.
See LICENSE in the project root for license information.
#>

$sw = [Diagnostics.Stopwatch]::StartNew();

$lastWriteDate = '2018-04-01'

Write-Output "Working ..."
$vms = Get-VM;

foreach ($vm in [array] $vms) 
{
        $vhds = $vm | Get-VMHardDiskDrive | get-vhd | Sort-Object path | Select-Object;

        $fwrite = $false;

        foreach ($vhd in [array] $vhds) 
        {
            $fi = Get-Item $vhd.Path;
            
            if ($fi.LastWriteTime -ge (get-date $lastWriteDate))
            {
                $fwrite = $true;
            }
        }
        
        if ($fwrite)
        {
            Write-Output $vm.Name;
        }
}

$sw.Stop();
Write-Output "Total Time elapsed: " $sw.Elapsed.TotalMilliseconds;