DECLARE @ServerName NVARCHAR(256) = @@SERVERNAME
DECLARE @RoleDesc NVARCHAR(60)

SELECT @RoleDesc = ha.role_desc
FROM sys.dm_hadr_availability_replica_states AS ha
	JOIN sys.availability_replicas ar
	ON ha.replica_id = ar.replica_id
WHERE ar.replica_server_name = @ServerName

PRINT @RoleDesc

/**
IF @RoleDesc = 'PRIMARY'
BEGIN 
	-- add logic
	PRINT 'add logic here'
END

**/