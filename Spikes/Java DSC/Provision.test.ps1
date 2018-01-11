<#
.DESCRIPTION
  Test Provision module and script.
.NOTES
  2018-01-11
#>

#region Provision Module

Set-Location -LiteralPath 'C:\NgrAdmin\GitHub\AzureAdmin\Spikes\Java DSC'
Import-Module -Name ".\Provision.psm1" -Verbose -Debug

$NodeDefinition = Get-NodeDefinition -DefinitionFile 'jdk180-112.1.json'

[string]$InstallSetSource = 'http://dsl/content/repositories/Installers/Java/jdk1.8.0_112-CE.zip'  # -> json file
[string]$InstallSetDestination = 'C:\temp\jdk180-112.1\jdk1.8.0_112-CE.zip'  # -> json file
Get-InstallSet -SourceFile $InstallSetSource -DestinationFile $InstallSetDestination

Set-Metadata -LocalPath 'C:\temp\'

Remove-Module -Name Provision -Verbose -Debug

#endregion Provision Module


#region Provision Script

.\Provision.ps1 -PackageName ''

#endregion Provision Script
