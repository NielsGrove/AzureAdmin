<#
.DESCRIPTION
  Desired State Configuration Quick Start
  (https://docs.microsoft.com/en-us/powershell/dsc/quickstart)

  Execute as Administrator
.NOTES
  2018, Niels Grove-Rasmussen
#>

Set-Location 'C:\NgrAdmin\GitHub\AzureAdmin\Spikes\Java DSC'


# Compile to MOF file
. .\Java.ps1

# Apply configuration (https://docs.microsoft.com/en-us/powershell/module/psdesiredstateconfiguration/start-dscconfiguration)
Start-DscConfiguration -Path '.\JavaDscConfiguration' -Wait -Force -Verbose

