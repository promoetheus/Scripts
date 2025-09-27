dbcc opentran

xp_readerrorlog

-- Get Orphaned Sessions
-- may need to kill orphaned/sleeping sessions
select status, lastwaittype, loginame, hostname, program_name, * 
from master.dbo.sysprocesses with(nolock)
--where loginame = 'ttd_kafkaproducer'
where lastwaittype = 'COMMIT_TABLE'
and spid > 50
and status='sleeping'


sp_spaceused 'dbo.Creative'

--sp_who2 2468

--select * from sys.configurations
--where name like  '%tempdb metadata memory-optimized%'

-- get Active Sessions
EXEC sp_WhoIsActive --548, --1036 / va7-db-aak03
	--@filter = 'ttd_kafkaproducer',
	--@filter_type = 'login',
	--@get_plans=1, -- only when db is not under pressure
	@get_outer_command=1; -- shows root stored procedure / SQL script if anyone is running it
	--@show_sleeping_spids
GO

dbcc sqlperf(logspace)


select * from sys.dm_os_wait_stats

select 100*1024

sp_recompile ''

--sp_whoisactive 2216
--GO
--dbcc sqlperf(logspace)
--GO

-- get TempDB Pressure
EXEC sp_WhoIsActive
	@sort_order = '[tempdb_current] DESC',
	--@get_plans=1, -- only when db is not under pressure
	@output_column_list = '[start_time][session_id][login_name][sql_text][query_plan][wait_info][temp%]'
GO

-- get Blocked Sessions
EXEC sp_WhoIsActive
	@find_block_leaders = 1,
	@sort_order = '[blocked_session_count] DESC'--,
	--@get_plans = 1, -- only when db is not under pressure
	--@get_task_info = 2,
	--@get_additional_info = 1,
	--@output_column_list = '[start_time][session_id][login_name][sql_text][query_plan][wait_info][block%][additional_info]'
GO

dbcc sqlperf(logspace)

--
EXEC sp_WhoIsActive
 @filter_type = 'login',
 @filter = 'ttd_kafkaproducer',
 @show_sleeping_spids=2 


select * from msdb.dbo.sysjobs where job_id= CAST(0x63DE1B174ACC9347B7472D885FF63176 as uniqueidentifier)  -- _TTD-UpdateAdGroupPotentialSpendDailyRollup_AWS
select * from msdb.dbo.sysjobs where job_id= CAST(0x6A55EDBFB965A043B79EEF9F210D1F25 as uniqueidentifier) -- Workflow-Fast

/**
SQLAgent - TSQL JobStep (Job 0x63DE1B174ACC9347B7472D885FF63176 : Step 1)

SQLAgent - TSQL JobStep (Job 0x74F413619AF2EF49A4B2633F55896821 : Step 1)
SQLAgent - TSQL JobStep (Job 0x6A55EDBFB965A043B79EEF9F210D1F25 : Step 1)
SQLAgent - TSQL JobStep (Job 0x2341709FE370794A8ADB17555EC559AD : Step 1)
SQLAgent - TSQL JobStep (Job 0x2341709FE370794A8ADB17555EC559AD : Step 1)
SQLAgent - TSQL JobStep (Job 0x866C9C144DD86B408D718BDE66C769B0 : Step 1)
6113F474-F29A-49EF-A4B2-633F55896821
SQLAgent - TSQL JobStep (Job 0xFF9F99A63F3D204DA7991A1288DDECD2 : Step 2)
select * from msdb.dbo.sysjobs where name ='_TTD-UpdateAdGroupPotentialSpendDailyRollup_AWS'

SQLAgent - TSQL JobStep (Job 0x835207F84371CE45A31EF33FF8B73599 : Step 1)
SQLAgent - TSQL JobStep (Job 0x6126692CFBB0AB4BB0B6CFECF297CA30 : Step 1)
Job: _TTD-Get-Third-Party-Data-Rates-For-Providers, Step 
**/
--sp_helptext 'sp_WhoIsActive'

SELECT  
GETDATE() AS [currentTime],
r.start_time,
CAST(DATEDIFF(SECOND,r.start_time,GETDATE())/60.0 AS DECIMAL(19,2)) AS Duration_Minutes,
CASE WHEN r.transaction_isolation_level= 0 THEN 'Unspecified'
	WHEN r.transaction_isolation_level=1 THEN 'ReadUncommitted'
	WHEN r.transaction_isolation_level=2 THEN 'ReadCommitted'
	WHEN r.transaction_isolation_level=3 THEN 'RepeatableRead'
	WHEN r.transaction_isolation_level=4 THEN 'Serializable'
	WHEN r.transaction_isolation_level=5 THEN 'Snapshot'
	END AS transaction_isolation_level,
		r.session_id,
		blocking_session_id, 
		ES.program_name,
		ES.login_name,
		ES.host_name,
		DB_NAME(r.database_id) [dbname],
		r.reads,
		r.writes,
		r.logical_reads,
		command,		
		sqltxt.[text], last_wait_type, wait_type--, *	
