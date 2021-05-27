use msdb
Go

Select sj.name As [JobName], 
		sj.enabled, 
		sjs.step_id, 
		sjs.step_name
From dbo.sysjobs AS sj
Inner Join dbo.sysjobsteps sjs On sj.job_id = sjs.job_id
Where  ( sjs.step_id = 1 And   sjs.step_name <> 'AG Replica Check')
		And sj.category_id Not In (100,3) -- 3 = Database Maintenance, 100 = SQL Sentry Jobs
		And sj.name Not In ('CommandLog Cleanup',
'Database - Statistics Maintenance',
'DatabaseBackup - SYSTEM_DATABASES - FULL',
'DatabaseBackup - USER_DATABASES - DIFF',
'DatabaseBackup - USER_DATABASES - FULL',
'DatabaseBackup - USER_DATABASES - LOG',
'DatabaseIntegrityCheck - SYSTEM_DATABASES',
'DatabaseIntegrityCheck - USER_DATABASES',
'DBA - Cycle SQL Agent Log',
'DBA - cycle_errorlog',
'DBA - Output File Cleanup',
'DBA - StatisticsMaintenance',
'DBA : Encryption Time Out Alert',
'DBA : Encryption Time Out Alert Runtime Check Job',
'Expired subscription clean up',
'IndexOptimize - USER_DATABASES',
'sp_delete_backuphistory',
'sp_purge_jobhistory',
'syspolicy_purge_history')
Order By sj.name
