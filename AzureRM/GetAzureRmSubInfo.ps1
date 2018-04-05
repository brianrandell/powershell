<#
.COPYRIGHT
Copyright (c) Brian A. Randell. All rights reserved. Licensed under the MIT license.
See LICENSE in the project root for license information.
#>

$sw = [Diagnostics.Stopwatch]::StartNew()

Login-AzureRmAccount

Get-AzureRmContext

Get-AzureRmSubscription | Format-Table Name, Id

Set-AzureRmContext -Subscription "A valid sub name"

$sw.Stop()
Write-Host "Time elapsed: " $sw.Elapsed