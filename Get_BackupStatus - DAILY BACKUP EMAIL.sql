SELECT DatabaseName 
		, Command
		, CommandType
		, StartTime
		, EndTime
FROM DBA_CONFIG.dbo.commandlog
WHERE (StartTime is not null) and (endtime is null)
		AND cast(StartTime as date) = '2016-03-24'
		AND CommandType IN ( 'BACKUP_DATABASE', 'RESTORE_VERIFYONLY')
ORDER BY 1 DESC


SQC03
 -- running VERIFY on db LcsCDR

 SQC08
 -- running VERIFY on db Archer_Prod