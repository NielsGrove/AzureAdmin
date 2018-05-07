/*
DESCRIPTION
  Create pre-existing databases for TFS on SQL Server Database Engine (SSDB).
*/

/* TFS Configuration */

CREATE DATABASE [tfs_configuration]
 ON  PRIMARY 
( NAME = N'tfs_configuration_0', 
  FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\tfs_configuration_0.mdf' , 
  SIZE = 384MB , FILEGROWTH = 64MB )
/*  DON'T ADD EXTRA DATAFILES!!!
( NAME = N'tfs_configuration_1', 
  FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\tfs_configuration_1.ndf' , 
  SIZE = 16MB , FILEGROWTH = 16MB ),
( NAME = N'tfs_configuration_2', 
  FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\tfs_configuration_2.ndf' , 
  SIZE = 16MB , FILEGROWTH = 16MB ),
( NAME = N'tfs_configuration_3', 
  FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\tfs_configuration_3.ndf' , 
  SIZE = 16MB , FILEGROWTH = 16MB ),
( NAME = N'tfs_configuration_4', 
  FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\tfs_configuration_4.ndf' , 
  SIZE = 16MB , FILEGROWTH = 16MB ),
( NAME = N'tfs_configuration_5', 
  FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\tfs_configuration_5.ndf' , 
  SIZE = 16MB , FILEGROWTH = 16MB ),
( NAME = N'tfs_configuration_6', 
  FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\tfs_configuration_6.ndf' , 
  SIZE = 16MB , FILEGROWTH = 16MB ),
( NAME = N'tfs_configuration_7', 
  FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\tfs_configuration_7.ndf' , 
  SIZE = 16MB , FILEGROWTH = 16MB )
*/
 LOG ON 
( NAME = N'tfs_configuration_log', 
  FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\tfs_configuration.ldf' , 
  SIZE = 224MB , FILEGROWTH = 64MB );
GO
ALTER AUTHORIZATION ON DATABASE::[tfs_configuration] TO [sa];
GO


/* TFS Warehouse */

CREATE DATABASE [tfs_warehouse]
 ON  PRIMARY 
( NAME = N'tfs_warehouse_0', 
  FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\tfs_warehouse_0.mdf' , 
  SIZE = 16MB , FILEGROWTH = 16MB ),
( NAME = N'tfs_warehouse_1', 
  FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\tfs_warehouse_1.ndf' , 
  SIZE = 16MB , FILEGROWTH = 16MB ),
( NAME = N'tfs_warehouse_2', 
  FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\tfs_warehouse_2.ndf' , 
  SIZE = 16MB , FILEGROWTH = 16MB ),
( NAME = N'tfs_warehouse_3', 
  FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\tfs_warehouse_3.ndf' , 
  SIZE = 16MB , FILEGROWTH = 16MB ),
( NAME = N'tfs_warehouse_4', 
  FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\tfs_warehouse_4.ndf' , 
  SIZE = 16MB , FILEGROWTH = 16MB ),
( NAME = N'tfs_warehouse_5', 
  FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\tfs_warehouse_5.ndf' , 
  SIZE = 16MB , FILEGROWTH = 16MB ),
( NAME = N'tfs_warehouse_6', 
  FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\tfs_warehouse_6.ndf' , 
  SIZE = 16MB , FILEGROWTH = 16MB ),
( NAME = N'tfs_warehouse_7', 
  FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\tfs_warehouse_7.ndf' , 
  SIZE = 16MB , FILEGROWTH = 16MB )
 LOG ON 
( NAME = N'tfs_warehouse_log', 
  FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\tfs_warehouse.ldf' , 
  SIZE = 8MB , FILEGROWTH = 64MB );
GO
ALTER DATABASE [tfs_warehouse]
  MODIFY FILEGROUP [PRIMARY] AUTOGROW_ALL_FILES;
GO

ALTER AUTHORIZATION ON DATABASE::[tfs_warehouse] TO [sa];
GO


/* TFS Default Collection */

ALTER DATABASE [Tfs_DefaultCollection]
  MODIFY FILEGROUP [PRIMARY] AUTOGROW_ALL_FILES;
GO


/*
  Verify autogrow on all files
  (https://www.mssqltips.com/sqlservertip/4937/expand-all-database-files-simultaneously-using-sql-server-2016-autogrowallfiles/) 
*/

USE [Tfs_DefaultCollection];
GO
SELECT
    DB_NAME() DatabaseName,
    DBF.name AS FileName,
    FileG.name as FileGroupName,
    FileG.is_autogrow_all_files AutoGrowthEnable
FROM sys.database_files AS DBF
JOIN sys.filegroups AS FileG
    ON DBF.data_space_id = FileG.data_space_id
GO
USE [master];
GO

