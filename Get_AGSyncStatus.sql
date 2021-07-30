SELECT AGS.name                       AS AGGroupName, 
       AR.replica_server_name         AS InstanceName, 
	   DRS.is_local,
	   DRS.is_primary_replica,
       --HARS.role_desc, 
       Db_name(DRS.database_id)       AS DBName, 
       DRS.database_id, 
       AR.availability_mode_desc      AS SyncMode, 
       DRS.synchronization_state_desc AS SyncState, 
       DRS.truncation_lsn,
	   DRS.last_hardened_lsn, 
       DRS.end_of_log_lsn, 
       DRS.last_redone_lsn, 
       DRS.last_hardened_time, 
       DRS.last_redone_time, 
       DRS.log_send_queue_size, 
       DRS.redo_queue_size
FROM   sys.dm_hadr_database_replica_states DRS 
LEFT JOIN sys.availability_replicas AR 
ON DRS.replica_id = AR.replica_id 
LEFT JOIN sys.availability_groups AGS 
ON AR.group_id = AGS.group_id 
--LEFT JOIN sys.dm_hadr_availability_replica_states HARS ON AR.group_id = HARS.group_id 
--AND AR.replica_id = HARS.replica_id 
WHERE db_name(database_id) = N'PaymentTrust'
ORDER  BY AGS.name, 
          AR.replica_server_name, 
          Db_name(DRS.database_id)