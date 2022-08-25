Declare @ErrorlogValue Int; -- 0 = current, 1 = Archive #1, 2 = Archive #2, etc...
Declare @LogFileType Int; -- 1 or NULL = error log, 2 = SQL Agent log
Declare @SrchString1 Nvarchar(400);
Declare @SrchString2 Nvarchar(400);
Declare @StartDt Varchar(16);
Declare @EndDt Varchar(16);
Declare @SortOrder Char(4);
Set @ErrorlogValue =0;
Set @LogFileType = 1;
Set @SrchString1 =  Null--'Failover';
Set @SrchString2 = Null;
Set @StartDt = Convert(Varchar,Replace(Cast(GetDate()-3 as Date),'-',''),121);
Set @EndDt = Convert(Varchar,Replace(DateAdd(Day,1,Cast(GetDate() as Date)),'-',''),121);
Set @SortOrder = 'Asc';
select @StartDt
Select @EndDt

Exec master.dbo.xp_readerrorlog 
	@ErrorLogValue, 
	@LogFileType, 
	@SrchString1, 
	@SrchString2, 
	@StartDt,
	@EndDt, 
	@SortOrder;
Go 

sp_WhoIsActive @get_plans=1;

--sp_who2

Select log_reuse_wait_desc, * from sys.databases

DBCC TRACESTATUS

dbo.PanTokenMapping

Select Top(10) *
From dbo.ws_Call_Log With(NoLock)
Order by Exe_Time ASC

--kill 74

sp_who2 180

dbcc sqlperf(logspace)

sp_spaceused 'dbo.TC46'

sp_who2


Select * From sys.objects where object_id = object_id('##DailyAccBalReport_ZeroBalanceCards')

SELECT ROUTINE_NAME, CREATED, LAST_ALTERED 
FROM INFORMATION_SCHEMA.ROUTINES
ORDER BY LAST_ALTERED DESC


dbo.VISA_VSS
dbo.GenerateCardholderDetailsXML

sp_spaceused 'dbo.Cards'

sp_who2

use Alexis
dbcc opentran;

--dbcc sqlperf(logspace)


use tempdb
go
Select * From sys.sysprocesses
where open_tran=1

select * from sys.dm_exec_sql_text(0x03000500f326aa0ff54c59003fae000001000000000000000000000000000000000000000000000000000000)  


clearing blocked by: SQLAgent - TSQL JobStep (Job 0x83ED5826DB858C4298EFFE0F4E6CA762 : Step 2)

Select * from tempdb.sys.tables AS T where 
T.name LIKE N'%#%'

DBCC SHOW_STATISTICS ('tempdb.dbo.#tmpPresentment_____________________________________________________________________________________________________000000BB6CE2', PANT) 

sELECT OBJECT_ID('tempdb.dbo.tmpPresentment_____________________________________________________________________________________________________000000BB6CE2')
select 

select sp.*From sys.stats s cross apply sys.dm_db_stats_properties(s.object_id,s.stats_id) sp  where s.object_id=-1242610934
**/

--sp_configurec
--sp_helptext 'GPS_EHI_UpdateflSendAllProduct'EXEC sp_WhoIsActive @get_plans=1
GO



use Alexis
GO
DBCC OPENTRAN;

dbcc sqlperf(logspace)

sp_who2

Select top(1000) * From Alexis.dbo.SqlErrorLog (NoLock) Order By 1 DEsc

Select * 
from sys.availability_replicas Where replica_id='7D080252-914C-4254-9691-E694E0B435F5'

sp_helptext 'InsertFirstPresentmenttoTransaction '

SELECT COL_LENGTH('GPS_EHI_GETDATA', 'Phone') As 'Varchar'

--sp_spaceused 'EhiLineup'

--exec msdb.dbo.sp_start_job 'Cleanupws_GiftCard_WebService_Call_Log'

-->> sELECT 1796365 - 1788173
xp_fixeddrives


-- SQL Agent job is running:
--ReadONLYGenerateCardholderXMLReport

--Select top(1) * From dbo.[Transaction] With(Nolock)
--Select top(1) * From dbo.[Transaction_int] With(Nolock)




--EXEC sp_configure 'show advanced options',1
--RECONFIGURE
--GO

--EXEC sp_configure 'blocked process threshold (s)',30
--RECONFIGURE WITH OVERRIDE
--GO

--EXEC sp_configure 'show advanced options',0
--RECONFIGURE
--GO



-- PW_ShiftClientScheduleOfSupportItemLink

EXEC xp_fixeddrives
GO

SELECT * FROM sys.dm_tran_locks

--@TimeLimit = 3600,
--@LockTimeout = 300,
/**
24126

EXEC [dbo].[spPW_GetRequests_v2] 
	@TriggeredTime = '2021-04-18 12:00:00.000', 
	@RequestGroupGuid = '1A6D75C9-81BB-4CF3-87B5-C24F91C7B3B2';

sp_helptext 'fn_MYP_StaffHistory'


declare	@SurveyTypeId int =300, 
    @ClientGuid uniqueidentifier ='C656190C-AEF1-E611-8101-8E0A2F57385C',
    @StrategyQuestionId int = 5000


**/

SP_WHO

sp_who2 28

dbcc tracestatus

EXEC sp_renamedb '190521', '190524'

Select log_reuse_wait_desc, * from sys.databases

dbcc opentran

Select sqlserver_start_time, * 
From sys.dm_os_sys_info

--Select * from sys.dm_os_waiting_tasks


dbcc sqlperf(logspace)


--sp_helptext 'ORS_Std_Seg_Int'
--go

--xp_fixeddrives

select recovery_model_desc, *
 from sys.databases 
 where database_id > 4
 order by 1

