<#
.COPYRIGHT
Copyright (c) Brian A. Randell. All rights reserved. Licensed under the MIT license.
See LICENSE in the project root for license information.
#>

# CREATE A RESOURCE GROUP
$rgName = 'yournamehere';
$rgLoc = 'West US 2';

New-AzureRmResourceGroup -Name $rgName -Location $rgLoc;