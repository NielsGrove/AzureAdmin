<#
.SYNOPSIS

.DESCRIPTION

.EXAMPLE

.NOTES
  2018, Niels Grove-Rasmussen
#>

Configuration ZipInstallDsc {
	Import-DscResource –ModuleName 'PSDesiredStateConfiguration'

	#if (-not (Test-Path ''))
	Save-Module -Name 'Pscx' -LiteralPath 'C:\temp\' -Repository PSGallery -RequiredVersion 3.3.1 -Force
	Import-Module -Name 'C:\temp\Pscx' -Prefix Pscx -Scope Global -PassThru

	Node 'localhost' {
		File GetFromDsl {
			DestinationPath = $Node.DestinationPath
			Ensure = 'Present'
			Force = $true
			MatchSource = $true
			SourcePath = 'http://dsl/content/repositories/Installers/Java/jdk1.8.0_112-CE.zip'
			Type = 'File'
			PsDscRunAsCredential = Get-Credential
		}

		Script Init {
			GetScript = { @( '...' ) }
			SetScript = { '...' }
			TestScript = { $true }
		}
	}
}

ZipInstallDsc -ConfigurationData ZipInstallDsc.Configuration.psd1
