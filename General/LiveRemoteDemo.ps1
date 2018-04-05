<#
.COPYRIGHT
Copyright (c) Brian A. Randell. All rights reserved. Licensed under the MIT license.
See LICENSE in the project root for license information.
#>

# Connect using PowerShell Remoting
$c = "MachineName"
$user = "UserName"
Enter-PSSession -ComputerName $c -Credential $user