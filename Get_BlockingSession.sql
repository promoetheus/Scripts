 
	   SELECT l.resource_type,
				l.resource_database_id,
				l.resource_associated_entity_id,
				l.request_mode,
				l.request_session_id,
				w.blocking_session_id	   
	   FROM sys.dm_tran_locks l WITH (NOLOCK)
		INNER JOIN sys.dm_os_Waiting_tasks w WITH (NOLOCK)
		ON l.lock_owner_address=w.resource_address
		WHERE l.resource_database_id=DB_ID() AND ISNULL(w.blocking_session_id,'') <> ''
