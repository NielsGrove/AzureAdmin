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
  [PSObject]$Package
)

  Import-DscResource –ModuleName 'PSDesiredStateConfiguration'

  Node 'localhost' {
    File PkgTmpFolder {
      DestinationPath = ($Package.PackageTempFolder)
      Ensure = "Present"
      Type = "Directory"
    }

    #ToDo : Log
    <# PSDesiredStateConfiguration\Node : A Using variable cannot be retrieved. A Using variable can be used only with Invoke-Command, Start-Job, or InlineScript in the script workflow.
    Log Log_PkgTmpFolder {
      Message = "Package tomporary local folder '" + ($Using:Package).PackageTempFolder + "' created with succes."
    }#>

    Script TransferZip {
      GetScript = { '...' }
      SetScript = {
        [string]$SourceFile = ($Using:Package).InstallSetPath + ($Using:Package).InstallSetName
        [string]$LocalZipFile = ($Using:Package).TempFolder + ($Using:Package).PackageName + '\' + ($Using:Package).InstallSetName
        Start-BitsTransfer -Source $SourceFile -Destination $LocalZipFile
      }
      TestScript = {
        [string]$LocalZipFile = ($Using:Package).TempFolder + ($Using:Package).PackageName + '\' + ($Using:Package).InstallSetName
        Test-Path $LocalZipFile
      }
      DependsOn = "[File]PkgTmpFolder"
    }

    #ToDo : Log

    Script ExpandZip {
      GetScript = { 
        @{ Result = ( Get-Content -LiteralPath ($Using:Package).InstallRootPath ) }
      }
      SetScript = {
        [string]$LocalZipFile = ($Using:Package).TempFolder + ($Using:Package).PackageName + '\' + ($Using:Package).InstallSetName
        "Local zip file = '$LocalZipFile'" | Write-Verbose
        "Destination path = '$($Using:Package)'"
        Expand-Archive -LiteralPath ($LocalZipFile) -DestinationPath (($Using:Package).InstallRootPath) -Force #-Verbose #-Debug
      }
      TestScript = {
        [string[]]$Split = (($Using:Package).InstallSetName).Split('.')
        [int]$ExtensionLength = 1 + $Split[$Split.Count-1].Length  # one '.' plus element length (e.g. 'zip')
        [string]$ExpandResultFolder = ($Using:Package).InstallSetName -replace ".{$ExtensionLength}$"
        "Result folder name = '$ExpandResultFolder'" | Write-Verbose
        
        Test-Path (($Using:Package).InstallRootPath + $ExpandResultFolder)
      }
      DependsOn = "[Script]TransferZip"
    }

    #ToDo : Log

    Script RemoveZip {
      GetScript = { '...' }
      SetScript = {
        Remove-Item -LiteralPath (($Using:Package).PackageTempFolder) -Recurse -Force
      }
      TestScript = {
        -not (Test-Path ($Using:Package).PackageTempFolder)
      }
      DependsOn = "[Script]ExpandZip"
    }

    #ToDo : Log
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
  #ToDo : check last '\' in string (and folder exists ?)
  [string]$TempFolder,

  [Parameter(Mandatory=$true, ValueFromPipeLine=$true,HelpMessage='Take your time to write a good help message...')]
  #ToDo : Check path...
  [string]$InstallRootPath,

  [Parameter(Mandatory=$true, ValueFromPipeLine=$true,HelpMessage='Take your time to write a good help message...')]
  #ToDo : Check path...
  [string]$MetadataPath
)

Begin {
  $mywatch = [System.Diagnostics.Stopwatch]::StartNew()
  "{0:s}Z  ::  Install-Java()" -f [System.DateTime]::UtcNow | Write-Verbose

  'Create custom object holding package metadata...' | Write-Verbose
  [PSObject]$Package = New-Object -TypeName PSObject
  $Package | Add-Member -MemberType NoteProperty -Name PackageName -Value 'jdk180-112'
  $Package | Add-Member -MemberType NoteProperty -Name InstallSetName -Value 'jdk1.8.0_112-CE.zip'
  $Package | Add-Member -MemberType NoteProperty -Name InstallSetPath -Value 'http://dsl/content/repositories/Installers/Java/'
  $Package | Add-Member -MemberType NoteProperty -Name InstallRootPath -Value $InstallRootPath
  $Package | Add-Member -MemberType NoteProperty -Name TempFolder -Value $TempFolder
  $Package | Add-Member -MemberType NoteProperty -TypeName string -Name PackageTempFolder -Value ($Package.TempFolder + $Package.PackageName)
  $Package.PSObject.TypeNames.Insert(0, 'DevOps.Package')
}

Process {
  Set-Location $PSScriptRoot

  'Compile to MOF file...' | Write-Verbose
  $MofFile = InstallJava -Package $Package
  #"MOF file = '$($MofFile.FullName)'" | Write-Verbose

  'Apply DSC-configuration...' | Write-Verbose
  try {
    Start-DscConfiguration -Path '.\InstallJava' -Wait -Force
  }
  catch {
    $Error[0] | Write-Error
    throw ("{0:s}Z  DSC configuration failed. DSC MOF file = '$($MofFile.FullName)'. Check DSC log." -f [System.DateTime]::UtcNow)
  }

  Set-Metadata -PackageName $Package.PackageName -MetadataPath $MetadataPath
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
.PARAMETER PackageName
  Name of software package that the metadata belong to.
.PARAMETER MetadataPath
  Local path for metadata, e.g. "D:\DevOps_CMDB"
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
[String]$InstallRootPath = 'C:\temp\'
[string]$MetadataPath = 'C:\temp\PFA_CMDB\'
Install-Java -TempFolder $TempFolder -InstallRootPath $InstallRootPath -MetadataPath $MetadataPath -Verbose #-Debug


### TEST ###
#[string]$_ZipFile = 'C:\temp\jdk180-112\jdk1.8.0_112-CE.zip'
#Set-Metadata -PackageName 'jdk180-112' -MetadataPath $MetadataPath -Verbose
#Remove-ZipFile -ZipFile $_ZipFile -Verbose #-Debug
