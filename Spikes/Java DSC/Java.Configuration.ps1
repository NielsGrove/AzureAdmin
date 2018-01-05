# https://docs.microsoft.com/en-us/powershell/dsc/separatingenvdata

@{
    AllNodes = @(
        @{
            NodeName = 'localhost'
            DestPath = 'C:\temp\'
        }
    )
}
