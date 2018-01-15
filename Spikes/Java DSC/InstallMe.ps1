<#
.SYNOPSIS
  Install Java 1.8.0-112 local.
.DESCRIPTION
  Install Oracle Java 1.8.0-112 on local host.
  Execute as Administrator.
.PARAMETER <Parameter Name>
  Parameters are defined in functions
.EXAMPLE
.INPUTS
.OUTPUTS
.RETURNVALUE
.EXAMPLE

.NOTES
  2018, Niels Grove-Rasmussen
#>

#Requires -Version 5
Set-StrictMode -Version Latest


#region Java

Configuration InstallJava {
[CmdletBinding()]
Param(
  [Parameter(Mandatory=$true, ValueFromPipeLine=$true,HelpMessage='Take your time to write a good help message...')]
  [string]$ZipFileName,
  
  [Parameter(Mandatory=$true, ValueFromPipeLine=$true,HelpMessage='Take your time to write a good help message...')]
  [string]$DestinationFolder
)

  Import-DscResource –ModuleName 'PSDesiredStateConfiguration'

	Node 'localhost' {
		Archive InstallSetUnzip {
			Ensure = 'Present'
			Path = $ZipFileName
			Destination = $DestinationFolder
			Force = $true
		}
	}
}  # InstallJava

function Install-Java {
<#
.DESCRIPTION
  Install Java on local host
.PARAMETER <Name>
  <parameter description>
.OUTPUTS
  (none)
.RETURNVALUE
  (none)
.LINK
  <link to external reference or documentation>
.NOTES
  2018-01-15
#>
[CmdletBinding()]
[OutputType([void])]
Param(
  [Parameter(Mandatory=$true, ValueFromPipeLine=$true,HelpMessage='Take your time to write a good help message...')]
  [string]$TempFolder,

  [Parameter(Mandatory=$true, ValueFromPipeLine=$true,HelpMessage='Take your time to write a good help message...')]
  [string]$InstallPath,

  [Parameter(Mandatory=$true, ValueFromPipeLine=$true,HelpMessage='Take your time to write a good help message...')]
  [string]$MetadataPath
)

Begin {
  $mywatch = [System.Diagnostics.Stopwatch]::StartNew()
  "{0:s}Z  ::  Install-Java()" -f [System.DateTime]::UtcNow | Write-Verbose

  [string]$PackageName = 'jdk180-112'
  [string]$InstallSetPath = 'http://dsl/content/repositories/Installers/Java/'
  [string]$InstallSetName = 'jdk1.8.0_112-CE.zip'
}

Process {
  'Copy install set file from DSL to local folder...' | Write-Verbose
  [string]$SourceFile = $InstallSetPath + $InstallSetName
  if (-not (Test-Path ($TempFolder + $PackageName))) {
    $NewTempFolder = New-Item -Path $TempFolder -Name $PackageName -ItemType directory
    "Temp folder '$NewTempFolder' created." | Write-Verbose
  }
  [string]$DestinationFile = $TempFolder + $PackageName + '\' + $InstallSetName
  try {
    Start-BitsTransfer -Source $SourceFile -Destination $DestinationFile
  }
  catch {
    $Error[0] | Write-Error
    throw ("{0:s}Z  Could not copy installation file '$InstallSetName' from DSL." -f [System.DateTime]::UtcNow)
  }

  Set-Location $PSScriptRoot

  'Compile to MOF file...' | Write-Verbose
  $MofFile = InstallJava -ZipFileName $DestinationFile -DestinationFolder $TempFolder
  "MOF file = '$MofFile'" | Write-Verbose

  'Apply DSC-configuration...' | Write-Verbose
  try {
    Start-DscConfiguration -Path '.\InstallJava' -Wait -Force
  }
  catch {
    $Error[0] | Write-Error
    throw ("{0:s}Z  DSC configuration failed. DSC MOF file = '.\InstallJava'. Check DSC log." -f [System.DateTime]::UtcNow)
  }

  # Delete local Install Set ZIP-file - delete in DSC fails as the file is in use...
  # ToDo : Test for file in use
  Start-Sleep -Seconds 5
  Remove-Item -LiteralPath ($TempFolder + $PackageName) -Recurse -Force

  # Create local metadata
  Set-Metadata -MetadataPath $MetadataPath
}

End {
  $mywatch.Stop()
  [string]$Message = "Install-Java finished with success. Duration = $($mywatch.Elapsed.ToString()). [hh:mm:ss.ddd]"
  "{0:s}Z  $Message" -f [System.DateTime]::UtcNow | Write-Output
}
}  # Install-Java()

#endregion Java


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
  [string]$MetadataPath
)

Begin {
  $mywatch = [System.Diagnostics.Stopwatch]::StartNew()
  "{0:s}Z  ::  Set-Metadata( '$MetadataPath' )" -f [System.DateTime]::UtcNow | Write-Verbose
}

Process {
<# Create node metadata and write on node
  Create folder
	Create share
	  (-) everyone
		(+) Authenticated Users: Read
	Create file
#>

  'Create metadata folder...' | Write-Verbose
  if (-not (Test-Path ($MetadataPath))) {
    $NewMetadataFolder = New-Item -Path $MetadataPath -ItemType directory
    "Metadata folder '$NewMetadataFolder' created." | Write-Verbose
  }

  'Create metadata share...' | Write-Verbose
  # (https://blogs.technet.microsoft.com/heyscriptingguy/2010/09/16/how-to-use-powershell-to-create-shared-folders-in-windows-7/)
  # "Create method of the Win32_Share class" (https://msdn.microsoft.com/en-us/library/aa389393.aspx)
  if (-not (Get-WmiObject Win32_Share -Filter "name='PFA_CMDB'")) {
    [string]$SharePath = $MetadataPath -replace ".$"  # Remove last '\' from path string
    $Shares = [WMICLASS]'WIN32_Share'
    $Shares.Create($SharePath, 'PFA_CMDB', 0)
  }
  'Set rights on metadata share...' | Write-Verbose

  'Create metadata file...' | Write-Verbose

}

End {
  $mywatch.Stop()
  [string]$Message = "Set-Metadata finished with success. Duration = $($mywatch.Elapsed.ToString()). [hh:mm:ss.ddd]"
  "{0:s}Z  $Message" -f [System.DateTime]::UtcNow | Write-Output
}
}  # Set-Metadata()

#endregion Metadata


###  INVOKE  ###
Clear-Host

[string]$TempFolder = 'C:\temp\'
[String]$InstallPath = 'C:\temp\'
[string]$MetadataPath = 'C:\temp\PFA_CMDB\'
#Install-Java -TempFolder $TempFolder -InstallPath $InstallPath -MetadataPath $MetadataPath #-Verbose #-Debug


### TEST ###
Set-Metadata -MetadataPath $MetadataPath -Verbose
