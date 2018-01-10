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
Param()

	Import-DscResource –ModuleName 'PSDesiredStateConfiguration'

	Node 'localhost' {
		Archive InstallSetUnzip {
			Ensure = 'Present'
			Path = $Node.DmlFolder + $Node.ZipFile
			Destination = $Node.DestinationPath
			Force = $true
		}
	}
}

JavaDsc -ConfigurationData '.\jdk180-112.1.psd1'
