-- Get Log space usage
Declare @DatabaseName Varchar(100);
Set @DatabaseName = 'PaymentTrust';

Select name, recovery_model_desc, log_reuse_wait_desc
From sys.databases
Where name = @DatabaseName;

Select instance_name,
		[Data File(s) Size (KB)] * 1.0 / 1024 [Data File(s) Size (MB)],
		[Log File(s) Size (KB)] * 1.0 / 1024 [Log File(s) Size (MB)],                                                                                                           
		[Log File(s) Used Size (KB)] * 1.0 / 1024 [Log File(s) Used Size (MB)],
		[Percent Log Used] ,
		[log_reuse_wait_desc]                                                                                                             
From ( Select os.counter_name, os.instance_name, os.cntr_value,
			db.log_reuse_wait_desc
		From sys.dm_os_performance_counters os
		Join sys.databases db On os.instance_name = db.name
		Where os.counter_name In
		(
			'Data File(s) Size (KB)',
			'Log File(s) Size (KB)',                                                                                                           
			'Log File(s) Used Size (KB)',                                                                                                      
			'Percent Log Used'                                                                                                                			
		) 
		And os.instance_name = @DatabaseName
) As SourceTable
Pivot (
Max(cntr_value) For counter_name In
	(
			[Data File(s) Size (KB)],
		[Log File(s) Size (KB)],                                                                                                           
			[Log File(s) Used Size (KB)],                                                                                                      
			[Percent Log Used]   
	)) As PivtoTable

/**
sp_whoisActive

use user_rs
go
dbcc opentran

go
sp_who2 704

go

Select * From sys.dm_exec_sessions
Where session_id = spid

xp_readerrorlog 0,1,null,NULL,'2018-08-23 11:00:00','2018-08-24 11:59:59'

dbcc sqlperf(logspace)
Select * from sys.dm_os_performance_counters

use master
go

Select name, log_reuse_wait_desc, * from sys.databases
where name = 'User_RS'
go


use USER_RS
Go

select * From sys.database_files

dbcc shrinkfile('USER_RS_log',565289)
Go

**/