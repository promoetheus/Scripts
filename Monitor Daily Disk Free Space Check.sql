USE [msdb]
GO

/****** Object:  Job [Monitor Daily Disk Free Space Check]    Script Date: 03/31/2014 11:58:32 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [Monitor Jobs]    Script Date: 03/31/2014 11:58:32 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'Monitor Jobs' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'Monitor Jobs'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'Monitor Daily Disk Free Space Check', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=2, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'This checks the free space on fixed disks. The results are stored in a table [UTILITY].[dbo].[Disk_Space_History].', 
		@category_name=N'Monitor Jobs', 
		@owner_login_name=N'AscotSa', 
		@notify_email_operator_name=N'ServiceDesk', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Check Free space on all Fixed disks]    Script Date: 03/31/2014 11:58:32 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Check Free space on all Fixed disks', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=3, 
		@on_fail_step_id=0, 
		@retry_attempts=3, 
		@retry_interval=1, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'SET NOCOUNT ON;

-- Check that the Disk space table exists, if not create it
IF NOT EXISTS (SELECT * FROM [UTILITY].[dbo].[sysobjects] WHERE id = object_id(N''[UTILITY]..[Disk_Space_History]'') )

	BEGIN
		--Table does not exist
		CREATE TABLE [UTILITY]..[Disk_Space_History]
			(
			CheckDate SMALLDATETIME DEFAULT GETDATE(),
			ServerName VARCHAR (50) DEFAULT @@servername,
			Drive VARCHAR (100),
			DiskSpace INT
			) ON [PRIMARY];

	END


-- Populate table with free space on fixed disks 
INSERT INTO [UTILITY]..[Disk_Space_History](drive, DiskSpace)
  EXEC master.dbo.xp_fixeddrives;', 
		@database_name=N'master', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'Monitor Daily task - Disk Space Check on Dev_Trans', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=1, 
		@freq_subday_interval=3, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20090908, 
		@active_end_date=99991231, 
		@active_start_time=80000, 
		@active_end_time=235959, 
		@schedule_uid=N'ad0d1952-bf01-454a-99d9-eebfc7b9da45'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:

GO


