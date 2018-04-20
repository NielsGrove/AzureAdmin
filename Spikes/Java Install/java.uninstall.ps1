<#
.DESCRIPTION
  Uninstall local Java installation.
  Binaries and configurations are removed.
#>

function Uninstall-Java {
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
  #>
  [CmdletBinding()]
  [OutputType([void])]
  Param(
    #[Parameter(Mandatory=$true, ValueFromPipeLine=$true,HelpMessage='Take your time to write a good help message...')]
    #[string]$param1
  )
    
  Begin {
    $mywatch = [System.Diagnostics.Stopwatch]::StartNew()
    "{0:s}Z  ::  Uninstall-Java( '...' )" -f [System.DateTime]::UtcNow | Write-Verbose
  }
    
  Process {
    'Remove JAVA_HOME from PATH...' | Write-Verbose

    'Remove JAVA_HOME...' | Write-Verbose

    'Remove files...' | Write-Verbose
  }
    
  End {
    $mywatch.Stop()
    [string]$Message = "Uninstall-Java finished with success. Duration = $($mywatch.Elapsed.ToString()). [hh:mm:ss.ddd]"
    "{0:s}Z  $Message" -f [System.DateTime]::UtcNow | Write-Verbose
  }
}  # Uninstall-Java()
    

###  INVOKE  ###
Uninstall-Java -Verbose #-Debug
