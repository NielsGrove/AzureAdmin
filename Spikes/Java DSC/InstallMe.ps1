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
  [string]$LocalZipFile = $TempFolder + $PackageName + '\' + $InstallSetName
  try {
    Start-BitsTransfer -Source $SourceFile -Destination $LocalZipFile
  }
  catch {
    $Error[0] | Write-Error
    throw ("{0:s}Z  Could not copy installation file '$InstallSetName' from DSL." -f [System.DateTime]::UtcNow)
  }

  Expand-Archive -LiteralPath $LocalZipFile -DestinationPath $TempFolder

  <#Set-Location $PSScriptRoot

  'Compile to MOF file...' | Write-Verbose
  $MofFile = InstallJava -ZipFileName $LocalZipFile -DestinationFolder $TempFolder
  "MOF file = '$MofFile'" | Write-Verbose

  'Apply DSC-configuration...' | Write-Verbose
  try {
    Start-DscConfiguration -Path '.\InstallJava' -Wait -Force
  }
  catch {
    $Error[0] | Write-Error
    throw ("{0:s}Z  DSC configuration failed. DSC MOF file = '.\InstallJava'. Check DSC log." -f [System.DateTime]::UtcNow)
  }#>

  'Delete local Install Set ZIP-file - delete in DSC fails as the file is in use...' | Write-Verbose
  Remove-Zip -ZipFolder ($TempFolder + $PackageName)

  Set-Metadata -PackageName $PackageName -MetadataPath $MetadataPath
}

End {
  $mywatch.Stop()
  [string]$Message = "Install-Java finished with success. Duration = $($mywatch.Elapsed.ToString()). [hh:mm:ss.ddd]"
  "{0:s}Z  $Message" -f [System.DateTime]::UtcNow | Write-Output
}
}  # Install-Java()


function Remove-Zip {
[CmdletBinding()]
[OutputType([void])]
Param(
  [Parameter(Mandatory=$true, ValueFromPipeLine=$true,HelpMessage='Take your time to write a good help message...')]
  [string]$ZipFolder
)

Begin {
  $mywatch = [System.Diagnostics.Stopwatch]::StartNew()
  "{0:s}Z  ::  Remove-Zip()" -f [System.DateTime]::UtcNow | Write-Verbose
}

Process {
  [int]$RetryCount = 0
  Do {
    'Waiting to delete zip-file...' | Write-Verbose
    Start-Sleep -Seconds 5
    "Retry count = $RetryCount" | Write-Verbose
    Remove-Item -LiteralPath $ZipFolder -Recurse -Force
  } While ((Test-Path -Path $ZipFolder) -and ++$RetryCount -le 5)

  if (Test-Path -Path $ZipFolder) {
    "{0:s}Z  Failed to delete zip-file" -f [System.DateTime]::UtcNow | Write-Error
  }
}

End {
  $mywatch.Stop()
  [string]$Message = "Remove-Zip finished with success. Duration = $($mywatch.Elapsed.ToString()). [hh:mm:ss.ddd]"
  "{0:s}Z  $Message" -f [System.DateTime]::UtcNow | Write-Output
}
}  # Remove-Zip()

#endregion Java


#region Metadata

function Set-Metadata {
<#
.DESCRIPTION
  <Description of the function>
.PARAMETER PackageName
  Name of software package that the metadata belong to.
.PARAMETER MetadataPath
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
  [string]$PackageName,

  [Parameter(Mandatory=$true, ValueFromPipeLine=$true,HelpMessage='Take your time to write a good help message...')]
  [string]$MetadataPath
)

Begin {
  $mywatch = [System.Diagnostics.Stopwatch]::StartNew()
  "{0:s}Z  ::  Set-Metadata( '$MetadataPath' )" -f [System.DateTime]::UtcNow | Write-Verbose
}

Process {
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
    [string]$ShareName = 'PFA_CMDB'
    $Shares = [WMICLASS]'WIN32_Share'
    $ShareResult = $Shares.Create($SharePath, $ShareName, 0)
    "Share result = '$($ShareResult.ReturnValue)'" | Write-Verbose
    if ($ShareResult.ReturnValue -eq 0) {
      "File share '$ShareName' is created with succes (return value '0')." | Write-Verbose
    }
    else {
      throw ("{0:s}Z  The file share '$ShareName' could not be created. Return value = '$($ShareResult.ReturnValue)'." -f [System.DateTime]::UtcNow)
    }
  }
  #'Set rights on metadata share...' | Write-Verbose
  #  ToDo ? (-) Everyone, (+) Authenticated Users

  'Create metadata file...' | Write-Verbose
  [DateTime]$InstallDate = New-Object System.DateTime(([System.DateTime]::Today).Ticks, [DateTimeKind]::Utc)
  [string]$Metadata = "PackageName: $PackageName; Install Date: {0:yyyy-MM-ddK}; User: $($env:USERNAME)@$($env:USERDOMAIN)" -f $InstallDate
  [string]$MetadataFileName = "$MetadataPath$PackageName.metadata"
  try {
    $Metadata | Out-File -FilePath $MetadataFileName
  }
  catch {
    $Error[0].ErrorDetails | Write-Error
    throw ("{0:s}Z  Could not write metadata to file '$MetadataFileName'." -f [System.DateTime]::UtcNow)
  }
}

End {
  $mywatch.Stop()
  [string]$Message = "Set-Metadata finished with success. Duration = $($mywatch.Elapsed.ToString()). [hh:mm:ss.ddd]"
  "{0:s}Z  $Message" -f [System.DateTime]::UtcNow | Write-Verbose
}
}  # Set-Metadata()

#endregion Metadata


###  INVOKE  ###
Clear-Host

[string]$TempFolder = 'C:\temp\'
[String]$InstallPath = 'C:\temp\'
[string]$MetadataPath = 'C:\temp\PFA_CMDB\'
Install-Java -TempFolder $TempFolder -InstallPath $InstallPath -MetadataPath $MetadataPath -Verbose #-Debug


### TEST ###
[string]$_ZipFile = 'C:\temp\jdk180-112\jdk1.8.0_112-CE.zip'
#Set-Metadata -PackageName 'jdk180-112' -MetadataPath $MetadataPath -Verbose
#Remove-ZipFile -ZipFile $_ZipFile -Verbose #-Debug
