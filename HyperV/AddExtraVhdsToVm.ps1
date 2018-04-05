<#
.COPYRIGHT
Copyright (c) Brian A. Randell. All rights reserved. Licensed under the MIT license.
See LICENSE in the project root for license information.
#>

$srvName = "A Valid VMName"

$hddRoot = "\Virtual Hard Disks\"
$dataVhdxSizeInGb = 64GB
# Use the following line of code to figure out the controller ID you want to use
# Get-VMScsiController -VMName $srvName
$controllerID = 3

$vm = Get-VM -Name $srvName

$driveCount = 4

for ($i = 1; $i -le $driveCount; $i++)
{
    $vhdSuffix = "-what you want-" + $i.ToString("00") + ".vhdx"
    $vhdsPath = Join-Path -Path $vm.Path -ChildPath $hddRoot
    $vhdxDataFileName = $srvName + $vhdSuffix
    $vhdxDataFilePath = Join-Path -Path $vhdsPath -ChildPath $vhdxDataFileName
    
    Write-Output "Creating: " $vhdxDataFilePath
        $vhdxDataFile = New-VHD -Path $vhdxDataFilePath -Fixed -SizeBytes $dataVhdxSizeInGb
    Write-Output "Done creating: " $vhdxDataFilePath
    
    Add-VMHardDiskDrive -VM $vm -Path $vhdxDataFile.Path -ControllerNumber $controllerID
    Write-Output "Done Adding: " $vhdxDataFilePath
}