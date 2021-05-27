USE [master];
GO

/** Description: SET databases OFFLINE (UKDC1-PC-SQC06\WPINST06) **/

DECLARE @DBName NVARCHAR(MAX), @SQL NVARCHAR(MAX), @SQL1 NVARCHAR(MAX)

DECLARE DBNameCursor CURSOR FOR
SELECT QUOTENAME(name)
	FROM sys.databases WITH (NOLOCK)
	WHERE name LIKE 'WPSP2010%'

OPEN DBNameCursor;

FETCH NEXT FROM DBNameCursor INTO @DBName

WHILE @@FETCH_STATUS=0
	BEGIN 
		SET @SQL1 = 'ALTER DATABASE ' + @DBName + ' SET PARTNER OFF;'
		PRINT @SQL1
		--EXEC sys.sp_executesql @SQL1;

		SET @SQL = 'ALTER DATABASE ' + @DBName + ' SET OFFLINE;' + CHAR(13)
		PRINT @SQL
		--EXEC sys.sp_executesql @SQL
		
		FETCH NEXT FROM DBNameCursor INTO @DBName
	END
CLOSE DBNameCursor;
DEALLOCATE DBNameCursor;