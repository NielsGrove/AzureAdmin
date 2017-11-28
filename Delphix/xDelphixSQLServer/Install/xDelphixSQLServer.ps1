<#
.DESCRIPTION
	Install or uninstall xDelphixSQLServer module on local computer.
.PARAMETER <Parameter Name>
.EXAMPLE
.INPUTS
.OUTPUTS
.RETURNVALUE
.EXAMPLE
.NOTES
  Filename  : xDelphixSQLServer.ps1
.NOTES
  2017-11-28 (Niels Grove-Rasmussen) Empty script file created.
.LINK
  TechNet Library: about_Functions_Advanced
  https://technet.microsoft.com/en-us/library/dd315326.aspx
#>

#Requires -Version 5
Set-StrictMode -Version Latest

[string[]]$ModulePaths = ([Environment]::GetEnvironmentVariable("PSModulePath")).Split(';')

[System.IO.FileInfo]$ModulePath = 'C:\Program Files\WindowsPowerShell\Modules\xDelphixSQLServer'
if ($ModulePath.Exists -eq $true) {
    "The module path '$ModulePath' exist." | Write-Warning
}
else {
    $ModulePath.Create()
}


#region xDelphixSQLServer

function Import-xDelphixSQLServer {
<#
.DESCRIPTION
  Import xDelphixSQLServer module from GihHub to local host
.PARAMETER <Name>
  <parameter description>
.OUTPUTS
  (none)
.RETURNVALUE
  (none)
.LINK
  Microsoft Docs: Import-Module
  (https://docs.microsoft.com/en-us/powershell/module/Microsoft.PowerShell.Core/Import-Module)
.LINK
  MSDN Library: Installing a PowerShell Module
  (https://msdn.microsoft.com/en-us/library/dd878350.aspx)
.NOTES
  2017-11-28 (Niels Grove-Rasmussen) Function created.
#>
[CmdletBinding()]
[OutputType([void])]
Param()

Begin {
  $mywatch = [System.Diagnostics.Stopwatch]::StartNew()
  "{0:s}Z  ::  Import-xDelphixSQLServer()" -f [System.DateTime]::UtcNow | Write-Verbose
}

Process {
  " Test if user is running PowerShell as administrator..." | Write-Verbose
  'Under Construction!' | Write-Warning

	#" Testing for module '$ModuleName' on local host..." | Write-Verbose
	<#if ((Test-xDelphixSQLServer) -eq $true) {
			'  OK - Ready to import module.' | Write-Verbose
	}
	else {
			throw 'There already are components from the module on the local host.'
	}#>

	"Create folder '$ModulePathName' for module..." | Write-Verbose
	try { New-Item -Path $ModulePathName -ItemType Directory -Force }
	#try { [System.IO.Directory]::CreateDirectory($ModulePathName) }
  catch { throw $_.Exception }
  " Verify folder for module..." | Write-Verbose
	[System.IO.DirectoryInfo]$ModulePath = $ModulePathName
	if ($ModulePath.Exists -eq $true) { # -and $($ModulePath.Attributes) -ceq 'Directory') {
		'  OK - The folder was created with success.' | Write-Verbose
	}
	else {
		throw 'The folder was not created correct.'
	}
}

End {
  $mywatch.Stop()
  [string]$Message = "Import-xDelphixSQLServer finished with success. Duration = $($mywatch.Elapsed.ToString()). [hh:mm:ss.ddd]"
  "{0:s}Z  $Message" -f [System.DateTime]::UtcNow | Write-Output
}
}  # Import-xDelphixSQLServer()


function Test-xDelphixSQLServer {
<#
.DESCRIPTION
  Test if the module xDelphixSQLServer is installed in latest version on local host.
.PARAMETER <Name>
  <parameter description>
.OUTPUTS
  (none)
.RETURNVALUE
  (none)
.LINK
  Microsoft Docs: File​Info Class
  (https://docs.microsoft.com/en-us/dotnet/api/system.io.fileinfo)
.NOTES
  2017-11-28 (Niels Grove-Rasmussen) Function created.
#>
[CmdletBinding()]
[OutputType([bool])]
Param()

Begin {
  $mywatch = [System.Diagnostics.Stopwatch]::StartNew()
  "{0:s}Z  ::  Test-xDelphixSQLServer()" -f [System.DateTime]::UtcNow | Write-Verbose
}

Process {
    [bool]$TestResult = $true

    "Testing if module '$ModuleName' is installed..." | Write-Verbose
    $Module = Get-Module -Name $ModuleName -ListAvailable
    if ($Module -eq $null) {
        "OK - The module is not installed." | Write-Verbose
    }
    else {
        "The module is already installed." | Write-Warning
        $TestResult = $false
    }

    "Testing module path '$($ModulePath.FullName)'..." | Write-Verbose
    if ($ModulePath.Exists -eq $true) {
        "The module path exist." | Write-Warning
        $TestResult = $false
    }
    else {
        "OK - The module path does not exist." | Write-Verbose
    }

    "Testing module file '$($ModuleFile.FullName)'..." | Write-Verbose
    if ($ModuleFile.Exists) {
        'The module file does exist.' | Write-Warning
        $TestResult = $false
    }
    else {
        'OK - The module file does not exist.' | Write-Verbose
    }

    "Testing manifest file '$($ManifestFile.FullName)'..." | Write-Verbose
    if ($ManifestFile.Exists) {
        'The manifest file does exist.' | Write-Warning
        $TestResult = $false
    }
    else {
        'OK - The manifest file does not exist.' | Write-Verbose
    }

    return $TestResult
}

End {
  $mywatch.Stop()
  [string]$Message = "Test-xDelphixSQLServer finished with success. Duration = $($mywatch.Elapsed.ToString()). [hh:mm:ss.ddd]"
  "{0:s}Z  $Message" -f [System.DateTime]::UtcNow | Write-Verbose
}
}  # Test-xDelphixSQLServer()

#endregion xDelphixSQLServer


###  INVOKE  ###
[string]$ModuleName = 'xDelphixSQLServer'
[string]$ModulePathName = "C:\Program Files\WindowsPowerShell\Modules\$ModuleName"  # Default path to module for all users
[string]$ModuleFileName = "$ModulePath\$ModuleName.psm1"
[string]$ManifestFileName = "$ModulePath\$ModuleName.psd1"


Clear-Host
#Test-xDelphixSQLServer -Verbose #-Debug
Import-xDelphixSQLServer -Verbose #-Debug
