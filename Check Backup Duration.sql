-- get backup status
SELECT TOP 1000
	bs.database_name
	, bm.physical_device_name
	, CAST(CAST(bs.backup_size/1000000 AS INT) AS VARCHAR(14)) AS bksize_MB
	, bs.backup_start_date
	, bs.backup_finish_date
	, DATEDIFF(MINUTE, bs.backup_start_date, bs.backup_finish_date) bkupduration_Minute
	, bs.first_lsn
	, bs.last_lsn
	, CASE bs.type
		WHEN 'L' THEN 'Transaction'
		WHEN 'D' THEN 'Differential'
		WHEN 'F' THEN 'Full'
		END AS 'backup_type'
FROM msdb.dbo.backupset bs
	INNER JOIN msdb.dbo.backupmediafamily bm
	ON bs.media_set_id=bm.media_set_id
--WHERE bs.database_name = 'USER_SCRATCH'
WHERE physical_device_name like '%full%' -- get the full backup completion
AND CAST(backup_start_date AS DATE) = '20160106'
ORDER BY bs.backup_start_date DESC
