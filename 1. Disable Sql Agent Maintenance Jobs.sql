/**

Written By: Justin Belling
Desc: This script disables the current Index and Statistics maintenance jobs
Date: 2019-07-26

**/


USE msdb
GO

SET NOCOUNT ON;

IF EXISTS (SELECT * FROM msdb.dbo.sysjobs WHERE name = N'(Pro-DBA) Index Defrag' and enabled=1)
	BEGIN
		EXEC msdb.dbo.sp_update_job @job_name = N'(Pro-DBA) Index Defrag', @enabled = 0
		PRINT '(Pro-DBA) Index Defrag has been disabled.';
	END
GO

IF EXISTS (SELECT * FROM msdb.dbo.sysjobs WHERE name = N'(Pro-DBA) Update Statistics' and enabled=1)
	BEGIN
		EXEC msdb.dbo.sp_update_job @job_name = N'(Pro-DBA) Update Statistics', @enabled = 0
		PRINT '(Pro-DBA) Update Statistics has been disabled.';
	END
GO

IF EXISTS (SELECT * FROM msdb.dbo.sysjobs WHERE name = N'StatisticsMaintenance' and enabled=1)
	BEGIN
		EXEC msdb.dbo.sp_update_job @job_name = N'StatisticsMaintenance', @enabled = 0
		PRINT 'StatisticsMaintenance has been disabled.';
	END
GO

IF EXISTS (SELECT * FROM msdb.dbo.sysjobs WHERE name = N'DBA - StatisticsMaintenance' and enabled=1)
	BEGIN
		EXEC msdb.dbo.sp_update_job @job_name = N'DBA - StatisticsMaintenance', @enabled = 0
		PRINT 'DBA - StatisticsMaintenance has been disabled.';
	END
GO

IF EXISTS (SELECT * FROM msdb.dbo.sysjobs WHERE name = N'Database - Statistics Maintenance' and enabled=1)
	BEGIN
		EXEC msdb.dbo.sp_update_job @job_name = N'Database - Statistics Maintenance', @enabled = 0
		PRINT 'Database - Statistics Maintenance has been disabled.';
	END
GO
