--- YOU MUST EXECUTE THE FOLLOWING SCRIPT IN SQLCMD MODE.

/********************************************************

** The following script will add ASPState to the AG

*******************************************************/


:Connect ukdcx-pc-lmum01

USE [master]

GO

ALTER AVAILABILITY GROUP [UKDCX-PC-MUM01AG01]
ADD DATABASE [ASPState];

GO

:Connect ukdcx-pc-lmum01

BACKUP DATABASE [ASPState] TO  DISK = N'\\ukdc2-pc-ddm02-sbs\sqlHCGProdBackup\UKDCX-PC-MUM01\ASPState.bak' WITH  COPY_ONLY, FORMAT, INIT, SKIP, REWIND, NOUNLOAD, COMPRESSION,  STATS = 5

GO

:Connect ukdc2-pc-mum01a

RESTORE DATABASE [ASPState] FROM  DISK = N'\\ukdc2-pc-ddm02-sbs\sqlHCGProdBackup\UKDCX-PC-MUM01\ASPState.bak' WITH  NORECOVERY,  NOUNLOAD,  STATS = 5

GO

:Connect ukdcx-pc-lmum01

BACKUP LOG [ASPState] TO  DISK = N'\\ukdc2-pc-ddm02-sbs\sqlHCGProdBackup\UKDCX-PC-MUM01\ASPState.trn' WITH NOFORMAT, INIT, NOSKIP, REWIND, NOUNLOAD, COMPRESSION,  STATS = 5

GO

:Connect ukdc2-pc-mum01a

RESTORE LOG [ASPState] FROM  DISK = N'\\ukdc2-pc-ddm02-sbs\sqlHCGProdBackup\UKDCX-PC-MUM01\ASPState.trn' WITH  NORECOVERY,  NOUNLOAD,  STATS = 5

GO

:Connect ukdc2-pc-mum01a


-- Wait for the replica to start communicating
begin try
declare @conn bit
declare @count int
declare @replica_id uniqueidentifier 
declare @group_id uniqueidentifier
set @conn = 0
set @count = 30 -- wait for 5 minutes 

if (serverproperty('IsHadrEnabled') = 1)
	and (isnull((select member_state from master.sys.dm_hadr_cluster_members where upper(member_name COLLATE Latin1_General_CI_AS) = upper(cast(serverproperty('ComputerNamePhysicalNetBIOS') as nvarchar(256)) COLLATE Latin1_General_CI_AS)), 0) <> 0)
	and (isnull((select state from master.sys.database_mirroring_endpoints), 1) = 0)
begin
    select @group_id = ags.group_id from master.sys.availability_groups as ags where name = N'UKDCX-PC-MUM01AG01'
	select @replica_id = replicas.replica_id from master.sys.availability_replicas as replicas where upper(replicas.replica_server_name COLLATE Latin1_General_CI_AS) = upper(@@SERVERNAME COLLATE Latin1_General_CI_AS) and group_id = @group_id
	while @conn <> 1 and @count > 0
	begin
		set @conn = isnull((select connected_state from master.sys.dm_hadr_availability_replica_states as states where states.replica_id = @replica_id), 1)
		if @conn = 1
		begin
			-- exit loop when the replica is connected, or if the query cannot find the replica status
			break
		end
		waitfor delay '00:00:10'
		set @count = @count - 1
	end
end
end try
begin catch
	-- If the wait loop fails, do not stop execution of the alter database statement
end catch
ALTER DATABASE [ASPState] SET HADR AVAILABILITY GROUP = [UKDCX-PC-MUM01AG01];

GO


GO


