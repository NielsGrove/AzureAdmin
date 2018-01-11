<#
.SYNOPSIS
  Install Java JRE (Server) on Windows Server.
.DESCRIPTION
  Install Java JRE (Server) on Windows Server.
.PARAMETER <ParameterName>
  (none)
.EXAMPLE
  Start-DscConfiguration -Path '.\JavaDscConfiguration' -Wait -Force -Verbose
.NOTES
  2018, Niels Grove-Rasmussen

	2018-01-10 : InstallSetUnzip = 120.6330 seconds.
#>

Configuration JavaDsc {
[CmdletBinding()]
Param(
  [Parameter(Mandatory=$true, ValueFromPipeLine=$true,HelpMessage='Take your time to write a good help message...')]
  [string]$ZipFileName
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
			Path = $Node.DmlFolder + $using:ZipFileName
			Destination = $Node.DestinationPath
			Force = $true
		}
	}
}

JavaDsc -ConfigurationData '.\jdk180-112.1.psd1'
