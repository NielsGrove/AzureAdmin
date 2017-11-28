<#
.DESCRIPTION
  Define Delphix SQL Server Staging server
.PARAMETER <Parameter Name>
.EXAMPLE
.INPUTS
.OUTPUTS
.RETURNVALUE
.EXAMPLE
.NOTES
  Filename  : DelphixSQL.Staging.ps1
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

Configuration DelphixSQLStaging {
	Param ([string]$NodeName = $env:COMPUTERNAME)

  Import-DSCResource -ModuleName xDelphixSQLServer


}
