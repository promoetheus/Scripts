--sp_whoisactive

SET NOCOUNT ON;

WHILE 1=1
	BEGIN
		
		SELECT session_id, status, command, start_time, cpu_time, reads, writes, wait_resource, last_wait_type, wait_type
		FROM sys.dm_exec_requests
		WHERE session_id = 84
				
		IF @@ROWCOUNT = 0
			BREAK;

		WAITFOR DELAY '00:00:01'
		RAISERROR('', 10, 1, N'Waits')
		
	END 

