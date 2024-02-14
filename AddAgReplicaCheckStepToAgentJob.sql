USE [DBAdmin]
GO

/****** Object:  StoredProcedure [dbo].[AddAGReplicaCheckStepToAgentJob]    Script Date: 14/02/2024 05:06:30 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- Adds a first step to specified job, which checks whether running on Primary replica
CREATE PROCEDURE [dbo].[AddAGReplicaCheckStepToAgentJob]
    @jobname NVARCHAR(128)
as

SET NOCOUNT ON;

-- Do nothing if No AG groups defined
IF SERVERPROPERTY ('IsHadrEnabled') = 1
begin
    declare @jobid uniqueidentifier = (select sj.job_id from msdb.dbo.sysjobs sj where sj.name = @jobname)

    if not exists(select * from msdb.dbo.sysjobsteps where job_id = @jobid and step_name = 'Check If AG Primary' )
    begin
        -- Add new first step: on success go to next step, on failure quit reporting success
        exec msdb.dbo.sp_add_jobstep 
          @job_id = @jobid
        , @step_id = 1
        , @cmdexec_success_code = 0
        , @step_name = 'Should It Run'
        , @on_success_action = 3  -- On success, go to Next Step
        , @on_success_step_id = 2
        , @on_fail_action = 1     -- On failure, Quit with Success  
        , @on_fail_step_id = 0
        , @retry_attempts = 0
        , @retry_interval = 0
        , @os_run_priority = 0
        , @subsystem = N'TSQL'
        , @command=N'DECLARE	@NodeRole varchar(50)

EXEC	[dbo].[NodeRole] @NodeRole = @NodeRole OUTPUT

IF	@NodeRole = ''PRIMARY''
	BEGIN
	PRINT ''Run''
	END
ELSE IF @NodeRole = ''RESTRICTED''
	BEGIN
	PRINT ''Dont run''
	RAISERROR (''Restricted dont run'', 16,1)
	END
ELSE
	BEGIN
	PRINT ''DontRun2''
	RAISERROR (''Secondary dont run'', 16,1)
	END'
        , @database_name=N'DBAdmin'
        , @flags=0
    end
end
GO
