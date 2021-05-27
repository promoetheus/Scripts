SET NOCOUNT ON;

DECLARE @DBName NVARCHAR(400);
DECLARE @T TABLE (id INT IDENTITY(1,1), DBName NVARCHAR(200));
DECLARE @rwcnt INT=1;
DECLARE @totrows INT;

INSERT INTO @T (DBName)
SELECT name
FROM sys.databases WHERE name NOT IN ('tempdb', 'master', 'model', 'msdb') AND state_desc='ONLINE';

SET @totrows = (SELECT COUNT(*) FROM @T WHERE DBName IS NOT NULL);

WHILE (@rwcnt < @totrows)
BEGIN
		SET @DBName = (SELECT DBName FROM @T WHERE id=@rwcnt);

		SELECT db.database_id,db.name, mf.name ,mf.physical_name, CAST((size*8)/1024.0/1024.0 AS NUMERIC(18,10))AS SizeGB, MAX(ius.last_user_seek) AS last_user_seek, MAX(ius.last_user_update) AS last_user_update
		FROM sys.databases db 
		INNER JOIN sys.master_files mf on db.database_id=mf.database_id
		INNER JOIN sys.dm_db_index_usage_stats ius on mf.database_id=ius.database_id
		WHERE db.name = @DBName
		GROUP BY db.database_id,db.name, mf.name ,mf.physical_name, CAST((size*8)/1024.0/1024.0 AS NUMERIC(18,10)) ;

		SET @rwcnt = @rwcnt+1;
END;