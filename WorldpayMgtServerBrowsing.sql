/**
Runs against: UKDC1-PC-SQC04.mgt.worldpay.local\WPINST04
Dependancies: DBA_CONFIG.dbo.WorldpayMgtServerList
			  DBA_CONFIG.dbo.GetMgtServer

Description: Gets a list of URL's which have been visited from a Mgt server

**/

declare @ip bigint, @servername nvarchar(400), @sql varchar(max), @bcpcmd varchar(4000), @filename nvarchar(800)

set nocount on;
Declare MgtCur Cursor fast_forward for
select wslogdb70.dbo.iptoint(SUBSTRING(IPAddress,1,LEN(IPAddress))) as IPAddress, 
		replace(substring(ServerName,1,charindex('.',ServerName)-1),'-','') as ServerName
from dba_config.dbo.WorldpayMgtServerList 
where ServerName like '%worldpay.local' -- Prod Mgt Servers only!

open MgtCur;

fetch next from MgtCur into @ip, @servername

while @@fetch_status = 0
begin 
	
		set @filename = 'E:\Reports\'+@servername+'.csv'
		--print @filename

		set @bcpcmd =	'bcp "select [user_id], user_login_name, category, url_id, port, sourceServerIPAddress, DestinationIPAddress, SourceIPAddress, ServerName, hits, bytes_received, full_url, browse_time from DBA_CONFIG.dbo.GetMgtServer where source_ip_int = '+ CONVERT(VARCHAR(20),@ip) + '" queryout '+@filename + ' -S UKDC1-PC-SQC04.MGT.WORLDPAY.LOCAL\WPINST04 -w -t, -Umgtrpt -Pmgtreports2017'
					
			--print @bcpcmd

			exec master..xp_cmdshell @bcpcmd;			
			
			fetch next from MgtCur into @ip, @servername
end

close MgtCur;
deallocate MgtCur;