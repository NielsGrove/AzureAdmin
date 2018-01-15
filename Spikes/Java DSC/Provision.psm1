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
  [string]$DefinitionFile
)

Begin {
  $mywatch = [System.Diagnostics.Stopwatch]::StartNew()
  "{0:s}Z  ::  Get-NodeDefinition( '$DefinitionFile' )" -f [System.DateTime]::UtcNow | Write-Verbose
}

Process {
	return $null

	if (Test-Path -LiteralPath '$DefinitionFile') {
		$script:NodeDefinition = (Get-Content $DefinitionFile) -join "`n" | ConvertFrom-Json
	}
	else {
		throw ("{0:s}Z  The node definition file '$DefinitionFile' does not exist." -f [System.DateTime]::UtcNow)
	}
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

function Test-FileInUse {
<#
.DESCRIPTION
  <Description of the function>
.PARAMETER <Name>
  <parameter description>
.OUTPUTS
  (none)
.RETURNVALUE
  (none)
.LINK
  <link to external reference or documentation>
.NOTES
  <timestamp> <version>  <initials> <version changes and description>
#>
[CmdletBinding()]
[OutputType([bool])]
Param(
  [Parameter(Mandatory=$true, ValueFromPipeLine=$true,HelpMessage='Take your time to write a good help message...')]
  [string]$LiteralPath
)

Begin {
  $mywatch = [System.Diagnostics.Stopwatch]::StartNew()
  "{0:s}Z  ::  Test-FileInUse( '$LiteralPath' )" -f [System.DateTime]::UtcNow | Write-Verbose
}

Process {
}

End {
  $mywatch.Stop()
  [string]$Message = "Test-FileInUse finished with success. Duration = $($mywatch.Elapsed.ToString()). [hh:mm:ss.ddd]"
  "{0:s}Z  $Message" -f [System.DateTime]::UtcNow | Write-Output
}
}  # Test-FileInUse()

#endregion InstallSet


#region Configuration

function Get-DscConfigurationData {
<#
.DESCRIPTION
  <Description of the function>
.PARAMETER <Name>
  <parameter description>
.OUTPUTS
  (none)
.RETURNVALUE
  (none)
.LINK
  <link to external reference or documentation>
.NOTES
  <timestamp> <version>  <initials> <version changes and description>
#>
[CmdletBinding()]
[OutputType([void])]
Param(
  <#[Parameter(Mandatory=$true, ValueFromPipeLine=$true,HelpMessage='Take your time to write a good help message...')]
  [string]$param1#>
)

Begin {
  $mywatch = [System.Diagnostics.Stopwatch]::StartNew()
  "{0:s}Z  ::  Get-DscConfigurationData()" -f [System.DateTime]::UtcNow | Write-Verbose
}

Process {
	$ConfigurationData = 
	@{
    AllNodes = @(
      @{
			      NodeName = '*'
			},
			@{
            NodeName = 'localhost'
				    DmlFolder = 'C:\temp\jdk180-112.1\'
            DestinationPath = 'C:\temp\'
        }
    );

    NonNodeData = ""
	}

	return $ConfigurationData
}

End {
  $mywatch.Stop()
  [string]$Message = "Get-DscConfigurationData finished with success. Duration = $($mywatch.Elapsed.ToString()). [hh:mm:ss.ddd]"
  "{0:s}Z  $Message" -f [System.DateTime]::UtcNow | Write-Output
}
}  # Get-DscConfigurationData()

#endregion Configuration


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


Export-ModuleMember -Function Get-NodeDefinition, Get-InstallSet, Get-DscConfigurationData, Set-Metadata
