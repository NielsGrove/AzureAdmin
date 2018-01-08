# https://docs.microsoft.com/en-us/powershell/dsc/separatingenvdata

@{
    AllNodes = @(
      @{
			      NodeName = '*'
			},
			@{
            NodeName = 'localhost'
				    JavaDmlFolder = 'C:\NgrAdmin\DML\Java 8\'
				    JavaGzFile = 'server-jre-8u152-windows-x64.tar.gz'
            DestinationPath = 'C:\temp\'
        }
    );

    NonNodeData = ""
}
