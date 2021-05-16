USE [msdb]
GO

-- Drop the job 'IndexOptimize - USER_DATABASES' if it exists
Declare @jobid UNIQUEIDENTIFIER

IF EXISTS (SELECT *
			FROM msdb.dbo.sysjobs
			WHERE name  = 'IndexOptimize - USER_DATABASES')
BEGIN 
	SELECT @jobid = job_id
				FROM msdb.dbo.sysjobs
			WHERE name  = 'IndexOptimize - USER_DATABASES'
	
	EXEC msdb.dbo.sp_delete_job @job_id=@jobid, @delete_unused_schedule=1
END 
GO


BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [Database Maintenance]    Script Date: 26/07/2019 16:21:13 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'Database Maintenance' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'Database Maintenance'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'IndexOptimize - USER_DATABASES', 
		@enabled=0, 
		@notify_level_eventlog=2, 
		@notify_level_email=2, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'Source: https://ola.hallengren.com', 
		@category_name=N'Database Maintenance', 
		@owner_login_name=N'sa', 
		@notify_email_operator_name=N'SQL Server DBA', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [IndexOptimize - USER_DATABASES]    Script Date: 26/07/2019 16:21:13 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'IndexOptimize - USER_DATABASES', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=4, 
		@on_success_step_id=2, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXECUTE [DBA_CONFIG].[dbo].[IndexOptimize] 
@Databases = ''USER_DATABASES,-EPACS_ARCHIVE,-DBA_CONFIG'', 
@FragmentationLow = NULL, 
@FragmentationMedium = ''INDEX_REORGANIZE'', 
@FragmentationHigh = ''INDEX_REORGANIZE'', 
@Indexes = ''ALL_INDEXES,-EPACS.dbo.SysQueueNotificationsSOAPLog.IDX_QueueId,-EPACS.dbo.AccountStatement.IDX_StatementId,-EPACS.dbo.AccountStatement.PK_AccountStatement,-EPACS.dbo.InboundExecutionHistory.PK_BIF_IEH,-EPACS.dbo.TransferPostings.PK_TransferPostings,-EPACS.dbo.LogToken.IX_LogToken,-EPACS.dbo.Token_AccountStatement.IX_Token_AccountStatement,-EPACS.dbo.Token_OneClickData.IX_Token_OneClickData_11,-EPACS.dbo.Token_OneClickData.IX_Token_OneClickData_21,-EPACS.dbo.Token_OneClickData.PK_Token_OneClickData1,-EPACS.dbo.Token.PK_Token1'',  
@TimeLimit = 12600, 
@LockTimeout = 300, 
@LogToTable = ''Y'';', 
		@database_name=N'DBA_CONFIG', 
		@output_file_name=N'$(ESCAPE_SQUOTE(SQLLOGDIR))\IndexOptimize_$(ESCAPE_SQUOTE(JOBID))_$(ESCAPE_SQUOTE(STEPID))_$(ESCAPE_SQUOTE(STRTDT))_$(ESCAPE_SQUOTE(STRTTM)).txt', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [StatisticsUpdate - USER_DATABASES]    Script Date: 26/07/2019 16:21:13 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'StatisticsUpdate - USER_DATABASES', 
		@step_id=2, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'Declare @jobname Sysname, @jobid Uniqueidentifier, @rc Int = 1;
Set @jobname = ''StatisticsUpdate - USER_DATABASES''
Select @jobid = job_id From msdb.dbo.sysjobs where [name] = @jobname and [enabled] =1;

IF @rc =1 
Begin 
	EXEC msdb.dbo.sp_start_job  @job_id = @jobid;
End', 
		@database_name=N'msdb', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'Daily_0000', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20150306, 
		@active_end_date=99991231, 
		@active_start_time=20000, 
		@active_end_time=235959, 
		@schedule_uid=N'3bdafe07-ea82-4029-bd8b-684be669e0aa'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:

GO


