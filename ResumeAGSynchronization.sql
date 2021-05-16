CREATE PROCEDURE dbo.ResumeAGSynchronization
AS

/**
Written by: Justin Belling 2017-03-09
**/

SET NOCOUNT ON;

DECLARE @DbName NVARCHAR(200), @sql NVARCHAR(400), @Role NVARCHAR(30), @Replica NVARCHAR(50)

SET @Replica = @@SERVERNAME

-- Get Role
SELECT 
	@Role=(CASE role_desc WHEN 'PRIMARY' THEN 1 ELSE 0 END)
FROM 
	sys.dm_hadr_availability_replica_states ars
INNER JOIN
	sys.availability_replicas ar 
ON 
	ars.replica_id=ar.replica_id AND ars.group_id=ar.group_id
WHERE 
	replica_server_name = @Replica

DECLARE db_Cursor CURSOR FAST_FORWARD READ_ONLY FOR 
SELECT 
	DB_NAME(database_id)
FROM 
	sys.dm_hadr_database_replica_states
WHERE 
	is_primary_replica=@Role AND synchronization_state <> 2 AND suspend_reason IS NOT NULL;

OPEN db_Cursor;

FETCH NEXT FROM db_Cursor INTO @DbName

WHILE @@FETCH_STATUS=0
		BEGIN 
			BEGIN TRY
			SET @sql = N'ALTER DATABASE'+SPACE(1)+QUOTENAME(@DbName)+SPACE(1)+'SET HADR RESUME;'+CHAR(10)
			EXEC(@sql)
			END TRY
			BEGIN CATCH
				THROW
			END CATCH 
			FETCH NEXT FROM db_Cursor INTO @DbName
		END
CLOSE db_Cursor;
DEALLOCATE db_Cursor;

SET NOCOUNT OFF;