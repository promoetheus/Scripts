-- Update sql agent job schedule
-- Specify job/s

DECLARE @jobid UNIQUEIDENTIFIER, @Sched_id INT

SELECT @jobid =  sysj.job_id, @Sched_id = syss.schedule_id
FROM msdb.dbo.sysjobs sysj
JOIN msdb.dbo.sysjobschedules syss ON sysj.job_id = syss.job_id
WHERE sysj.name = 'DeleteFromPTT'

EXEC  msdb.dbo.sp_attach_schedule @job_id = @jobid, @Schedule_id = @Sched_id
GO
USE [msdb]
GO

DECLARE @jobid UNIQUEIDENTIFIER, @Sched_id INT

SELECT @jobid =  sysj.job_id, @Sched_id = syss.schedule_id
FROM msdb.dbo.sysjobs sysj
JOIN msdb.dbo.sysjobschedules syss ON sysj.job_id = syss.job_id
WHERE sysj.name = 'DeleteFromPTT'

EXEC msdb.dbo.sp_update_schedule @schedule_id= @Sched_id,
	@active_start_time=700
GO


-- Verify update schedule
SELECT sysj.job_id, sysj.name, syss.schedule_id, syss.next_run_date, syss.next_run_time
FROM msdb.dbo.sysjobs sysj
JOIN msdb.dbo.sysjobschedules syss ON sysj.job_id = syss.job_id
WHERE sysj.name = 'DeleteFromPTT'