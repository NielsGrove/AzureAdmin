<#
.DESCRIPTION
  Define Delphix SQL Server Target server.
.PARAMETER <Parameter Name>
.EXAMPLE
.INPUTS
.OUTPUTS
.RETURNVALUE
.EXAMPLE
.NOTES
  Filename  : DelphixSQL.Target.ps1
.NOTES
  2017-11-28 (Niels Grove-Rasmussen) Script file created with dummy function.
.LINK
  Get-Help about_Comment_Based_Help
.LINK
  TechNet Library: about_Functions_Advanced
  https://technet.microsoft.com/en-us/library/dd315326.aspx
#>

#Requires -Version 5
Set-StrictMode -Version Latest

#Import-Module G:\Script\Sandbox\Module.sandbox\Module.sandbox.psm1


#region Windows Network

function Verb-Noun {
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
  [Parameter(Mandatory=$true, ValueFromPipeLine=$true,HelpMessage='Take your time to write a good help message...')]
  [string]$param1
)

Begin {
  $mywatch = [System.Diagnostics.Stopwatch]::StartNew()
  "{0:s}Z  ::  <function name>( '$param1' )" -f [System.DateTime]::UtcNow | Write-Verbose
}

Process {
}

End {
  $mywatch.Stop()
  [string]$Message = "<function name> finished with success. Duration = $($mywatch.Elapsed.ToString()). [hh:mm:ss.ddd]"
  "{0:s}Z  $Message" -f [System.DateTime]::UtcNow | Write-Output
}
}  # Verb-Noun()

#endregion Windows Network

#region Windows System
#endregion Windows System

#region SQL Server
#endregion SQL Server

#region Delphix
#endregion Delphix


###  INVOKE  ###

Clear-Host
#<function call> -Verbose -Debug