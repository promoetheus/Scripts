-- get database size, space used and free space
DECLARE @tempholding As TABLE (DBName NVARCHAR(200), [FileName] NVARCHAR(200),[CurrentSize(GB)] NUMERIC(18,10), [SpaceUsed(GB)] NUMERIC(18,10), [AvailableFreeSpace(GB)] NUMERIC(18,10) )
DECLARE @SQL NVARCHAR(MAX)
DECLARE @DBID INT, @DBName  NVARCHAR(200)
DECLARE @DBCursor CURSOR 

SET @DBCursor = CURSOR FOR
SELECT QUOTENAME(NAME), database_id FROM sys.databases WHERE state_desc='ONLINE' and source_database_id IS NULL

OPEN @DBCursor

FETCH NEXT FROM @DBCursor INTO @DBName, @DBID

WHILE @@FETCH_STATUS = 0
BEGIN 
SET @SQL = 'USE ' + @DBName + '; 

		SELECT DB_NAME(DB_ID()) AS [name]
			, name AS [FileName]
			, size/128.0/1024.0 AS [CurrentSize(GB)]
			, CAST(FILEPROPERTY(name, ''SpaceUsed'') AS INT)/128.0/1024.0 AS [SpaceUsed(GB)] 
			, ((size/128.0) - CAST(FILEPROPERTY(name, ''SpaceUsed'') AS INT)/128.0)/1024.0 AS [AvailableFreeSpace(GB)]
			FROM sys.database_files;'

			INSERT INTO @tempholding
			--PRINT @SQL;
			EXEC sp_executesql @SQL;

FETCH NEXT FROM @DBCursor INTO @DBName, @DBID;
END

CLOSE @DBCursor;
DEALLOCATE @DBCursor;
SELECT GETDATE() AS DateTime, DBNAme, FileName, [CurrentSize(GB)], [SpaceUsed(GB)], [AvailableFreeSpace(GB)], [SpaceUsed(GB)] / [CurrentSize(GB)] * 100 AS [% Used Space] 
FROM @tempholding
WHERE DBName in ('Storehouse3','Box3')

---- current database filesize 
--select name, physical_name, size/128.0/1024.0 AS CurrentSize from sys.database_files

---- initial database filesizes
--select name, physical_name, size/128.0/1024.0 AS InitialSize from sys.master_files where database_id=2
--sp_whoisactive

--dbcc sqlperf(logspace)