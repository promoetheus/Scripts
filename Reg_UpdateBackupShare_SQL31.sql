/**

Notes: The script must be run per instance (3 instances). Ensure the instance is updated in the @key variable in the whole script

**/

-- Implement
DECLARE @BackupDirectory VARCHAR(100) 
EXEC master..xp_regread @rootkey='HKEY_LOCAL_MACHINE', 
@key='SOFTWARE\Microsoft\Microsoft SQL Server\MSSQL12.WPGWDB01\MSSQLServer',  -- SQL Server 2014 : UPDATE FOR EACH INSTANCE BEFORE RUNNING!!
@value_name='BackupDirectory', 
@BackupDirectory=@BackupDirectory OUTPUT 
SELECT @BackupDirectory 



IF  substring( @BackupDirectory,3,18) ='ukdc2-pc-ddm02-sbs'
BEGIN 
 
  SET @BackupDirectory = substring(@backupDirectory,1,2) + 'ukdc1-pc-ddm02-sbs\ukdc1_WPAP_sqlbackups\' + substring(@backupDirectory,44,100)

  SELECT @BackupDirectory

    
 --EXEC  master.. xp_regwrite 
 --     @rootkey = 'HKEY_LOCAL_MACHINE' , 
 --        @key='SOFTWARE\Microsoft\Microsoft SQL Server\MSSQL12.WPGWDB01\MSSQLServer', 
 --     @value_name = 'BackupDirectory' , 
 --     @type = 'REG_SZ' , 
 --     @value = @BackupDirectory
         

         --EXEC sp_configure 'backup compression default', 1 ;  
         --RECONFIGURE WITH OVERRIDE ;  

         --ELECT @@SERVERNAME + ' backup location and compression amended'

END
ELSE 
BEGIN 
       SELECT @@SERVERNAME + ' COULD NOT BE AMENEDED'

END 

  
-- Rollback
-- Rollback

-- \\ukdc1-pm-ddm01\ukdc1_prd_dbbackups

/**
DECLARE @BackupDirectory VARCHAR(100) 
EXEC master..xp_regread @rootkey='HKEY_LOCAL_MACHINE', 
@key='SOFTWARE\Microsoft\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQLServer', 
@value_name='BackupDirectory', 
@BackupDirectory=@BackupDirectory OUTPUT 
SELECT @BackupDirectory 



IF  substring( @BackupDirectory,3,27) ='ukdc2-pc-ddm02-sbsrodBackup' --- when rollback from UKDC2-PC-MIG99!!! Update the script accordingly before executing
BEGIN 
 
       SET @BackupDirectory = substring(@backupDirectory,1,2) + 'ukdc2-pc-ddm02-sbs\sqlHCGProdBackup\' + substring(@backupDirectory,31,100)

       SELECT @BackupDirectory


       EXEC  master.. xp_regwrite 
      @rootkey = 'HKEY_LOCAL_MACHINE' , 
         @key='SOFTWARE\Microsoft\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQLServer', 
      @value_name = 'BackupDirectory' , 
      @type = 'REG_SZ' , 
      @value = @BackupDirectory
       
       
         EXEC sp_configure 'backup compression default', 0 ;  
         RECONFIGURE WITH OVERRIDE ;  

         SELECT @@SERVERNAME + 'backup location and compression amended'

END
ELSE 
BEGIN 
       SELECT @@SERVERNAME + ' COULD NOT BE AMENEDED'

END 

**/