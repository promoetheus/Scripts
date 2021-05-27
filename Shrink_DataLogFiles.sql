DECLARE @DBName NVARCHAR(200)='esglogdb76_36'
EXECUTE [dbo].[DatabaseBackup] @Databases = @DBName, @Directory = NULL, @BackupType = 'LOG', @Verify = 'Y', @CleanupTime = 48, @CheckSum = 'Y', @LogToTable = 'Y'


DECLARE @DBName1 NVARCHAR(200)='esglogdb76_36'
DECLARE @sql nvarchar(max)
DECLARE @filename NVARCHAR(200) = (select NAME from sys.master_files where TYPE=1 AND daTABASE_ID IN (select database_id from sys.databases where name = @DBName1));

SET @SQL = 'USE ' + CONVERT(NVARCHAR,@DBName1) + ';

		PRINT ''FileSize before shrink'' 
		select NAME, physical_name, (size*8)/1024.0/1024.0 size_GB from sys.master_files where daTABASE_ID IN (select database_id from sys.databases where name = ''' + CONVERT(NVARCHAR,@DBName1) + ''')

		DBCC SHRINKFILE('+@filename+',1024);
		
		PRINT ''FileSize after shrink''
		select NAME, physical_name, (size*8)/1024.0/1024.0 size_GB from sys.master_files where daTABASE_ID IN (select database_id from sys.databases where name = ''' + CONVERT(NVARCHAR,@DBName1) + ''')'
		--PRINT @SQL

		EXEC sp_executesql @sql

