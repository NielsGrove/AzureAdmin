<#
.DESCRIPTION
.PARAMETER <Parameter Name>
.EXAMPLE
.INPUTS
.OUTPUTS
.RETURNVALUE
.EXAMPLE

.NOTES
  Filename  : <Filename>
.NOTES
  <Date and time, ISO8601> <Author> <History>

.LINK
  Get-Help about_Comment_Based_Help
.LINK
  TechNet Library: about_Functions_Advanced
  https://technet.microsoft.com/en-us/library/dd315326.aspx
#>

#Requires -Version 5
Set-StrictMode -Version Latest

Import-Module -Name AzureRM


Login-AzureRmAccount


# Variables
[string]$Location = 'westeurope'
[string]$ResourceGroupName = 'sandVaultRG'
[string]$KeyVaultName = 'sandVault'


# Create Key Vault
$ResourceGroup = New-AzureRmResourceGroup -Name $ResourceGroupName -Location $Location
Set-AzureRmResourceGroup -Name $ResourceGroupName -Tag @{ Dept="MS_Description"; Environment="Resource Group for Key Vault" }

$KeyVault = New-AzureRmKeyVault -VaultName $KeyVaultName -ResourceGroupName $ResourceGroupName -Location $Location `
  -EnabledForDiskEncryption -EnabledForDeployment -EnabledForTemplateDeployment

Set-AzureRmResource -ResourceId $KeyVault.ResourceId -Tag @{ Dept='MS_Description'; Environment='Sandbox Key Vault.' }
<# ERROR
Set-AzureRmResource : The pipeline has been stopped.
At line:1 char:1
+ Set-AzureRmResource -ResourceId $KeyVaultResult.ResourceId -Tag @{ De ...
+ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    + CategoryInfo          : CloseError: (:) [Set-AzureRmResource], PipelineStoppedException
    + FullyQualifiedErrorId : Microsoft.Azure.Commands.ResourceManager.Cmdlets.Implementation.SetAzureResourceCmdlet
 
Set-AzureRmResource : Der opstod en fejl under afsendelse af anmodningen.
At line:1 char:1
+ Set-AzureRmResource -ResourceId $KeyVaultResult.ResourceId -Tag @{ De ...
+ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    + CategoryInfo          : CloseError: (:) [Set-AzureRmResource], HttpRequestException
    + FullyQualifiedErrorId : Der opstod en fejl under afsendelse af anmodningen.,Microsoft.Azure.Commands.ResourceManager.Cmdlets.Implementation.SetAzureResourceCmdlet
#>

