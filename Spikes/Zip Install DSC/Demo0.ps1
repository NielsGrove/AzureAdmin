<#
.DESCRIPTION
  Install application by unpacking/expanding a file from DSL to a given path.
.NOTES
  2018, Niels Grove-Rasmussen
#>


<# Pscx (https://github.com/Pscx/Pscx)
  Get module from PowerShell Gallery to custom path
  and import with prefix to noun to avoid name collision with existing alias and cmdlets, e.g. gcb, Expand-Archive

  PSCX conflicts with multiple commands in version 5.1
  (https://github.com/Pscx/Pscx/issues/23)
#>
Get-Module -ListAvailable
Get-Module -Name Pscx
Get-Command -Module 'Pscx'

Find-Module -Name 'Pscx' -Repository PSGallery

Save-Module -Name 'Pscx' -LiteralPath 'C:\temp\' -Repository PSGallery -RequiredVersion 3.3.1 -Force
Import-Module -Name 'C:\temp\Pscx' -Prefix Pscx -Scope Global -PassThru

Remove-Item -LiteralPath 'C:\temp\Pscx' -Force
#Start-Process 'PowerShell' -ArgumentList "Remove-Item -LiteralPath 'C:\temp\Pscx' -Force" -NoNewWindow -Verb RunAs


Set-Location 'C:\NgrAdmin\GitHub\AzureAdmin\Spikes\Zip Install DSC'

# Compile to MOF file
. .\ZipInstallDsc.ps1

# Apply configuration
Start-DscConfiguration -Path '.\ZipInstallDsc' -Wait -Force -Verbose
