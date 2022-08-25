DECLARE @DBName NVARCHAR(255) = 'Alexis';

SELECT AGS.name                       AS AGGroupName, 
       AR.replica_server_name         AS InstanceName, 
	  -- CASE WHEN ARS.is_local,
	   DRS.is_primary_replica,
       --HARS.role_desc, 
       Db_name(DRS.database_id)       AS DBName, 
       DRS.database_id, 
       AR.availability_mode_desc      AS SyncMode, 
       DRS.synchronization_state_desc AS SyncState,
	   drs.synchronization_health_desc AS [Health State],
	   log_send_rate,
	   DRS.log_send_queue_size as [Send Queue Size (KB)], 
	   drs.log_send_rate as [Send Rate KB/Sec],
       DRS.redo_queue_size as [Redo Queue Size (KB)],
	   	      DATEDIFF(SECOND, DRS.last_redone_time,DRS.last_hardened_time) / 60.0 As [Lag_mins],
	    DRS.last_redone_time,
       DRS.truncation_lsn, 
	   DRS.last_hardened_lsn, 
       DRS.end_of_log_lsn, 
       DRS.last_redone_lsn,  
       DRS.last_hardened_time,
	   drs.last_commit_time AS [Last Commit Time]

FROM   sys.availability_groups AS AGS with(NOLOCK) JOIN sys.availability_replicas AS AR with(NOLOCK)
	on AGS.group_id = AR.group_id
JOIN sys.dm_hadr_availability_replica_states ARS with(NOLOCK)
	on AR.replica_id = ARS.replica_id
JOIN sys.dm_hadr_database_replica_states DRS with(NOLOCK)
	on AGS.group_id = DRS.group_id AND DRS.replica_id=ARS.replica_id
WHERE db_name(DRS.database_id) = @DBName
ORDER BY DBName, drs.database_id, ar.replica_server_name
OPTION(RECOMPILE, MAXDOP 1);


SELECT log_reuse_wait_desc, * 
FROM sys.databases WHERE NAME IN (''+ @DBName + '')
GO
