<#
.SYNOPSIS
  Module for software provisioning script.
.DESCRIPTION
  PowerShell module for software provisioning script (Provision.ps1)
.EXAMPLE
  Import-Module $PSScriptRoot\Provision.psm1
.NOTES
  2018
#>

#region NodeDefinition

function Get-NodeDefinition {
<#
.DESCRIPTION
  Parse node definition file (json) and get node definition
.PARAMETER DefinitionFile
  JSON-file holding node definition with local file name, e.g. "jdk180-666.42.json"
.OUTPUTS
  Custom object (PSObject) with node definition in key-value pairs
.LINK
  <link to external reference or documentation>
.NOTES
  <timestamp> <version>  <initials> <version changes and description>
#>
[CmdletBinding()]
[OutputType([void])]
Param(
  [Parameter(Mandatory=$true, ValueFromPipeLine=$true,HelpMessage='Take your time to write a good help message...')]
  [string]$DefninitionFile
)

Begin {
  $mywatch = [System.Diagnostics.Stopwatch]::StartNew()
  "{0:s}Z  ::  Get-NodeDefinition( '$DefinitionFile' )" -f [System.DateTime]::UtcNow | Write-Verbose
}

Process {
	$NodeDefinition = (Get-Content $DefninitionFile) -join "`n" | ConvertFrom-Json
}

End {
  $mywatch.Stop()
  [string]$Message = "Get-NodeDefinition finished with success. Duration = $($mywatch.Elapsed.ToString()). [hh:mm:ss.ddd]"
  "{0:s}Z  $Message" -f [System.DateTime]::UtcNow | Write-Output
}
}  # Get-NodeDefinition()

#endregion NodeDefition


#region InstallSet

function Get-InstallSet {
<#
.DESCRIPTION
  Get installation set from DSL over HTTP.
.PARAMETER SourceFile
  Source file name with full path
.PARAMETER DestinationFile
	Destination file name with full local path
.LINK
  <link to external reference or documentation>
.NOTES
  2018-01-10
#>
[CmdletBinding()]
[OutputType([void])]
Param(
  [Parameter(Mandatory=$true, ValueFromPipeLine=$false,HelpMessage='Take your time to write a good help message...')]
  [string]$SourceFile,

  [Parameter(Mandatory=$true, ValueFromPipeLine=$false,HelpMessage='Take your time to write a good help message...')]
  [string]$DestinationFile
)

Begin {
  $mywatch = [System.Diagnostics.Stopwatch]::StartNew()
  "{0:s}Z  ::  Get-InstallationSet()" -f [System.DateTime]::UtcNow | Write-Verbose
}

Process {
	#Invoke-WebRequest -Uri 'http://dsl/...' -OutFile 'C:\temp\...'

	Start-BitsTransfer -Source $SourceFile -Destination $DestinationFile
}

End {
  $mywatch.Stop()
  [string]$Message = "Get-InstallationSet finished with success. Duration = $($mywatch.Elapsed.ToString()). [hh:mm:ss.ddd]"
  "{0:s}Z  $Message" -f [System.DateTime]::UtcNow | Write-Output
}
}  # Get-InstallSet()

#endregion InstallSet


#region Metadata

function Set-Metadata {
<#
.DESCRIPTION
  <Description of the function>
.PARAMETER LocalPath
  Local path for metadata, e.g. "F:\PFA_CMDB"
.OUTPUTS
  (none)
.NOTES
  2018-01-10
#>
[CmdletBinding()]
[OutputType([void])]
Param(
  [Parameter(Mandatory=$true, ValueFromPipeLine=$true,HelpMessage='Take your time to write a good help message...')]
  [string]$LocalPath
)

Begin {
  $mywatch = [System.Diagnostics.Stopwatch]::StartNew()
  "{0:s}Z  ::  Set-Metadata( '$LocalPath' )" -f [System.DateTime]::UtcNow | Write-Verbose
}

Process {
<# Create node metadata and write on node
  Create folder
	Create share
	  (-) everyone
		(+) Authenticated Users: Read
	Create file
#>
}

End {
  $mywatch.Stop()
  [string]$Message = "Set-Metadata finished with success. Duration = $($mywatch.Elapsed.ToString()). [hh:mm:ss.ddd]"
  "{0:s}Z  $Message" -f [System.DateTime]::UtcNow | Write-Output
}
}  # Set-Metadata()

#endregion Metadata


Export-ModuleMember -Function Get-NodeDefinition, Get-InstallSet, Set-Metadata
