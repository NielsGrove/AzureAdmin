<#
.DESCRIPTION
  Deployment of AzureAdmin.net web site.
  Only changed files will be deployed.
.PARAMETER <Parameter Name>
  (none)
.INPUTS
  (none)
.OUTPUTS
  (none)
.RETURNVALUE
  (none)
.EXAMPLE

.NOTES
  Filename  : Deploy.AzureAdmin.ps1
.NOTES
  2017-09-13 (NieGro) Deployment file for AzureAdmin.net created.

.LINK
  TechNet Library: about_Functions_Advanced
  https://technet.microsoft.com/en-us/library/dd315326.aspx
#>

#Requires -Version 5
Set-StrictMode -Version Latest

# (TBD)
#Import-Module G:\Teknik\Script\Sandbox\Module.sandbox\Module.sandbox.psm1


#region Deploy

function Install-AzureAdmin {
<#
.DESCRIPTION
  Install (deploy) latest master branch version of AzureAdmin web site to current ISP.
.PARAMETER <Name>
  (none)
.OUTPUTS
  (none)
.RETURNVALUE
  (none)
.LINK
  (none)
.NOTES
  2017-09-13 (NieGro) Deployment file created.
#>
[CmdletBinding()]
[OutputType([void])]
Param(
<#
  [Parameter(Mandatory=$true, ValueFromPipeLine=$true,HelpMessage='Take your time to write a good help message...')]
  [string]$param1
#>
)

Begin {
  $mywatch = [System.Diagnostics.Stopwatch]::StartNew()
  "{0:s}Z  ::  Install-AzureAdmin()" -f [System.DateTime]::UtcNow | Write-Verbose
}

Process {
  Install-AzureAdminNet #-param1 (TBD)
}

End {
  $mywatch.Stop()
  [string]$Message = "Install-AzureAdmin finished with success. Duration = $($mywatch.Elapsed.ToString()). [hh:mm:ss.ddd]"
  "{0:s}Z  $Message" -f [System.DateTime]::UtcNow | Write-Output
}
}  # Install-AzureAdmin()


function Install-AzureAdminNet {
<#
.DESCRIPTION
  Install (deploy) latest master branch version of AzureAdmin.net to current ISP.
.PARAMETER <Name>
  (none)
.OUTPUTS
  (none)
.RETURNVALUE
  (none)
.LINK
  (none)
.NOTES
  2017-09-13 (NieGro) Deployment file created.
#>
[CmdletBinding()]
[OutputType([void])]
Param(
<#
  [Parameter(Mandatory=$true, ValueFromPipeLine=$true,HelpMessage='Take your time to write a good help message...')]
  [string]$param1
#>
)

Begin {
  $mywatch = [System.Diagnostics.Stopwatch]::StartNew()
  "{0:s}Z  ::  InstallAzureAdminNet()" -f [System.DateTime]::UtcNow | Write-Verbose
}

Process {
  "Get file info from ISP..." | Write-Verbose

  "Get file info from repository..." | Write-Verbose

  "Compare file info on ISP with repository..." | Write-Verbose

  "Get new files form repository..." | Write-Verbose

  "Copy new files from repository to ISP..." | Write-Verbose
}

End {
  $mywatch.Stop()
  [string]$Message = "Install-AzureAdminNet finished with success. Duration = $($mywatch.Elapsed.ToString()). [hh:mm:ss.ddd]"
  "{0:s}Z  $Message" -f [System.DateTime]::UtcNow | Write-Output
}
}  # Install-AzureAdminNet()

#endregion Deploy


###  INVOKE  ###

Clear-Host
#<function call> -Verbose -Debug