FROM    sys.dm_exec_requests r WITH(NOLOCK)
        CROSS APPLY sys.dm_exec_sql_text(sql_handle) sqltxt
		LEFT JOIN sys.dm_exec_sessions ES
			ON ES.session_id = r.session_id
WHERE --r.session_id>50
	r.session_id <> @@SPID
--AND transaction_isolation_level NOT IN (2)
ORDER BY r.start_time ASC
OPTION(MAXDOP 1)
GO

/**

xp_readerrorlog

--Get Nonactive requests
SELECT DISTINCT EC.session_id, ST.text
FROM sys.dm_exec_requests AS ER
JOIN sys.dm_exec_connections AS EC
ON ER.blocking_session_id = EC.session_id
CROSS APPLY sys.dm_exec_sql_text(EC.most_recent_sql_handle) AS ST
OPTION(MAXDOP 1)
GO
--Check for open transactions
Select session_id, open_transaction_count
From sys.dm_exec_sessions
where open_transaction_count>0
OPTION(MAXDOP 1)
GO

-- Get query plan for the Active Query
Select ER.session_id, EQP.query_plan
From sys.dm_exec_requests AS ER
CROSS APPLY sys.dm_exec_query_plan(ER.plan_handle) AS EQP
Where NOT ER.status IN ('background', 'sleeping')
OPTION(MAXDOP 1)
GO

-- get Count of all ACtive SqlServer Wait Types
Select COALESCE(wait_type, 'None') As Wait_Type, count(*) AS Total
From sys.dm_exec_requests AS ER
Where NOT status IN ('Background', 'Sleeping')
Group By wait_type
Order By Total Desc
OPTION(MAXDOP 1)
GO

-- If there are large number of Lock wait types. Find what locks these active requests were trying to obtain
Select L.request_session_id, L.resource_type, L.resource_subtype, L.request_mode, L.request_type
From sys.dm_tran_locks AS L
JOIN sys.dm_exec_requests AS ER
ON L.request_session_id = ER.session_id
WHERE ER.wait_type = 'LCK_M_S'
OPTION(MAXDOP 1)
GO

-- Troubleshooting using SQL Wait stats in SQL Server
-- Processes that are in the suspended state
-- User queries, internal processes are ignored
SELECT
owt.session_id,
owt.exec_context_id,
owt.wait_duration_ms,
owt.wait_type,
owt.blocking_session_id,
owt.resource_description,
est.text,
es.program_name,
eqp.query_plan,
es.cpu_time,
es.memory_usage
FROM
sys.dm_os_waiting_tasks owt
INNER JOIN sys.dm_exec_sessions es WITH(NOLOCK) ON 
owt.session_id = es.session_id
INNER JOIN sys.dm_exec_requests er WITH(NOLOCK)
ON es.session_id = er.session_id
OUTER APPLY sys.dm_exec_sql_text (er.sql_handle) est
OUTER APPLY sys.dm_exec_query_plan (er.plan_handle) eqp
WHERE es.is_user_process = 1
ORDER BY owt.session_id, owt.exec_context_id
OPTION(MAXDOP 1)

--SELECT * FROM  sys.dm_exec_sql_text(0x03000500f326aa0f50a9430028ae000001000000000000000000000000000000000000000000000000000000)
--SELECT * FROM sys.dm_tran_locks

/**
-- Get_BlockingChain
WITH cteBL (session_id, blocking_these) AS 
(SELECT s.session_id, blocking_these = x.blocking_these FROM sys.dm_exec_sessions s 
CROSS APPLY    (SELECT isnull(convert(varchar(6), er.session_id),'') + ', '  
                FROM sys.dm_exec_requests as er
                WHERE er.blocking_session_id = isnull(s.session_id ,0)
                AND er.blocking_session_id <> 0
                FOR XML PATH('') ) AS x (blocking_these)
)
SELECT s.session_id, blocked_by = r.blocking_session_id, bl.blocking_these
, batch_text = t.text, input_buffer = ib.event_info, * 
FROM sys.dm_exec_sessions s 
LEFT OUTER JOIN sys.dm_exec_requests r on r.session_id = s.session_id
INNER JOIN cteBL as bl on s.session_id = bl.session_id
OUTER APPLY sys.dm_exec_sql_text (r.sql_handle) t
OUTER APPLY sys.dm_exec_input_buffer(s.session_id, NULL) AS ib
WHERE blocking_these is not null or r.blocking_session_id > 0
ORDER BY len(bl.blocking_these) desc, r.blocking_session_id desc, r.session_id;


-- Get_BlockingChainV2
WITH cteHead ( session_id,request_id,wait_type,wait_resource,last_wait_type,is_user_process,request_cpu_time
,request_logical_reads,request_reads,request_writes,wait_time,blocking_session_id,memory_usage
,session_cpu_time,session_reads,session_writes,session_logical_reads
,percent_complete,est_completion_time,request_start_time,request_status,command
,plan_handle,sql_handle,statement_start_offset,statement_end_offset,most_recent_sql_handle
,session_status,group_id,query_hash,query_plan_hash) 
AS ( SELECT sess.session_id, req.request_id, LEFT (ISNULL (req.wait_type, ''), 50) AS 'wait_type'
    , LEFT (ISNULL (req.wait_resource, ''), 40) AS 'wait_resource', LEFT (req.last_wait_type, 50) AS 'last_wait_type'
    , sess.is_user_process, req.cpu_time AS 'request_cpu_time', req.logical_reads AS 'request_logical_reads'
    , req.reads AS 'request_reads', req.writes AS 'request_writes', req.wait_time, req.blocking_session_id,sess.memory_usage
    , sess.cpu_time AS 'session_cpu_time', sess.reads AS 'session_reads', sess.writes AS 'session_writes', sess.logical_reads AS 'session_logical_reads'
    , CONVERT (decimal(5,2), req.percent_complete) AS 'percent_complete', req.estimated_completion_time AS 'est_completion_time'
    , req.start_time AS 'request_start_time', LEFT (req.status, 15) AS 'request_status', req.command
    , req.plan_handle, req.[sql_handle], req.statement_start_offset, req.statement_end_offset, conn.most_recent_sql_handle
    , LEFT (sess.status, 15) AS 'session_status', sess.group_id, req.query_hash, req.query_plan_hash
    FROM sys.dm_exec_sessions AS sess
    LEFT OUTER JOIN sys.dm_exec_requests AS req ON sess.session_id = req.session_id
    LEFT OUTER JOIN sys.dm_exec_connections AS conn on conn.session_id = sess.session_id 
    )
, cteBlockingHierarchy (head_blocker_session_id, session_id, blocking_session_id, wait_type, wait_duration_ms,
wait_resource, statement_start_offset, statement_end_offset, plan_handle, sql_handle, most_recent_sql_handle, [Level])
AS ( SELECT head.session_id AS head_blocker_session_id, head.session_id AS session_id, head.blocking_session_id
    , head.wait_type, head.wait_time, head.wait_resource, head.statement_start_offset, head.statement_end_offset
    , head.plan_handle, head.sql_handle, head.most_recent_sql_handle, 0 AS [Level]
    FROM cteHead AS head
    WHERE (head.blocking_session_id IS NULL OR head.blocking_session_id = 0)
    AND head.session_id IN (SELECT DISTINCT blocking_session_id FROM cteHead WHERE blocking_session_id != 0)
    UNION ALL
    SELECT h.head_blocker_session_id, blocked.session_id, blocked.blocking_session_id, blocked.wait_type,
    blocked.wait_time, blocked.wait_resource, h.statement_start_offset, h.statement_end_offset,
    h.plan_handle, h.sql_handle, h.most_recent_sql_handle, [Level] + 1
    FROM cteHead AS blocked
    INNER JOIN cteBlockingHierarchy AS h ON h.session_id = blocked.blocking_session_id and h.session_id!=blocked.session_id --avoid infinite recursion for latch type of blocking
    WHERE h.wait_type COLLATE Latin1_General_BIN NOT IN ('EXCHANGE', 'CXPACKET') or h.wait_type is null
    )
SELECT bh.*, txt.text AS blocker_query_or_most_recent_query 
FROM cteBlockingHierarchy AS bh 
OUTER APPLY sys.dm_exec_sql_text (ISNULL ([sql_handle], most_recent_sql_handle)) AS txt;

-- Get_DBConnections
SELECT   CASE transaction_isolation_level
WHEN 0 THEN 'Unspecified'
WHEN 1 THEN 'ReadUncommitted'
WHEN 2 THEN 'ReadCommitted'
WHEN 3 THEN 'Repeatable'
WHEN 4 THEN 'Serializable'
WHEN 5 THEN 'Snapshot' END AS TRANSACTION_ISOLATION_LEVEL,  
    c.session_id, c.net_transport, c.encrypt_option,   
    c.auth_scheme, s.host_name, s.program_name,   
    s.client_interface_name, s.login_name, s.nt_domain,   
    s.nt_user_name, s.original_login_name, c.connect_time,   
    s.login_time   
FROM sys.dm_exec_connections AS c  
JOIN sys.dm_exec_sessions AS s  
    ON c.session_id = s.session_id  
WHERE 
	--S.transaction_isolation_level<>2
	 c.session_id <> @@SPID;  

	SP_WHOISACTIVE

-- Get DBIndexScanSeek
SELECT DB_NAME(ius.[database_id]) AS [Database],
OBJECT_NAME(ius.[object_id]) AS [TableName],
MAX(ius.[last_user_lookup]) AS [last_user_lookup],
MAX(ius.[last_user_scan]) AS [last_user_scan],
MAX(ius.[last_user_seek]) AS [last_user_seek] 
FROM sys.dm_db_index_usage_stats AS ius
WHERE ius.[database_id] = DB_ID()
--AND ius.[object_id] = OBJECT_ID('YourTableName')
--AND OBJECT_NAME(ius.object_id) LIKE 'PW%'
GROUP BY ius.[database_id], ius.[object_id];


SELECT
OBJECT_NAME(ius.[object_id]) AS [TableName], *
--MAX(ius.[last_user_lookup]) AS [last_user_lookup],
--MAX(ius.[last_user_scan]) AS [last_user_scan],
--MAX(ius.[last_user_seek]) AS [last_user_seek] 
FROM sys.dm_db_index_usage_stats AS ius
WHERE ius.[database_id] = DB_ID()
--AND ius.[object_id] = OBJECT_ID('YourTableName')
--AND OBJECT_NAME(ius.object_id) LIKE 'PW%'
--GROUP BY ius.[database_id], ius.[object_id];
AND last_user_lookup is not null
	and user_seeks > 50000
	and user_lookups > 50000
ORDER BY user_seeks DESC


--Get Database isolation level
SELECT CASE transaction_isolation_level
WHEN 0 THEN 'Unspecified'
WHEN 1 THEN 'ReadUncommitted'
WHEN 2 THEN 'ReadCommitted'
WHEN 3 THEN 'Repeatable'
WHEN 4 THEN 'Serializable'
WHEN 5 THEN 'Snapshot' END AS TRANSACTION_ISOLATION_LEVEL, *
FROM sys.dm_exec_sessions
WHERE session_id>50
	AND transaction_isolation_level<>2
--WHERE session_id = @@SPID


-- Get_IsolationLevel
SELECT   CASE transaction_isolation_level
WHEN 0 THEN 'Unspecified'
WHEN 1 THEN 'ReadUncommitted'
WHEN 2 THEN 'ReadCommitted'
WHEN 3 THEN 'Repeatable'
WHEN 4 THEN 'Serializable'
WHEN 5 THEN 'Snapshot' END AS TRANSACTION_ISOLATION_LEVEL,  
    c.session_id, c.net_transport, c.encrypt_option,   
    c.auth_scheme, s.host_name, s.program_name,   
    s.client_interface_name, s.login_name, s.nt_domain,   
    s.nt_user_name, s.original_login_name, c.connect_time,   
    s.login_time   
FROM sys.dm_exec_connections AS c  
JOIN sys.dm_exec_sessions AS s  
    ON c.session_id = s.session_id  
WHERE 
	S.transaction_isolation_level<>2
	--c.session_id = @@SPID;  


-- Get_FragPercent
-- 08:30AM -> 
SELECT
B.name AS TableName
,'SET LOCK_TIMEOUT 30000; ALTER INDEX ' + C.name + ' ON ' + b.name + ' REORGANIZE WITH(LOB_COMPACTION = ON)'
,A.avg_fragmentation_in_percent
FROM sys.dm_db_index_physical_stats(DB_ID(),NULL,NULL,NULL,NULL) A
INNER JOIN sys.objects B
ON A.object_id = B.object_id
INNER JOIN sys.indexes C
ON B.object_id = C.object_id AND A.index_id = C.index_id
INNER JOIN sys.partitions D
ON B.object_id = D.object_id AND A.index_id = D.index_id
WHERE C.index_id > 0
AND b.name = 'MYP_InvoiceTemplatePricebook'



--SET LOCK_TIMEOUT 30000; ALTER INDEX IX_MYP_Invoices_ClientBusinessGuid ON dbo.PW_ShiftClientScheduleOfSupportItemLink REORGANIZE WITH(LOB_COMPACTION = ON)


/**

ALTER INDEX PK_MypInvoices ON MYP_Invoices REORGANIZE;
ALTER INDEX IX_MYP_Invoices_ClientBusinessGuid ON MYP_Invoices REORGANIZE;
ALTER INDEX IX_MYP_Invoices_InvoiceNumber_AdviserBusinessId ON MYP_Invoices REORGANIZE;
ALTER INDEX IX_MYP_Invoices_GeniusDefaultSelectFilters ON MYP_Invoices REORGANIZE;
ALTER INDEX UX_MYP_Invoices_AdviserBusinessId_InvoiceNumber ON MYP_Invoices REORGANIZE;


**/

