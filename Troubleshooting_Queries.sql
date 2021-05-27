--select * from sys.databases where database_id=32
-- sqlcmd -E -S $(ESCAPE_SQUOTE(SRVR)) -d DBA_CONFIG -Q "EXECUTE [dbo].[IndexOptimize] @Databases = 'USER_DATABASES', @LogToTable = 'Y'" -b


select (7737669/1000)%60
select ((7737669/(1000*60))%60)


sp_whoisactive;
select * from sys.dm_tran_locks where request_session_id IN ( 108, 165)
SELECT * FROM sys.dm_exec_requests where session_id=108
select * from sys.dm_exec_sessions where session_id=108

sp_who;
sp_who2;
dbcc opentran;
dbcc loginfo;
exec master..xp_fixeddrives

select * from sys.partitions

select * from sys.dm_os_wait_stats

-- get current running queries / Run from CMS or single query editor : will highlight long running queries
SELECT  requests.session_id
		, [sessions].login_name
		, requests.start_time
		, duration_minute = DATEDIFF(MINUTE, requests.start_time, GETDATE())
		, requests.status
		, requests.command
		, SQLText = sqltext.text
		, DBName = DB_NAME(requests.database_id) 
		, requests.blocking_session_id
		, requests.cpu_time
		, requests.wait_type
		, requests.wait_time
		, requests.wait_resource
		, requests.last_wait_type
FROM sys.dm_exec_requests requests WITH (NOLOCK)
	JOIN sys.dm_exec_sessions [sessions] WITH (NOLOCK) 
		ON requests.session_id=[sessions].session_id
	CROSS APPLY sys.dm_exec_sql_text(sql_handle) sqltext
WHERE requests.session_id <> @@spid -- do not show this session / query
	AND requests.session_id> 50 --AND requests.status = 'running'
ORDER BY requests.start_time DESC

-- FIND BLOCKING CULPRIT
SELECT session_id, blocking_session_id, wait_resource, wait_time, wait_type
FROM sys.dm_exec_requests 
WHERE session_id =  ;-- <put sessionid here>

SELECT request_session_id
		, request_mode
		, request_type
		, request_status
		, resource_type
FROM sys.dm_tran_locks
WHERE request_session_id = ; -- <put sessionid here>
ORDER BY request_session_id 


-- run the following query to get the current wait stats 
-- want to analyze the queries that are currently running or which have recently run and their plan is still cache
SELECT 	dm_ws.wait_duration_ms
	, dm_ws.wait_type
	, dm_es.status
	, dm_t.text
	, dm_qp.query_plan
	, dm_ws.session_id
	, dm_es.cpu_time
	, dm_es.memory_usage
	, dm_es.logical_reads
	, dm_es.total_elapsed_time
	,dm_es.program_name
	-- Optional columns
	, dm_ws.blocking_session_id
	, dm_r.wait_resource
	, dm_es.login_name
	, dm_r.command
	, dm_r.last_wait_type
FROM sys.dm_os_waiting_tasks dm_ws 
INNER JOIN sys.dm_exec_requests dm_r
	ON dm_ws.session_id = dm_r.session_id
INNER JOIN sys.dm_exec_sessions dm_es 
	ON dm_es.session_id = dm_r.session_id
CROSS APPLY sys.dm_exec_sql_text(dm_r.sql_handle) dm_t
CROSS APPLY sys.dm_exec_query_plan(dm_r.plan_handle) dm_qp
WHERE dm_es.is_user_process=1



----- get logspace used
SELECT  instance_name AS DBName, counter_name, cntr_value
FROM sys.dm_os_performance_counters
WHERE counter_name IN ('Log File(s) Size (KB)', 'Log File(s) Used Size (KB)', 'Percent Log Used')
AND instance_name = 'USER_SCRATCH'
ORDER BY 3 DESC


-- get HA status, run query agsint SQL 2012 / 2014
SELECT DB_NAME(A.database_id), b.replica_server_name, A.*
FROM sys.dm_hadr_database_replica_states A
	INNER JOIN sys.availability_replicas B ON a.replica_id=B.replica_id
	--WHERE a.database_id IN (24,25)
	WHERE cast(last_commit_time as date) <> '2015-12-11'
	order by A.last_commit_time


SELECT * FROM sys.dm_hadr_database_replica_states A

select * from sys.dm_hadr_database_replica_states where database_id in (24,25)


---- reading the log file
SELECT [transaction id], operation, context, allocunitname
FROM fn_dblog (NULL,NULL) -- not looking for a specific LSN


----- get backup status
SELECT TOP 1000
	bs.database_name
	, bm.physical_device_name
	, CAST(CAST(bs.backup_size/1000000 AS INT) AS VARCHAR(14)) AS bksize_MB
	, bs.backup_start_date
	, bs.backup_finish_date
	, DATEDIFF(MINUTE, bs.backup_start_date, bs.backup_finish_date) bkupduration_Minute
	, bs.first_lsn
	, bs.last_lsn
	, CASE bs.type
		WHEN 'L' THEN 'Transaction'
		WHEN 'D' THEN 'Differential'
		WHEN 'F' THEN 'Full'
		END AS 'backup_type'
FROM msdb.dbo.backupset bs
	INNER JOIN msdb.dbo.backupmediafamily bm
	ON bs.media_set_id=bm.media_set_id
--WHERE bs.database_name = 'USER_SCRATCH'
WHERE physical_device_name like '%full%' -- get the full backup completion
AND CAST(backup_start_date AS DATE) = '20160113'
ORDER BY bs.backup_start_date DESC


---- check db mirroring status
select db_name(database_id) AS DatabaseName,
		CASE WHEN mirroring_guid IS NOT NULL 
				THEN 'Mirroring is On' ELSE 
					'No mirroring is configured' END AS IsMirrorOn,
		mirroring_state_desc,
		CASE WHEN mirroring_safety_level=1 THEN 'High Performance'
			WHEN mirroring_safety_level=2 THEN 'High Safety' ELSE NULL END AS MirrorSafety,
	mirroring_role_desc,
	mirroring_partner_instance AS MirrorServer
from sys.database_mirroring
WHERE database_id > 4


