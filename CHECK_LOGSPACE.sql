declare @logspace as table ([dbname] nvarchar(100), [logsize] decimal(18,9), [logspaceused] decimal(18,9), [status] decimal (18,9))

insert into @logspace (dbname, logsize, logspaceused, status)
exec ('dbcc sqlperf(logspace)')

select dbname, logspaceused
from @logspace
where dbname = 'JustinTest' and logspaceused > 5

IF @@ROWCOUNT > 0
	BEGIN 
		PRINT '<do some work here>'
	END





