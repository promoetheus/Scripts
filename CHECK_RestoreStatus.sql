use MSDB;
GO


select bmf.physical_Device_name, rh.restore_date
from backupmediafamily bmf, backupset bs, restorehistory rh
where bmf.media_set_id =bs.media_set_id
and bs.backup_set_id = rh.backup_set_id
order by rh.restore_date desc