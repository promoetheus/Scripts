DECLARE @jobname NVARCHAR(128)

SET NOCOUNT ON;

-- Get job name to add first step
SELECT Top 1 @jobname =  t.name
FROM (
SELECT name, count(*) StepCnt
FROM msdb.dbo.sysjobs sj WITH(NOLOCK)
JOIN msdb.dbo.sysjobsteps sjs WITH(NOLOCK)
ON sj.job_id=sjs.job_id
WHERE name LIKE 'Synchro%'
GROUP BY name) as t WHERE  StepCnt < 2
--Select @jobname

If @jobname IS NOT NULL
 begin
	-- Create First Step
	Exec DBAdmin.dbo.AddAGReplicaCheckStepToAgentJob @jobname = @jobname

	-- Validate the Fist Step and the Toal Steps for the Job
	Exec msdb.dbo.sp_help_job	
		@job_name = @jobname;
 end

 if @jobname IS NULL
	PRINT 'Adding First Step completed.'
