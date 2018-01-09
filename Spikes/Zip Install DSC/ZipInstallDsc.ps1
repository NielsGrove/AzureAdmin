<#
.SYNOPSIS

.DESCRIPTION

.EXAMPLE

.NOTES
  2018, Niels Grove-Rasmussen
#>

Configuration ZipInstallDsc {
	Import-DscResource –ModuleName 'PSDesiredStateConfiguration'

	Save-Module -Name 'Pscx' -LiteralPath 'C:\temp\' -Repository PSGallery -RequiredVersion 3.3.1 -Force
	Import-Module -Name 'C:\temp\Pscx' -Prefix Pscx -Scope Global -PassThru

	Script Init {
		GetScript = {}
		SetScript = {}
		TestScript = { $true }
	}
}

ZipInstallDsc -ConfigurationData ZipInstallDsc.Configuration.psd1
