<#
.COPYRIGHT
Copyright (c) Brian A. Randell. All rights reserved. Licensed under the MIT license.
See LICENSE in the project root for license information.
#>

Get-VM | Where-Object {$_.MemoryDemand -gt 0} | Select-Object Name, CPUUsage, ProcessorCount, MemoryStartup, MemoryDemand | Format-Table -Autosize Name, CPUUsage, ProcessorCount, @{n="Memory (MB)";e={"{0:N0}" -f ($_.MemoryStartup / 1Mb)}; Alignment="right" }, @{n="Demand (MB)";e={"{0:N0}" -f ($_.MemoryDemand / 1Mb)}; Alignment="right" };

Get-VM | Where-Object {$_.MemoryDemand -gt 0} | Measure-Object -Sum MemoryStartup, MemoryDemand | Format-Table -AutoSize Property, Count, @{n="Memory (MB)";e={"{0:N0}" -f ($_.Sum/ 1Mb)}; Alignment="right" }