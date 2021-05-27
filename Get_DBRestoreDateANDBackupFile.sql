-- Get the date the database was restored and the backup file used for the db restore
SELECT rh.restore_date
				, destination_database_name
				--, bs.backup_start_date
				--, bs.backup_finish_date
				, bs.server_name
				, physical_device_name
FROM msdb..restorehistory rh
INNER JOIN msdb..backupset bs
ON rh.backup_set_id = bs.backup_set_id
INNER JOIN msdb..backupmediafamily bmf
ON bmf.media_set_id = bs.media_set_id
