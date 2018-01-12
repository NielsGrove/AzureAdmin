<#
.SYNOPSIS
  Provision software package(-s) to node
.DESCRIPTION

.PARAMETER NodeDef
  Name of JSON-file holding the node definition with list of packages and associated parameters
.NOTES
  2018
#>

#Requires -Version 5
Set-StrictMode -Version Latest

Import-Module -Name "$PSScriptRoot\Provision.psm1" -Verbose -Debug


[string]$PackageName = 'jdk180-112.1'  # -> script parameter

[string]$InstallSetPath = 'http://dsl/content/repositories/Installers/Java/'  # -> json
[string]$InstallSetName = 'jdk1.8.0_112-CE.zip'  # -> json
[string]$TempFolder = 'C:\temp\'  # -> json
[string]$MetadataPath = 'F:\PFA_CMDB' # -> json-file


Configuration InstallDsc {
[CmdletBinding()]
Param(
  <#[Parameter(Mandatory=$true, ValueFromPipeLine=$true,HelpMessage='Take your time to write a good help message...')]
  [string]$ZipFileName#>
)

	Import-DscResource –ModuleName 'PSDesiredStateConfiguration'

	Node 'localhost' {
		<# Script DmlFolder {
			SetScript = {}
			TestScript = {}
			GetScript = {}
		} #>

		Archive InstallSetUnzip {
			Ensure = 'Present'
			Path = $TempFolder + $PackageName + '\' + $InstallSetName
			Destination = 'C:\temp'
			Force = $true
		}
	}
}  # InstallDsc


function Invoke-Provision {
<#
.DESCRIPTION
  <Description of the function>
.PARAMETER PackageName
  Name of software installation package.
.OUTPUTS
  (none)
.NOTES
  2018-01-10
#>
[CmdletBinding()]
[OutputType([void])]
Param(
  [Parameter(Mandatory=$true, ValueFromPipeLine=$true,HelpMessage='Take your time to write a good help message...')]
  [string]$PackageName
)

Begin {
  $mywatch = [System.Diagnostics.Stopwatch]::StartNew()
  "{0:s}Z  ::  Invoke-Provision( '$PackageName' )" -f [System.DateTime]::UtcNow | Write-Verbose
}

Process {
    # ToDo : Parse JSON-file given in parameter NodeDef
    $NodeDefinitionFileName = "$PSScriptRoot\$PackageName.json"
    try {
      $NodeDefinition = Get-NodeDefinition -DefinitionFile $NodeDefinitionFileName
    }
    catch {
      throw ("{0:s}Z  Could not get defition file to the package '$NodeDefinitionFileName'." -f [System.DateTime]::UtcNow)
    }

    'Copy install set file from DSL to local folder...' | Write-Verbose
    [string]$InstallSetSource = $InstallSetPath + $InstallSetName
    "Install Set (source) = '$InstallSetSource'" | Write-Verbose
    if (-not (Test-Path ($TempFolder + $PackageName))) {
      New-Item -Path $TempFolder -Name $PackageName -ItemType directory
    }
    [string]$InstallSetDestination = $TempFolder + $PackageName + '\' + $InstallSetName
    "Install Set (destination) = '$InstallSetDestination'" | Write-Verbose
    Get-InstallSet -SourceFile $InstallSetSource -DestinationFile $InstallSetDestination

    Set-Location $PSScriptRoot

    "Compile to MOF file..." | Write-Verbose
    $MofFile = InstallDsc

    'Apply DSC-configuration...' | Write-Verbose
    try {
      Start-DscConfiguration -Path "$PSScriptRoot\InstallDsc" -Wait -Force -Verbose $false
    }
    catch {
      $Error | Write-Error
      throw ("{0:s}Z  DSC configuration failed. DSC MOF file = '.\InstallDsc'. Check DSC log." -f [System.DateTime]::UtcNow)
    }

    # Delete local Install Set ZIP-file - delete in DSC fails as the file is in use...
    # ToDo : Test for file in use
    Start-Sleep -Seconds 5
    Remove-Item -LiteralPath $InstallSetDestination

    # Create local metadata
    Set-Metadata -LocalPath '(TBD)'
}

End {
  $mywatch.Stop()
  [string]$Message = "InvokeProvision finished with success. Duration = $($mywatch.Elapsed.ToString()). [hh:mm:ss.ddd]"
  "{0:s}Z  $Message" -f [System.DateTime]::UtcNow | Write-Output
}
}  # Invoke-Provision()


###  INVOKE  ###
Invoke-Provision -PackageName $PackageName -Verbose #-Debug

Remove-Module -Name Provision -Verbose -Debug