-- Get_StaleStatistics

SELECT sp.stats_id, 
       name, 
       filter_definition, 
       last_updated, 
       rows, 
       rows_sampled, 
       steps, 
       unfiltered_rows, 
       modification_counter
FROM sys.stats AS stat
     CROSS APPLY sys.dm_db_stats_properties(stat.object_id, stat.stats_id) AS sp
WHERE stat.object_id = OBJECT_ID('dbo.GPS_3DSecureCredentials')
ORDER BY Last_Updated
**/

/**

UPDATE STATISTICS dbo.Invoices IX_MYP_Invoices_InvoiceNumber_AdviserBusinessId
UPDATE STATISTICS dbo.Invoices UX_MYP_Invoices_AdviserBusinessId_InvoiceNumber
UPDATE STATISTICS dbo.Invoices IX_MYP_Invoices_GeniusDefaultSelectFilters
UPDATE STATISTICS dbo.Invoices IX_MYP_Invoices_ClientBusinessGuid
UPDATE STATISTICS dbo.Invoices PK_MypInvoices

**/


/*
	Query to confirm the plan in cache
	currently is the clustered index scan
*/
/**
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
GO
SELECT 
	[qs].execution_count, 
	QS.creation_time, -- TIME AT WHICH THE PLAN WAS COMPILED
	[s].[text], 
	[qs].[query_hash], 
	[qs].[query_plan_hash], 
	[cp].[size_in_bytes]/1024 AS [PlanSizeKB], 
	[qp].[query_plan], 
	[qs].[plan_handle]
FROM sys.dm_exec_query_stats AS [qs]
CROSS APPLY sys.dm_exec_query_plan ([qs].[plan_handle]) AS [qp]
CROSS APPLY sys.dm_exec_sql_text([qs].[plan_handle]) AS [s]
INNER JOIN sys.dm_exec_cached_plans AS [cp] 
	ON [qs].[plan_handle] = [cp].[plan_handle]
WHERE [s].[text] LIKE 'Ws_Regenerate_Step1%';
GO
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
GO



SELECT top(100) plan_handle, *
--PC.plan_handle as [Token for Plan]
--,ST.text as [Query in Text Format]
--,QP.query_plan [Plan in XML format, click on it to open]
--,PC.cacheobjtype as [Chached Plan Type]
--,PC.objtype as [Type], *
FROM sys.dm_exec_cached_plans PC
CROSS APPLY sys.dm_exec_sql_text(plan_handle) as ST
CROSS APPLY sys.dm_exec_query_plan(PC.plan_handle) QP
where st.text like '%Ws_Regenerate_Step1%';


SELECT TOP 20
		databases.name,
	dm_exec_sql_text.text AS TSQL_Text,
	dm_exec_query_stats.creation_time, 
	dm_exec_query_stats.execution_count,
	dm_exec_query_stats.total_worker_time AS total_cpu_time,
	dm_exec_query_stats.total_elapsed_time, 
	dm_exec_query_stats.total_logical_reads, 
	dm_exec_query_stats.total_physical_reads, 
	dm_exec_query_plan.query_plan
FROM sys.dm_exec_query_stats 
CROSS APPLY sys.dm_exec_sql_text(dm_exec_query_stats.plan_handle)
CROSS APPLY sys.dm_exec_query_plan(dm_exec_query_stats.plan_handle)
INNER JOIN sys.databases
ON dm_exec_sql_text.dbid = databases.database_id
WHERE dm_exec_sql_text.text LIKE '%Ws_Regenerate_Step1%';
**/

 SELECT qp.query_plan
 FROM sys.dm_exec_procedure_stats AS ps
 CROSS APPLY sys.dm_exec_query_plan(ps.plan_handle) AS qp
 WHERE 
     ps.database_id = DB_ID(N'Alexis')
     AND ps.object_id = OBJECT_ID(N'Ws_Regenerate_Step1');


Select * From sys.dm_exec_procedure_stats ps
where ps.object_id = OBJECT_ID(N'Ws_Regenerate_Step1')

**/
