<#
.DESCRIPTION
  Install Java JRE on Windows Server
.EXAMPLE

#>

Configuration JavaDscConfiguration {
Param(
    [Parameter(Mandatory=$true)]
    [string]$ComputerName = 'localhost'
)
    Node $ComputerName {
        # Copy Java JRE zipped installation file
        File JavaTarGz {
            Ensure = 'Present'
            Type = 'File'
            SourcePath = 'C:\NgrAdmin\DML\Java 8\server-jre-8u152-windows-x64.tar.gz'
            DestinationPath = 'C:\temp\'
            Force = $true
            MatchSource = $true
        }

        # Unzip Java JRE (.tar.gz)
        # https://blogs.technet.microsoft.com/heyscriptingguy/2015/03/11/use-powershell-to-extract-zipped-files/
        # https://stackoverflow.com/questions/27768303/how-to-unzip-a-file-in-powershell

        # Set javapath
    }
}

JavaDscConfiguration
