<#
.DESCRIPTION
  Set Windows environment variable and path to local Java installation.

  Execute script as Administrator.
.LINK
  Microsoft Docs: About Environment Variables
  (https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_environment_variables)
.LINK
  Microsoft Docs: Environment Class
  (https://docs.microsoft.com/en-us/dotnet/api/system.environment)
#>

#Requires -Version 5
Set-StrictMode -Version Latest

function Set-JavaEnvironment {
  <#
  .DESCRIPTION
    <Description of the function>
  .PARAMETER JavaPath
    Full local path to Java installation, e.g. C:\Java\jdk1.8.0_112
  .OUTPUTS
    (none)
  .RETURNVALUE
    (none)
  .LINK
    <link to external reference or documentation>
  #>
  [CmdletBinding()]
  [OutputType([void])]
  Param(
    [Parameter(Mandatory=$true, ValueFromPipeLine=$false,HelpMessage='Full path to local Java installation.')]
    [ValidateScript({
      if( !(Test-Path -LiteralPath $_.FullName -PathType Container) ) {
        throw "Folder for Java path '$($_.FullName)' not found."
      }
      $true
    })]
    [System.IO.DirectoryInfo]$JavaPath
  )
  
  Begin {
    $mywatch = [System.Diagnostics.Stopwatch]::StartNew()
    "{0:s}Z  ::  Set-JavaEnvironment( '$($JavaPath.FullName)' )" -f [System.DateTime]::UtcNow | Write-Verbose

    'Test if script is executed as Administrator...' | Write-Verbose
    if (([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator') -eq $true) {
      "OK - The user is local administrator." | Write-Verbose
    }
    else {
      throw "{0:s}Z  Installation is aborted as the user is not local administrator." -f [System.DateTime]::UtcNow
    }
  }
  
  Process {
    'Create Windows environment variable JAVA_HOME as system variable...'
    # ToDo : Test if environment variable does exist
    [System.Environment]::SetEnvironmentVariable('JAVA_HOME', $JavaPath.FullName, 'Machine')  #[System.EnvironmentVariableTarget]::Machine
    
    'Test JAVA_HOME...'
        Get-Item -Path env:JAVA_HOME  # execute in new PowerShell session
    
    'Add JAVA_HOME\bin to Windows environment variable PATH...'
    
    'Test PATH...'
    
    'Test Java by version...'
    & 'Java -version'
  }
  
  End {
    $mywatch.Stop()
    [string]$Message = "Set-JavaEnvironment finished with success. Duration = $($mywatch.Elapsed.ToString()). [hh:mm:ss.ddd]"
    "{0:s}Z  $Message" -f [System.DateTime]::UtcNow | Write-Verbose
  }
}  # Set-JavaEnvironment()
  
<#
ToDo: Script to remove Java configuration...
#>

###  INVOKE  ###

#Set-JavaEnvironment -JavaPath 'C:\DoesNotExist'

Set-JavaEnvironment -JavaPath 'C:\Java\jdk1.8.0_112'

