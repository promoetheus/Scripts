-- YOU MUST EXECUTE THE FOLLOWING SCRIPT IN SQLCMD MODE.

----Disable read-only access for all the secondary replicas
--:Connect ukdc1-oc-sql31b\wpgwdb02


USE[master]

GO

ALTER AVAILABILITY GROUP [WPGWAG02] MODIFY REPLICA ON N'UKDC1-OC-SQL31A\WPGWDB02' WITH (SECONDARY_ROLE(ALLOW_CONNECTIONS = NO))
GO

ALTER AVAILABILITY GROUP [WPGWAG02] MODIFY REPLICA ON N'UKDC1-OC-SQL31B\WPGWDB02' WITH (SECONDARY_ROLE(ALLOW_CONNECTIONS = NO))
GO



--Modify the location of the data and transaction log files on all the replicas
:Connect ukdc1-oc-sql31b\wpgwdb02

 
ALTER DATABASE [Test] MODIFY FILE (NAME='Test',FILENAME='F:\WPGWDB02\Data\Test.mdf') 
go

ALTER DATABASE [Test] MODIFY FILE (NAME='Test_log',FILENAME='H:\WPGWDB02\Log\Test_log.ldf') 

go

 

:Connect ukdc1-oc-sql31a\wpgwdb02
 
ALTER DATABASE [Test] MODIFY FILE (NAME='Test',FILENAME='F:\WPGWDB02\Data\Test.mdf') 
go

ALTER DATABASE [Test] MODIFY FILE (NAME='Test_log',FILENAME='H:\WPGWDB02\Log\Test_log.ldf') 
go


--Perform the failover of AlwaysOn group 
:Connect ukdc1-oc-sql31a\wpgwdb02


ALTER AVAILABILITY GROUP [WPGWAG02] FAILOVER;
GO
 

--Move the physical files (MDF/LDF/NDF) to the new location on all the secondary replicas.
:Connect ukdc1-oc-sql31b\wpgwdb02

 

--Enable XP_CMDSHELL
sp_configure 'show advanced options',1
go
reconfigure
go

sp_configure 'xp_cmdshell',1
go
reconfigure
go

 

--MOVE FILES
xp_cmdshell'move "E:\Test\Test.mdf" F:\WPGWDB02\Data\'
go
xp_cmdshell'move "E:\Test\Test_log.ldf" H:\WPGWDB02\Log\'
go
 


--Disable XP_CMDSHELL
sp_configure 'show advanced options',1
go
reconfigure
go

sp_configure 'xp_cmdshell',0
go
reconfigure
go

 

 
--Initiate the database recovery
:Connect ukdc1-oc-sql31b\wpgwdb02

ALTER DATABASE [Test] SET ONLINE
GO

--Perform the failover of AlwaysOn group back to original node 
:Connect ukdc1-oc-sql31b\wpgwdb02

ALTER AVAILABILITY GROUP [WPGWAG02] FAILOVER;
GO
 

--To fix the file location and resume the synchronization on [UKDC1-OC-SQL31B\WPGWDB02]
:Connect ukdc1-oc-sql31a\wpgwdb02

 

--Enable XP_CMDSHELL
sp_configure 'show advanced options',1
go
reconfigure
go

sp_configure 'xp_cmdshell',1
go
reconfigure
go

 

--MOVE FILES
xp_cmdshell'move "E:\Test\Test.mdf" F:\WPGWDB02\Data\'
go
xp_cmdshell'move "E:\Test\Test_log.ldf" H:\WPGWDB02\Log\'
go
 
 

--Disable XP_CMDSHELL
sp_configure 'show advanced options',1
go
reconfigure
go

sp_configure 'xp_cmdshell',0
go
reconfigure
go

 
:Connect ukdc1-oc-sql31a\wpgwdb02
ALTER DATABASE [Test] SET ONLINE
GO


--Finally enable the read-only access for all the secondary replicas
:Connect ukdc1-oc-sql31b\wpgwdb02


USE[master]
GO
ALTER AVAILABILITY GROUP [WPGWAG02] MODIFY REPLICA ON N'UKDC1-OC-SQL31A\WPGWDB02' WITH (SECONDARY_ROLE(ALLOW_CONNECTIONS = ALL))
GO

ALTER AVAILABILITY GROUP [WPGWAG02] MODIFY REPLICA ON N'UKDC1-OC-SQL31B\WPGWDB02' WITH (SECONDARY_ROLE(ALLOW_CONNECTIONS = ALL))
GO


 
