<#
.DESCRIPTION
  Install Java JRE on Windows Server
.EXAMPLE

#>

Configuration JavaDscConfiguration {
Param(
    [Parameter(Mandatory=$true)]
    [string]$ComputerName
)

    Node $ComputerName {
        # Test if 7-zip is installed
        #   (https://docs.microsoft.com/en-us/powershell/dsc/fileresource)
        File 7zip {
            DestinationPath = "$($env:ProgramFiles)\7-Zip\7z.exe"
            Ensure = 'Present'
        }
        
        # Copy Java JRE zipped installation file
        File JavaTarGz {
            Ensure = 'Present'
            Type = 'File'
            SourcePath = 'C:\NgrAdmin\DML\Java 8\server-jre-8u152-windows-x64.tar.gz'
            DestinationPath = 'C:\temp\'
            #DestinationPath = $ConfigurationData.AllNodes.DestPath
            Force = $true
            MatchSource = $true
            DependsOn = '[File]7zip'
        }

        # Unzip Java JRE (.tar.gz)
        #   (https://docs.microsoft.com/en-us/powershell/dsc/scriptresource)
        Script JavaUnzip {
            SetScript = {
                ':: JavaUnzip - SetScript' | Write-Verbose
                [string]$JavaZipFile = 'C:\temp\server-jre-8u152-windows-x64.tar.gz'
                [string]$DestPath = 'C:\temp\'
                [string]$ArgList = "x $JavaZipFile -o$DestPath"
                Start-Process "$($env:ProgramFiles)\7-Zip\7z.exe" -ArgumentList $ArgList -Wait
            }
            TestScript = {
                Test-Path 'C:\temp\jdk1.8.0_152\README.html'
            }
            GetScript = { '...' }
            DependsOn = '[File]JavaTarGz'
        }

        Script RemoveGz {
            SetScript = {
                [string]$JavaZipFile = 'C:\temp\server-jre-8u152-windows-x64.tar.gz'
                Remove-Item -LiteralPath $JavaZipFile
            }
            TestScript = {
                [string]$JavaZipFile = 'C:\temp\server-jre-8u152-windows-x64.tar.gz'
                -not (Test-Path -LiteralPath $JavaZipFile)
            }
            GetScript = { '...' }
            DependsOn = '[Script]JavaUnZip'
        }

        # UnTar Java JRE (.tar)
        Script JavaUnTar {
            SetScript = {
                [string]$JavaTarFile = 'C:\temp\server-jre-8u152-windows-x64.tar'
                [string]$DestPath = 'C:\temp\'
                [string]$ArgList = "x $JavaTarFile -o$DestPath"
                Start-Process "$($env:ProgramFiles)\7-Zip\7z.exe" -ArgumentList $ArgList -Wait
            }
            TestScript = {
                Test-Path 'C:\temp\jdk1.8.0_152'
            }
            GetScript = { '...' }
            DependsOn = '[Script]JavaUnzip'
        }

        Script RemoveTar {
            SetScript = {
                [string]$JavaTarFile = 'C:\temp\server-jre-8u152-windows-x64.tar'
                Remove-Item -LiteralPath $JavaTarFile
            }
            TestScript = {
                [string]$JavaTarFile = 'C:\temp\server-jre-8u152-windows-x64.tar'
                -not (Test-Path -LiteralPath $JavaTarFile)
            }
            GetScript = { '...' }
            DependsOn = '[Script]JavaUnTar'
        }

        # Set javapath
    }
}

JavaDscConfiguration -ComputerName 'localhost'
#JavaDscConfiguration -ConfigurationData <config file name>
