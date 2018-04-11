<#
.DESCRIPTION
  Create Active Directory (AD) Domain Controller (DC) with new domain in new forrest.

  Windows Server 2016 Core (1709)
.LINK
  How to build a server 2016 domain controller (Non-GUI) and make it secure
  (https://medium.com/@rootsecdev/how-to-build-a-server-2016-domain-controller-non-gui-and-make-it-secure-4e784b393bac)
#>

#region Server
###  Configure server with "sconfig"  ###

# 1) Create computer name (option 2)

# 2) Configure static IP address (option 8)

# 3) Set date and time (option 9)

# Exit to command line (option 15)
#endregion Server


#region Domain Controller
# Start PowerShell: "powershell.exe"

# Create Domain Controller
Get-WindowsFeature AD-Domain-Services | Install-WindowsFeature

# ToDo: Alternative placement of NTDS files, e.g D-drive

Import-Module ADDSDeployment 
Install-ADDSForest
# ignore warnings...

# Create Domain Admin user
New-ADUser -Name 'SuperNiels' -GivenName '' -Surname '' -SamAccountName superniels -UserPrincipalName superniels@sqladmin.lan
Get-ADUser SuperNiels

# Set password for Domain Admin user
Set-ADAccountPassword ‘CN=SuperNiels,CN=users,DC=sqladmin,DC=lan’ -Reset -NewPassword (ConvertTo-SecureString -AsPlainText “P@ssword1234” -Force)
Enable-ADAccount -Identity SuperNiels

# Add user to Domain Admins
Add-ADGroupMember 'Domain Admins' SuperNiels

#endregion Domain Controller
