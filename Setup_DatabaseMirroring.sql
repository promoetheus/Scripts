/****DEFINE THE VARIABLES THAT ARE NECESSARY TO SETUP SQL DATABASE MIRRORING***/


:setvar MYDATABASE WPSP2013_SharePoint2_Content_80
:setvar PRINCIPAL UKDC1-PC-SQC06\WPINST06
:setvar MIRROR UKDC2-PC-SQC06\WPINST06
:setvar PEND UKDC1-PC-SQC06
:setvar MEND UKDC2-PC-SQC06
:setvar INSTANCE WPINST06
:setvar DOMAIN worldpay.local
:setvar BACKUPPATH \\ukdc1-pc-sqc06\K$\MSSQL\WPINST06\BACKUP\
:setvar RESTOREPATH \\ukdc2-pc-sqc06\K$\MSSQL\WPINST06\BACKUP\
:setvar COPYPATH \\ukdc2-pc-sqc06\K$\MSSQL\WPINST06\BACKUP\
:setvar PrincipalListenerPort 5040
:setvar MirrorListenerPort 5040
:setvar Timeout 10

SET NOCOUNT ON

GO
 

--1. Create endpoints on principal and mirror

:CONNECT $(PRINCIPAL)


GO

--*** Creating endpoint on the principal ***

if exists (select 1 from sys.endpoints where name = convert(varchar(30),serverproperty('InstanceName')) + '_MIRROR')

print '*** WARNING: Endpoint ' + convert(varchar(30),serverproperty('InstanceName')) + '_MIRROR already exists on $(PRINCIPAL) ***'

else

print '*** CREATING: Endpoint ' + convert(varchar(30),serverproperty('InstanceName')) + '_MIRROR  on $(PRINCIPAL) ***'
--CREATE ENDPOINT convert(varchar(30),serverproperty('InstanceName')) + '_MIRROR' STATE=STARTED AS tcp (listener_port=$(PrincipalListenerPort)) FOR database_mirroring (ROLE=all)

GO

:CONNECT $(MIRROR)

GO

--*** Creating endpoint on the mirror ***

if exists (select 1 from sys.endpoints where name = convert(varchar(30),serverproperty('InstanceName')) + '_MIRROR')

print '***  WARNING: Endpoint ' + convert(varchar(30),serverproperty('InstanceName')) + '_MIRROR already exists on $(MIRROR) ***'

else
print '*** CREATING: Endpoint ' + convert(varchar(30),serverproperty('InstanceName')) + '_MIRROR  on $(MIRROR) ***'
--CREATE ENDPOINT convert(varchar(30),serverproperty('InstanceName')) + '_MIRROR' STATE=STARTED AS tcp (listener_port=$(MirrorListenerPort)) FOR database_mirroring (ROLE=all)

GO


--2. Take Full Backup and COPY backup files to the mirror

:CONNECT $(PRINCIPAL)

GO

print '*** Take full backup of principal database $(MYDATABASE) ***'

IF  (left(cast(SERVERPROPERTY('ProductVersion')as varchar),5)='10.00' and SERVERPROPERTY('EngineEdition')=3) OR (left(cast(SERVERPROPERTY('ProductVersion')as varchar),5)='10.50' and SERVERPROPERTY('EngineEdition')in(2,3))

BEGIN

BACKUP DATABASE $(MYDATABASE) TO DISK = '$(BACKUPPATH)$(MYDATABASE).bak'

WITH  NOFORMAT, INIT,  NAME = '$(MYDATABASE) Full Database Backup', SKIP, NOREWIND, NOUNLOAD, STATS = 10,COMPRESSION

print '*** Take transaction log backup of principal database $(MYDATABASE) ***'

BACKUP LOG $(MYDATABASE) TO  DISK = '$(BACKUPPATH)$(MYDATABASE).trn'

WITH NOFORMAT, INIT,  NAME = '$(MYDATABASE) Transaction Log Backup', SKIP, REWIND, NOUNLOAD, COMPRESSION,  STATS = 10,COMPRESSION

END

ELSE

BEGIN

BACKUP DATABASE $(MYDATABASE) TO DISK = '$(BACKUPPATH)$(MYDATABASE).bak'

WITH  NOFORMAT, INIT,  NAME = '$(MYDATABASE) Full Database Backup', SKIP, NOREWIND, NOUNLOAD, STATS = 10

print '*** Take transaction log backup of principal database $(MYDATABASE) ***'

BACKUP LOG $(MYDATABASE) TO  DISK = '$(BACKUPPATH)$(MYDATABASE).trn'

WITH NOFORMAT, INIT,  NAME = '$(MYDATABASE) Transaction Log Backup', SKIP, REWIND, NOUNLOAD, COMPRESSION,  STATS = 10

END

GO

print '*** Copy principal database $(MYDATABASE) from principal server $(PRINCIPAL) to mirror server $(MIRROR) ***'

!!ROBOCOPY $(BACKUPPATH) $(RESTOREPATH) $(MYDATABASE).*

GO

--3. Restore database on the mirror

:CONNECT $(MIRROR)

GO

print '*** Create database directories ***'


print '*** Restore full backup of database $(MYDATABASE) ***'

RESTORE DATABASE $(MYDATABASE)

FROM  DISK = '$(RESTOREPATH)$(MYDATABASE).bak'

WITH  FILE = 1,  NORECOVERY,  NOUNLOAD,  STATS = 10,REPLACE

GO

print '*** Restore transaction log backup of database $(MYDATABASE) ***'

RESTORE LOG $(MYDATABASE) FROM  DISK = '$(RESTOREPATH)$(MYDATABASE).trn'

WITH  FILE = 1,  NORECOVERY,  NOUNLOAD,  STATS = 10

GO

--4.Activate Mirroring

:CONNECT $(MIRROR)

GO

print '*** Set partner on the Mirror DB ***'

ALTER DATABASE $(MYDATABASE) SET PARTNER = 'TCP://$(PEND).$(DOMAIN):$(PrincipalListenerPort)'

GO

:CONNECT $(PRINCIPAL)

GO

print '*** Set partner on the Principal DB ***'

ALTER DATABASE $(MYDATABASE) SET PARTNER = 'TCP://$(MEND).$(DOMAIN):$(MirrorListenerPort)'

GO

print '*** Set PARTNER SAFETY FULL OFF the Principal***'

ALTER DATABASE $(MYDATABASE) SET PARTNER SAFETY OFF

GO

--print '*** Declare the witness on the Principal ***'

--if '$(WITNESS)' <> ''

--ALTER DATABASE $(MYDATABASE) SET WITNESS = 'TCP://$(WITNESS).$(DOMAIN):$(WitnessListenerPort)'

--print '*** Setting the timeout on the principal to $(TIMEOUT) seconds ***'

--ALTER DATABASE $(MYDATABASE) SET PARTNER TIMEOUT $(TIMEOUT)

--GO
