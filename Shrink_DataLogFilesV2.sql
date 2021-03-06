use INSIGHTCOLLECTDB
GO

DECLARE @targetsize INT = 108786 -- 106GB
DECLARE @initialsize INT = 112776
DECLARE @sql nvarchar(max)
declare @dbsize INT

DECLARE @increment INT = 2048

-- get size before shrink
SELECT @dbsize =size/128 
FROM SYS.database_files WHERE file_id=1

IF @dbsize < @initialsize
	BEGIN
		PRINT 'Enter the correct initial size'
		RETURN;
	END

WHILE @initialsize > @targetsize
	BEGIN 
		SET @sql = 'DBCC SHRINKFILE (N''INSIGHTCOLLECTDB'', '+ CONVERT(NVARCHAR,@initialsize - @increment) + ') ';		
		EXEC sys.sp_executesql @sql;

		PRINT @sql;

		SET @initialsize -= @increment

		WAITFOR DELAY '00:00:10'
	END	
GO

-- get size after shrink
--SELECT NAME, physical_name, size/128 FROM SYS.database_files
--xp_fixeddrives