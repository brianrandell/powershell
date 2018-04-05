<#
.COPYRIGHT
Copyright (c) Brian A. Randell. All rights reserved. Licensed under the MIT license.
See LICENSE in the project root for license information.
#>

# Find Excel Files in my Dropbox
$root = 'C:\Dropbox\*.*'
$filter = '*.xl*'

# Assumes MM/DD/YY date format
$startDate = '1/20/18'
$endDate = '11/27/15'

Get-ChildItem -Path $root -Filter $filter -Recurse |
    Where-Object {
        $_.lastwritetime -gt $startDate -AND $_.lastwritetime -lt $endDate
    }