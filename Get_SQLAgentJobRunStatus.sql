
SET NOCOUNT ON;
SELECT 
	Name, 
	Enabled, 
	run_date, 
	STUFF(STUFF(RIGHT(REPLICATE('0', 6) +  CAST(b.run_time as varchar(6)), 6), 3, 0, ':'), 6, 0, ':') 'run_time', 
	STUFF(STUFF(STUFF(RIGHT(REPLICATE('0', 8) + CAST(b.run_duration as varchar(8)), 8), 3, 0, ':'), 6, 0, ':'), 9, 0, ':') 'run_duration (DD:HH:MM:SS)  ',
	server
FROM msdb.dbo.sysjobs As a With(NoLock)
INNER JOIN msdb.dbo.sysjobhistory As b With(NoLock)	ON a.job_id = b.job_id
WHERE 
	b.step_id=0 -- '(Job outcome)'
--AND b.run_date = 20190303
AND name NOT LIKE '%Database%' 
AND name NOT LIKE '%IndexOptimize%' 
AND name NOT LIKE 'DBA%'
AND name NOT LIKE '%CommandLog Cleanup%'
AND name NOT LIKE '%syspolicy_purge_history%'
ORDER BY run_duration DESC
--ORDER BY b.run_date ASC, b.run_time ASC;
GO



/**

SELECT a.name,  b.step_name, b.message, b.server,b.run_status, 
	CASE b.run_status WHEN 1 THEN 'Success' 
					WHEN 0 THEN 'Failed' END AS JobStatus,
	b.run_date, b.run_time, -- time 1001 = 1:00AM,
	*
FROM msdb.dbo.sysjobs a
JOIN msdb.dbo.sysjobhistory b
ON a.job_id = b.job_id
WHERE b.step_id=0 
			--AND b.run_date = 20160213 
			--AND b.run_status = 0 -- 0 = failed
			AND a.job_id = 'B35A2362-A4D9-489B-A86C-BD790EABFA23'
ORDER BY b.run_date DESC

SELECT * FROM msdb.dbo.sysjobs WHERE job_id = 'B35A2362-A4D9-489B-A86C-BD790EABFA23'


EXEC sp_whoisactive

**/