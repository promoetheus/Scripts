-- Written by Justin Belling 
-- Date: 2018-08-03
-- Set Auto Update Statistics Asynchronous Statistics ON for User databases > 1TB
-- Auto Update Statistics MUST be ON when Auto Update Statistics Asynchronously db option is ON
-- If the Auto Update Statistics option is not ON; Auto Update Statistics Asynchronously db option will do nothing

-- Get the current status for Auto Update Statistics AND Auto Update Statistics Asynchronously db option
Set NoCount On;
Declare @dbName varchar(100), 
		@AutoUpdateStats bit,
		@AutoUpdateStatsAsync bit,
		@sql nvarchar(max);
Declare @err nvarchar(max) = Null;
Declare @msg Nvarchar(max);


Declare DBStatistics Cursor Fast_Forward For
Select DB_NAME(mf.database_id) As DBName, is_auto_update_stats_on,
						is_auto_update_stats_async_on
from sys.master_files As mf
Join sys.databases As db On mf.database_id=db.database_id
Where mf.database_id > 4
	And DB_NAME(mf.database_id) NOT IN ('DBA_CONFIG', 'SSISDB', 'ProDBA')
	And is_auto_update_stats_async_on=0
Group By mf.database_id, is_auto_update_stats_on, is_auto_update_stats_async_on
Having SUM(CAST(mf.size As Bigint)*8/1024) >= (1.0*1024.0*1024.0) 
	;

Open DBStatistics;

Fetch Next From DBStatistics Into @dbName, @AutoUpdateStats, @AutoUpdateStatsAsync

begin try
While @@FETCH_STATUS=0
	Begin 
			
			If (@AutoUpdateStats=0 And @AutoUpdateStatsAsync=0)
				Begin 
					Set @sql = 'Use master ' +	Char(10)	+
								'Alter Database ' + Quotename (@dbName) + 'Set Auto_Update_Statistics On With No_Wait; ' + char(10) +
								'Alter Database ' + Quotename(@dbName) + ' Set Auto_Update_Statistics_Async On With No_wait; '					
					
					Execute sp_executesql @sql	;
						Print 'Auto_UpdateStats and Auto_UpdateStats_Async have been updated for database: ' + @dbName
				End 
			
			If (@AutoUpdateStats=1 And @AutoUpdateStatsAsync=0)
				Begin	
					Set @sql = 'Use master ' +	Char(10)	+
								'Alter Database ' + Quotename(@dbName) + ' Set Auto_Update_Statistics_Async On With No_wait;'
					
					Execute sp_executesql @sql;		
					Print 'Auto_UpdateStats_Async has been updated for database: ' + @dbName
				End

			If (@AutoUpdateStats=0 And @AutoUpdateStatsAsync=1)
				Begin 
					Set @sql = 'Use master ' + char(10) +
								'Alter Database ' + Quotename(@dbname) + 'Set Auto_Update_Statistics On With No_wait;'
					Execute sp_executesql @sql;
						RAISERROR('Cant uppodate sync type',16,1) With NoWait;
						Print 'Auto_UpdateStats has been updated for database: ' + @dbName
				End

			Fetch Next From DBStatistics Into @dbName, @AutoUpdateStats, @AutoUpdateStatsAsync
	End
end try
begin catch 
		Select @err = error_message()
		
		Set @msg = 'Cant update Auto Update Statistics Asynchronous type. Check Replica status.'
		If @err is not null
			RAISERROR(@msg,16,1) With NoWait;
			GOTO Finish;
End catch

If @AutoUpdateStats=1 And @AutoUpdateStatsAsync=1
	Print 'No Statistics to update.'
Finish:
Close DBStatistics;
Deallocate DBStatistics;

