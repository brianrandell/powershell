<#
.COPYRIGHT
Copyright (c) Brian A. Randell. All rights reserved. Licensed under the MIT license.
See LICENSE in the project root for license information.
#>

param (
    [string]$rootPath = $(throw "-rootPath file name is required.")
)

$sw = [Diagnostics.Stopwatch]::StartNew()

$files = Get-ChildItem -Path $rootPath -Include *.vmcx -File -Recurse
foreach ($f in [array] $files) {
    Write-Host "Importing: " $f.Fullname;
    Import-VM -Path $f.FullName;
    Write-Host "Import done";
}

$sw.Stop()
Write-Host "Time elapsed:" $sw.Elapsed