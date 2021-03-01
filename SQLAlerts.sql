USE [msdb]
GO

/****** Object:  Alert [(Pro-DBA) Buffer Cache Hits]    Script Date: 18/12/2020 12:44:17 ******/
EXEC msdb.dbo.sp_add_alert @name=N'(Pro-DBA) Buffer Cache Hits', 
		@message_id=0, 
		@severity=0, 
		@enabled=1, 
		@delay_between_responses=300, 
		@include_event_description_in=1, 
		@category_name=N'[Uncategorized]', 
		@performance_condition=N'SQLServer:Buffer Manager|Buffer cache hit ratio||<|0.9', 
		@job_id=N'0b32b84a-250e-4c25-b48f-384a7c1490ea'
GO

/****** Object:  Alert [(ProDBA) Dead Locks]    Script Date: 18/12/2020 12:44:17 ******/
EXEC msdb.dbo.sp_add_alert @name=N'(ProDBA) Dead Locks', 
		@message_id=0, 
		@severity=0, 
		@enabled=1, 
		@delay_between_responses=300, 
		@include_event_description_in=1, 
		@category_name=N'[Uncategorized]', 
		@performance_condition=N'SQLServer:Locks|Number of Deadlocks/sec|_Total|>|1', 
		@job_id=N'0b32b84a-250e-4c25-b48f-384a7c1490ea'
GO

/****** Object:  Alert [(ProDBA) Page Life]    Script Date: 18/12/2020 12:44:17 ******/
EXEC msdb.dbo.sp_add_alert @name=N'(ProDBA) Page Life', 
		@message_id=0, 
		@severity=0, 
		@enabled=1, 
		@delay_between_responses=3600, 
		@include_event_description_in=1, 
		@category_name=N'[Uncategorized]', 
		@performance_condition=N'SQLServer:Buffer Manager|Page life expectancy||<|300', 
		@job_id=N'0b32b84a-250e-4c25-b48f-384a7c1490ea'
GO

/****** Object:  Alert [(Pro-DBA) Plan Cache Hit Ratio]    Script Date: 18/12/2020 12:44:17 ******/
EXEC msdb.dbo.sp_add_alert @name=N'(Pro-DBA) Plan Cache Hit Ratio', 
		@message_id=0, 
		@severity=0, 
		@enabled=0, 
		@delay_between_responses=300, 
		@include_event_description_in=1, 
		@category_name=N'[Uncategorized]', 
		@performance_condition=N'SQLServer:Plan Cache|Cache Hit Ratio|_Total|<|0.8', 
		@job_id=N'0b32b84a-250e-4c25-b48f-384a7c1490ea'
GO

/****** Object:  Alert [(Pro-DBA) Severity 24]    Script Date: 18/12/2020 12:44:17 ******/
EXEC msdb.dbo.sp_add_alert @name=N'(Pro-DBA) Severity 24', 
		@message_id=0, 
		@severity=1, 
		@enabled=1, 
		@delay_between_responses=300, 
		@include_event_description_in=1, 
		@category_name=N'[Uncategorized]', 
		@job_id=N'0b32b84a-250e-4c25-b48f-384a7c1490ea'
GO

/****** Object:  Alert [Backup Failure - 18204]    Script Date: 18/12/2020 12:44:17 ******/
EXEC msdb.dbo.sp_add_alert @name=N'Backup Failure - 18204', 
		@message_id=18204, 
		@severity=0, 
		@enabled=1, 
		@delay_between_responses=3600, 
		@include_event_description_in=1, 
		@category_name=N'[Uncategorized]', 
		@job_id=N'0b32b84a-250e-4c25-b48f-384a7c1490ea'
GO

/****** Object:  Alert [Backup Failure - 18210]    Script Date: 18/12/2020 12:44:17 ******/
EXEC msdb.dbo.sp_add_alert @name=N'Backup Failure - 18210', 
		@message_id=18210, 
		@severity=0, 
		@enabled=1, 
		@delay_between_responses=3600, 
		@include_event_description_in=1, 
		@category_name=N'[Uncategorized]', 
		@job_id=N'0b32b84a-250e-4c25-b48f-384a7c1490ea'
GO

/****** Object:  Alert [Backup Failure - 3041]    Script Date: 18/12/2020 12:44:17 ******/
EXEC msdb.dbo.sp_add_alert @name=N'Backup Failure - 3041', 
		@message_id=3041, 
		@severity=0, 
		@enabled=1, 
		@delay_between_responses=3600, 
		@include_event_description_in=1, 
		@category_name=N'[Uncategorized]', 
		@job_id=N'0b32b84a-250e-4c25-b48f-384a7c1490ea'
GO

/****** Object:  Alert [Backup Failure - 3201]    Script Date: 18/12/2020 12:44:17 ******/
EXEC msdb.dbo.sp_add_alert @name=N'Backup Failure - 3201', 
		@message_id=3201, 
		@severity=0, 
		@enabled=1, 
		@delay_between_responses=3600, 
		@include_event_description_in=1, 
		@category_name=N'[Uncategorized]', 
		@job_id=N'0b32b84a-250e-4c25-b48f-384a7c1490ea'
GO

/****** Object:  Alert [DiskIOError 823]    Script Date: 18/12/2020 12:44:17 ******/
EXEC msdb.dbo.sp_add_alert @name=N'DiskIOError 823', 
		@message_id=823, 
		@severity=0, 
		@enabled=1, 
		@delay_between_responses=0, 
		@include_event_description_in=0, 
		@category_name=N'[Uncategorized]', 
		@job_id=N'0b32b84a-250e-4c25-b48f-384a7c1490ea'
GO

