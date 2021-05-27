-- SQL2008 GET MIRROR STATE
SELECT db.name, db.state_desc,dm.mirroring_state_desc, dm.mirroring_role_desc, *
FROM sys.databases db WITH (NOLOCK)
JOIN sys.database_mirroring dm WITH (NOLOCK)
ON db.database_id = dm.database_id
WHERE dm.mirroring_role_desc IS NOT NULL
	And db.name = 'AutoRek5WorldPay'
	
-- 2.To verify the results of the failover on the new mirror, execute the following query:
SELECT db.name, m.mirroring_role_desc   
FROM sys.database_mirroring m   
JOIN sys.databases db  
ON db.database_id = m.database_id  
WHERE db.name = N'AutoRek5WorldPay';   
GO  

-- Get how far behind is mirroring
EXEC msdb..sp_dbmmonitorresults 'AutoRek5WorldPay',1,1

