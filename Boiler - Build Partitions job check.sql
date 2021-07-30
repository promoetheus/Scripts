--sp_whoisactive

SELECT *
FROM sys.dm_exec_sessions des
WHERE des.status=N'running'
	AND DATEDIFF(MINUTE, des.last_request_start_time,GETDATE()) > 10
		
-- get the job status; is it currently running?
-- if it is running, how long has it been running for?
-- has it been running or timing out for more than 2 MINUTES????
-- if it has been timing out for more than 10 seconds terminate the job / query!!!
-- alerting when 


SELECT s.job_id,
		name, 
		s1.start_execution_date, 
		s1.stop_execution_date
FROM msdb..sysjobs s 
JOIN msdb..sysjobactivity s1 
ON s.job_id=s1.job_id
WHERE s.job_id='393EF6E1-4870-42C7-A730-AE411C1541E6' -- 'Boiler - Build Partitions'
		AND CAST(S1.start_execution_date AS DATE) = CAST(GETDATE() AS DATE)
		AND s1.stop_execution_date IS NULL
		AND DATEDIFF(MINUTE, s1.start_execution_date,getdate()) > 10


		EXEC msdb..sp_stop_job




