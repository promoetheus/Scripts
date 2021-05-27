/**
Author: Justin Belling
Date: 2018/09/18
Description: - To be Run on EPACS instance
			 - Check whether the index defrag job "(Pro-DBA) Index Defrag" is running, if the job is running the job will be stopped 
			   to allow the dbcc checkdb to run and complete.

**/
Set NoCount On;

Declare @Jobid Uniqueidentifier, @JobName Sysname, @RunDate Varchar(16), @Status Varchar(100), @ErrMsg Nvarchar(200);
Set @JobName = '(Pro-DBA) Index Defrag';
Set @Jobid = (Select job_id From msdb.dbo.sysjobs With(NoLock) Where [name] = @JobName);
Set @RunDate = Convert(Varchar(16),GetDate(),112);

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
End
Else
Begin
	Print 'Job ''' + @JobName + ''' is not running.';
End

-- Verify that the Index Defrag job is in 'Cancelled' state
If Exists (
			SELECT Top(1) 1
			FROM msdb.dbo.sysjobs As a With(NoLock)
			INNER JOIN msdb.dbo.sysjobhistory As b With(NoLock)	ON a.job_id = b.job_id
			WHERE 
				b.step_id=0 -- '(Job outcome)'
			AND b.run_date = @RunDate
			AND a.job_id = @Jobid
			And b.run_status = 3 -- 'Cancelled'
			ORDER BY b.run_date, b.run_time DESC)
Begin 
	Set @ErrMsg = 'The Job ' + @JobName + ' is still running.';
	Raiserror(@ErrMsg,16,1);
End
Else
Begin 
	Print 'Job ''' + @JobName + ''' is not running on verification.';
End