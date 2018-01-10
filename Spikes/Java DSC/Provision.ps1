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

Import-Module -Name "$PSScriptRoot\Provision.psm1" -Verbose

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
  "{0:s}Z  ::  Invoke-Provision( 'PackageName' )" -f [System.DateTime]::UtcNow | Write-Verbose
}

Process {
    # ToDo : Parse JSON-file given in parameter NodeDef
    $NodeDefinitionFileName = "$PackageName.json"
    Get-NodeDefinition -DefinitionFile $NodeDefinitionFileName

    # Copy file from DSL to local folder
    [string]$InstallSetSource = 'http://dsl/content/repositories/Installers/Java/jdk1.8.0_112-CE.zip'  # -> json file
    [string]$InstallSetDestination = 'C:\temp\jdk180-112.1\jdk1.8.0_112-CE.zip'  # -> json file
    Get-InstallSet -SourceFile $InstallSetSource -DestinationFile $InstallSetDestination

    if ($PSScriptRoot) {
      Set-Location $PSScriptRoot
    } else {
      Set-Location 'C:\NgrAdmin\GitHub\AzureAdmin\Spikes\Java DSC'
    }
    Get-Location | Write-Verbose

    # Compile to MOF file
    [string]$DscFile = ".\$PackageName.ps1"
    "DSC File = '$DscFile'" | Write-Verbose
    . .\jdk180-112.1.ps1

    # Apply DSC-configuration
    try {
      Start-DscConfiguration -Path '.\JavaDsc' -Wait -Force -Verbose $false
    }
    catch {
      "{0:s}  DSC configuration failed. Check DSC log." | Write-Error
    }

    # Delete local Install Set ZIP-file - delete in DSC fails as the file is in use...
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


[string]$PackageName = 'jdk180-112.1'
[string]$MetadataPath = 'F:\PFA_CMDB' # -> json-file

Invoke-Provision -PackageName $PackageName
