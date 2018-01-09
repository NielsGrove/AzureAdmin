<#
.DESCRIPTION
  Install application by unpacking/expanding a file from DSL to a given path.
.NOTES
  2018, Niels Grove-Rasmussen
#>

Set-Location 'C:\NgrAdmin\GitHub\AzureAdmin\Spikes\Zip Install DSC'


# Pscx (https://github.com/Pscx/Pscx)
Get-Module -ListAvailable
Get-Module -Name Pscx
Get-Command -Module 'Pscx'

Find-Module -Name 'Pscx' -Repository PSGallery

Save-Module -Name 'Pscx' -LiteralPath 'C:\temp\' -Repository PSGallery -RequiredVersion 3.3.1 -Force
Import-Module -Name 'C:\temp\Pscx' -Prefix Pscx -Scope Global -PassThru

Remove-Item -LiteralPath 'C:\temp\Pscx' -Force
#Start-Process 'PowerShell' -ArgumentList "Remove-Item -LiteralPath 'C:\temp\Pscx' -Force" -NoNewWindow -Verb RunAs


# Compile to MOF file
. .\ZipInstall.ps1

# Apply configuration
Start-DscConfiguration -Path '.\ZipInstallConfiguration' -Wait -Force -Verbose