/****** Object:  Alert [DiskIOError 824]    Script Date: 18/12/2020 12:44:17 ******/
EXEC msdb.dbo.sp_add_alert @name=N'DiskIOError 824', 
		@message_id=824, 
		@severity=0, 
		@enabled=1, 
		@delay_between_responses=0, 
		@include_event_description_in=0, 
		@category_name=N'[Uncategorized]', 
		@job_id=N'0b32b84a-250e-4c25-b48f-384a7c1490ea'
GO

/****** Object:  Alert [DiskIOError 825]    Script Date: 18/12/2020 12:44:17 ******/
EXEC msdb.dbo.sp_add_alert @name=N'DiskIOError 825', 
		@message_id=825, 
		@severity=0, 
		@enabled=1, 
		@delay_between_responses=0, 
		@include_event_description_in=0, 
		@category_name=N'[Uncategorized]', 
		@job_id=N'0b32b84a-250e-4c25-b48f-384a7c1490ea'
GO

/****** Object:  Alert [Sev17]    Script Date: 18/12/2020 12:44:17 ******/
EXEC msdb.dbo.sp_add_alert @name=N'Sev17', 
		@message_id=0, 
		@severity=17, 
		@enabled=1, 
		@delay_between_responses=0, 
		@include_event_description_in=1, 
		@notification_message=N'Severity Level 17 - Insufficient Resources', 
		@category_name=N'[Uncategorized]', 
		@job_id=N'0b32b84a-250e-4c25-b48f-384a7c1490ea'
GO

/****** Object:  Alert [Sev18]    Script Date: 18/12/2020 12:44:17 ******/
EXEC msdb.dbo.sp_add_alert @name=N'Sev18', 
		@message_id=0, 
		@severity=18, 
		@enabled=1, 
		@delay_between_responses=0, 
		@include_event_description_in=1, 
		@notification_message=N'Severity Level 18 - Internal Non-Fatal Error', 
		@category_name=N'[Uncategorized]', 
		@job_id=N'0b32b84a-250e-4c25-b48f-384a7c1490ea'
GO

/****** Object:  Alert [Sev19]    Script Date: 18/12/2020 12:44:17 ******/
EXEC msdb.dbo.sp_add_alert @name=N'Sev19', 
		@message_id=0, 
		@severity=19, 
		@enabled=1, 
		@delay_between_responses=0, 
		@include_event_description_in=1, 
		@notification_message=N'Severity Level 19 - Fatal Error in Resource', 
		@category_name=N'[Uncategorized]', 
		@job_id=N'0b32b84a-250e-4c25-b48f-384a7c1490ea'
GO

/****** Object:  Alert [Sev20]    Script Date: 18/12/2020 12:44:17 ******/
EXEC msdb.dbo.sp_add_alert @name=N'Sev20', 
		@message_id=0, 
		@severity=20, 
		@enabled=1, 
		@delay_between_responses=0, 
		@include_event_description_in=1, 
		@notification_message=N'Severity Level 20 - Fatal Error in Current Process', 
		@category_name=N'[Uncategorized]', 
		@job_id=N'00000000-0000-0000-0000-000000000000'
GO

/****** Object:  Alert [Sev21]    Script Date: 18/12/2020 12:44:17 ******/
EXEC msdb.dbo.sp_add_alert @name=N'Sev21', 
		@message_id=0, 
		@severity=21, 
		@enabled=1, 
		@delay_between_responses=0, 
		@include_event_description_in=1, 
		@notification_message=N'Severity Level 21 - Fatal Error in Database Processes', 
		@category_name=N'[Uncategorized]', 
		@job_id=N'0b32b84a-250e-4c25-b48f-384a7c1490ea'
GO

/****** Object:  Alert [Sev22]    Script Date: 18/12/2020 12:44:17 ******/
EXEC msdb.dbo.sp_add_alert @name=N'Sev22', 
		@message_id=0, 
		@severity=22, 
		@enabled=1, 
		@delay_between_responses=0, 
		@include_event_description_in=1, 
		@notification_message=N'Severity Level 22 - Fatal Error - Table Integrity Suspect', 
		@category_name=N'[Uncategorized]', 
		@job_id=N'0b32b84a-250e-4c25-b48f-384a7c1490ea'
GO

/****** Object:  Alert [Sev23]    Script Date: 18/12/2020 12:44:17 ******/
EXEC msdb.dbo.sp_add_alert @name=N'Sev23', 
		@message_id=0, 
		@severity=23, 
		@enabled=1, 
		@delay_between_responses=0, 
		@include_event_description_in=1, 
		@notification_message=N'Severity Level 23 - Database Integrity Suspect', 
		@category_name=N'[Uncategorized]', 
		@job_id=N'0b32b84a-250e-4c25-b48f-384a7c1490ea'
GO

/****** Object:  Alert [Sev24]    Script Date: 18/12/2020 12:44:17 ******/
EXEC msdb.dbo.sp_add_alert @name=N'Sev24', 
		@message_id=0, 
		@severity=24, 
		@enabled=1, 
		@delay_between_responses=0, 
		@include_event_description_in=1, 
		@notification_message=N'Severity Level 24 - Fatal Hardware Error', 
		@category_name=N'[Uncategorized]', 
		@job_id=N'0b32b84a-250e-4c25-b48f-384a7c1490ea'
GO

/****** Object:  Alert [Sev25]    Script Date: 18/12/2020 12:44:17 ******/
EXEC msdb.dbo.sp_add_alert @name=N'Sev25', 
		@message_id=0, 
		@severity=25, 
		@enabled=1, 
		@delay_between_responses=0, 
		@include_event_description_in=1, 
		@notification_message=N'Severity 25 - Fatal Error', 
		@category_name=N'[Uncategorized]', 
		@job_id=N'0b32b84a-250e-4c25-b48f-384a7c1490ea'
GO


