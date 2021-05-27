-- GET THE STATUS OF SQL AGENT JOB OUTCOME - FAILURES???
SELECT TOP (1) j.name AS jobname
	, js.step_name AS stepname
	, jh.message
	, MAX(jh.run_date) AS run_date
	, MAX(jh.run_time) AS run_time
FROM msdb.dbo.sysjobs AS j
inner join msdb.dbo.sysjobsteps AS js ON j.job_id=js.job_id
inner join msdb.dbo.sysjobhistory AS jh ON js.job_id=jh.job_id
WHERE jh.run_status=1 -- failed jobs only (0= failed, 1=succeeded, 2=retry, 3=canceled)
		and j.name like '%DatabaseBackup - USER_DATABASES%LOG%'
GROUP BY j.name, js.step_name, jh.message
ORDER BY run_date desc


