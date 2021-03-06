USE msdb
GO

BEGIN TRAN

DECLARE @TotalJobs INT
DECLARE @Min INT
DECLARE @ReturnCode INT
DECLARE @MinJobStep_id INT
DECLARE @NextStep_id INT
DECLARE @Job_id NVARCHAR(500)
DECLARE @JobName NVARCHAR(500)


--Setting the values in variables

SET @ReturnCode = 0
SET @Min = 1


--Declaring table variable
DECLARE @JobTable TABLE  ----------------------Select from Here
(ID INT IDENTITY(1,1),
Job_id  nvarchar(500),
JobName NVARCHAR(500) )


--Get all the required jobs
--Exclude specific jobs 
--SELECT [name], * FROM msdb.dbo.sysjobs AS s ORDER BY s.[name]

INSERT INTO @JobTable 
SELECT job_id, name FROM sysjobs 
WHERE NAME  NOT IN ('CommandLog Cleanup',
'Database - Statistics Maintenance',
'DatabaseBackup - SYSTEM_DATABASES - FULL',
'DatabaseBackup - USER_DATABASES - DIFF',
'DatabaseBackup - USER_DATABASES - FULL',
'DatabaseBackup - USER_DATABASES - LOG',
'DatabaseIntegrityCheck - SYSTEM_DATABASES',
'DatabaseIntegrityCheck - USER_DATABASES',
'DBA - Cycle SQL Agent Log',
'DBA - cycle_errorlog',
'DBA - Output File Cleanup',
'DBA - StatisticsMaintenance',
'DBA : Encryption Time Out Alert',
'DBA : Encryption Time Out Alert Runtime Check Job',
'Expired subscription clean up',
'IndexOptimize - USER_DATABASES',
'sp_delete_backuphistory',
'sp_purge_jobhistory',
'syspolicy_purge_history')

---select * from @JobTable ----------------------To Here to view what jobs will be affected



-- Total count of the job
SELECT @TotalJobs = @@ROWCOUNT

WHILE @TotalJobs >= @Min
BEGIN

              SELECT @Job_id = job_id, @JobName = JobName 
              FROM @JobTable 
              WHERE ID = @Min
              
              SELECT  @MinJobStep_id = MIN(Step_id) 
              FROM sysjobsteps 
              WHERE job_id =  @Job_id


              IF NOT EXISTS (SELECT 1 FROM dbo.sysjobsteps WHERE job_id = @Job_id AND step_name  = 'AG Replica Check')

              BEGIN
                           EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@Job_id, @step_name = N'AG Replica Check', 
                                                @step_id = 1, 
                                                @cmdexec_success_code=0, 
                                                @on_success_action=3, 
                                                @on_success_step_id=0, 
                                                @on_fail_action=2, 
                                                @on_fail_step_id=0, 
                                                @retry_attempts=0, 
                                                @retry_interval=0, 
                                                @os_run_priority=0, @subsystem=N'TSQL', 
                                                @command= N'EXEC [dbo].[AG_StopJobOnNonPrimaryReplica] $(ESCAPE_NONE(JOBID));', 
                                                @database_name=N'DBA_CONFIG', 
                                                @flags=0
                                                

                           IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback 

              END

              SET @Job_id = NULL
              SET @MinJobStep_id = NULL
              SET @NextStep_id = NULL
              SET @Min = @Min + 1

END

COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:

