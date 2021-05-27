use [master]
go


/** 
http://www.sqlskills.com/blogs/paul/why-is-log_reuse_wait_desc-saying-log_backup-after-doing-a-log-backup/ 

-- column: log_reuse_Wait_desc = the last time log clearing was attempted it had to wait on <whatever> is populated in the column
		-- LOG_BACKUP inidicates 0 VLFs were cleared at the last log backup


https://msdn.microsoft.com/en-gb/library/ms190925(v=sql.120).aspx#FactorsThatDelayTruncation
**/

use tempdb
go
dbcc loginfo

SELECT name, log_reuse_wait, log_reuse_Wait_desc --, *
FROM sys.databases
WHERE name  IN ( N'tempdb', 'boiler')