[DscResource()]
class DelphixSQL {
	[DscProperty(Key)]
	[string]$Role
	
	[void]Set() {}

	[DelphixSQL]Get() {
		return $this
	}

	<#
		Principles:
		One test - one function
		Each funk with specific reference to Delphix documentation
	#>
	[bool]Test() {
		switch -exact -casesensitive ($this.Role) {
			'Staging' {}
			'Target' {}
			'Source' {}
			default {
				throw "The role '$($this.Role)' is not valid."
			}
		}

		return $true
	}
}


#region Windows Network
# (https://docs.delphix.com/docs/delphix-administration/sql-server-environments-and-data-sources/setting-up-and-configuring-delphix-for-sql-server/tasks-for-the-windows-network-administrator)


#endregion Windows Network


#region Windows System
# (https://docs.delphix.com/docs/delphix-administration/sql-server-environments-and-data-sources/setting-up-and-configuring-delphix-for-sql-server/tasks-for-the-windows-system-administrator)

# Windows Database Server Requirements
# (https://docs.delphix.com/docs/delphix-administration/sql-server-environments-and-data-sources/setting-up-and-configuring-delphix-for-sql-server/tasks-for-the-windows-system-administrator/windows-database-server-requirements)
# Test 1 (Staging): Only standalone SQL Server 

# Test 2 (Staging): SQL Server instance must be the same (major) version as the Source instance

# Test 3 (Staging): Owner of Staging has SMB read access 

# Test 4 (Staging): Similar backup software on both Source and Staging

# Test 5 (Staging): Source in same AD domain as Staging or trust

# Test 6 (Source): Source in same AD domain as Staging or trust

# Test

# Test (Target): Target in same AD domain as Source or trust

# Test (Target):

# Test (iSCSI): Required for operational stability



#endregion Windows System


#region SQL Server
# (https://docs.delphix.com/docs/delphix-administration/sql-server-environments-and-data-sources/setting-up-and-configuring-delphix-for-sql-server/tasks-for-the-sql-server-database-administrator)

#endregion SQL Server


#region Delphix
# (https://docs.delphix.com/docs/delphix-administration/sql-server-environments-and-data-sources/setting-up-and-configuring-delphix-for-sql-server/tasks-for-the-delphix-administrator)

#endregion Delphix
