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
#Import-Module -Name ".\Provision.psm1" -Verbose


[string]$PackageName = 'jdk180-112.1'  # -> script parameter

[string]$InstallSetSource = 'http://dsl/content/repositories/Installers/Java/jdk1.8.0_112-CE.zip'  # -> json file
[string]$PackageFolder = 'C:\temp\jdk180-112.1'  # -> json
[string]$InstallSetDestination = 'C:\temp\jdk180-112.1\jdk1.8.0_112-CE.zip'  # -> json file
[string]$MetadataPath = 'F:\PFA_CMDB' # -> json-file

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

    # Copy file from DSL to local folder
    Get-InstallSet -SourceFile $InstallSetSource -DestinationFile $InstallSetDestination

    Set-Location $PSScriptRoot

    # Compile to MOF file
    [string]$DscFileName = "$PSScriptRoot\$PackageName.ps1"
    "DSC File = '$DscFileName'" | Write-Verbose
    . .\jdk180-112.1.ps1 -MetadataPath

    # Apply DSC-configuration
    try {
      Start-DscConfiguration -Path '.\JavaDsc' -Wait -Force -Verbose $false
    }
    catch {
      throw ("{0:s}Z  DSC configuration failed. DSC file = '$DscFileName'. Check DSC log." -f [System.DateTime]::UtcNow)
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
