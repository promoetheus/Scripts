Use DBA_CONFIG
Go

If Not Exists (Select 1 From sys.objects Where Type = 'P' and Name = 'JobStatusCheck')
	Exec('Create Procedure dbo.JobStatusCheck As Set NoCount On;')
Go

/**
Author: Justin Belling
Date: 2018/09/18
Description: - Check whether a job is running or has over-run, if the job is running the job will be stopped 
			   to allow the current job to run and complete.

**/
Alter Procedure dbo.JobStatusCheck
(
	@JobName Sysname

)

As

Begin 

Set NoCount On;

Declare @Jobid Uniqueidentifier ;
Declare @RunDate Varchar(16);
Declare @Status Varchar(100);
Declare @ErrMsg Nvarchar(200);
Select @Jobid = job_id From msdb.dbo.sysjobs With(NoLock) Where [name] = @JobName;
Select @RunDate = Convert(Varchar(16),Max(run_requested_date),112) From msdb.dbo.sysjobactivity With(NoLock) Where job_id = @Jobid;

If Exists (
				Select Top(1) 1
				From msdb.dbo.sysjobs As sj With(NoLock)
				Inner join msdb.dbo.sysjobactivity As ja With(NoLock) On ja.job_id = sj.job_id
				Where 
					sj.job_id = @Jobid
				And Convert(Varchar(16),ja.run_requested_date,112) = @RunDate
				And (ja.start_execution_date Is Not Null And ja.stop_execution_date Is Null)
				Order By ja.run_requested_date Desc)
Begin 
	Exec msdb.dbo.sp_stop_job @job_id=@Jobid;
	WaitFor Delay '00:01:00'; -- allow defrag threads to complete/rollback gracefully

			-- Verify that the Index Defrag job is in 'Cancelled' state
		If Not Exists (
							Select Top(1) 1
							From msdb.dbo.sysjobs As a With(NoLock)
							Inner Join msdb.dbo.sysjobhistory As b With(NoLock)	ON a.job_id = b.job_id
							Where 
								b.step_id = 0 -- '(Job outcome)'
							And b.run_date = @RunDate
							And a.job_id = @Jobid
							And b.run_status = 3 -- 'Cancelled'
							Order By b.run_date Desc, b.run_time Desc)
				Begin
					Set @ErrMsg = 'The Job ''' + @JobName + ''' is still Running.';
					Raiserror(@ErrMsg,16,1); 	
				End
				Else
				Begin 
					Print 'Job ''' + @JobName + ''' has been Cancelled.';
				End
		End
Else
Begin
	Print 'Job ''' + @JobName + ''' is not Running.';
End
End