@{
	AllNodes = @(
		@{
			NodeName = '*'
		},
		@{
			NodeName = 'localhost'
			PSDscAllowDomainUser = $true
			DestinationPath = 'C:\temp\'
		}
	);

	NonNodeData = ""
}
