Declare @ErrorlogValue Int; -- 0 = current, 1 = Archive #1, 2 = Archive #2, etc...
Declare @LogFileType Int; -- 1 or NULL = error log, 2 = SQL Agent log
Declare @SrchString1 Nvarchar(400);
Declare @SrchString2 Nvarchar(400);
Declare @StartDt Varchar(16);
Declare @EndDt Varchar(16);
Declare @SortOrder Char(4);
Set @ErrorlogValue = 0;
Set @LogFileType = 1;
Set @SrchString1 = Null --'Error';
Set @SrchString2 = Null;
Set @StartDt =  Convert(Varchar,Replace(Cast(GetDate()-3 as Date),'-',''),121);
Set @EndDt = Convert(Varchar,Replace(DateAdd(Day,1,Cast(GetDate() as Date)),'-',''),121);
Set @SortOrder = 'ASc';

Exec master.dbo.xp_readerrorlog 
	@ErrorLogValue, 
	@LogFileType, 
	@SrchString1, 
	@SrchString2, 
	@StartDt, 
	@EndDt, 
	@SortOrder;

Go


sp_configure;

sp_whoisactive @get_plans=1;
Go

select * from sys.dm_os_sys_info

Select * from sys.dm_exec_connections
Select * from sys.dm_exec_sessions
Select * From sys.sysprocesses


sp_who2 
go

dbcc tracestatus

Select log_reuse_wait_desc, * from sys.databases



Select sqlserver_start_time, * 
From sys.dm_os_sys_info


--Select * from sys.dm_os_waiting_tasks
select count(*) from post16.dbo.InstTargetQueue with(nolock)
go

SELECT TOP(10) cast(MsgContent as nvarchar(max)) As msgcontent, *
FROM POST16.dbo.ErrorLog
Order BY ErrorLogId DESC
go

Select * From post16.sys.transmission_queue
where message_type_name not in ( 'AGFailOverRequest', 'PingResponse', 'PingRequest')
order by enqueue_time asc
go

Select state_desc, Count(*)
From post16.sys.conversation_endpoints
group by state_desc

dbcc sqlperf(logspace)

