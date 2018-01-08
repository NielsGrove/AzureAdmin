<#
.SYNOPSIS
  Install Java JRE (Server) on Windows Server.
.DESCRIPTION
  Install Java JRE (Server) on Windows Server.
.PARAMETER <ParameterName>
  (none)
.EXAMPLE
  Start-DscConfiguration -Path '.\JavaDscConfiguration' -Wait -Force -Verbose
.NOTES
  2018, Niels Grove-Rasmussen
#>

Configuration JavaDscConfiguration {
Param()

    Import-DscResource –ModuleName 'PSDesiredStateConfiguration'

    Node 'localhost' {
        # Test if 7zip is installed
        #   (https://docs.microsoft.com/en-us/powershell/dsc/fileresource)
        File 7zip {
            DestinationPath = "$($env:ProgramFiles)\7-Zip\7z.exe"
            Ensure = 'Present'
        }
        
        # Copy Java JRE zipped installation file
        File JavaTarGz {
            Ensure = 'Present'
            Type = 'File'
            SourcePath = $Node.JavaDmlFolder + $Node.JavaGzFile
            DestinationPath = $Node.DestinationPath
            Force = $true
            MatchSource = $true
            DependsOn = '[File]7zip'
        }

        # Unzip Java JRE (.gz)
        #   (https://docs.microsoft.com/en-us/powershell/dsc/scriptresource)
        Script JavaUnzip {
            SetScript = {
                [string]$JavaZipFile = $using:Node.DestinationPath + $using:Node.JavaGzFile
							  "::  Java gz-file = '$JavaZipFile'" | Write-Verbose
                [string]$DestPath = $using:Node.DestinationPath
                "::  Destination Path = '$DestPath'" | Write-Verbose
                [string]$ArgList = "x $JavaZipFile -o$DestPath"
                Start-Process "$($env:ProgramFiles)\7-Zip\7z.exe" -ArgumentList $ArgList -Wait
            }
            TestScript = {
                Test-Path $using:Node.DestinationPath + 'jdk1.8.0_152\README.html'
            }
            GetScript = { '...' }
            DependsOn = '[File]JavaTarGz'
        }

        Script RemoveGz {
            SetScript = {
                [string]$JavaGzFile = $using:Node.DestinationPath + 'server-jre-8u152-windows-x64.tar.gz'
                Remove-Item -LiteralPath $JavaGzFile
            }
            TestScript = {
                [string]$JavaGzFile = $using:Node.DestinationPath + '\server-jre-8u152-windows-x64.tar.gz'
                -not (Test-Path -LiteralPath $JavaGzFile)
            }
            GetScript = { '...' }
            DependsOn = '[Script]JavaUnZip'
        }

        # UnTar Java JRE (.tar)
        Script JavaUnTar {
            SetScript = {
                [string]$JavaTarFile = $using:Node.DestinationPath + '\server-jre-8u152-windows-x64.tar'
                [string]$DestPath = $using:Node.DestinationPath
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
    }
}

JavaDscConfiguration -ConfigurationData '.\Java.Configuration.psd1'
