--enabling TDE
-- 1. create master key
-- 2. create certificate
-- 3. create database encryption key
-- 4. alter database set encryption on


CREATE DATABASE TestDatabaseEncryption
ALTER DATABASE TestDatabaseEncryption SET RECOVERY FULL;
backup database TestDatabaseEncryption to disk = 'F:\MSSQL\WPSISDB01\BACKUP\TestDatabaseEncryption.bak'


SELECT name, pvt_key_encryption_type_desc, thumbprint FROM sys.certificates

SELECT * FROM sys.symmetric_keys

SELECT name FROM sys.databases WHERE is_master_key_encrypted_by_server=1
SELECT name FROM sys.databases WHERE is_encrypted = 1;

-- encrypt the database and the transaction logs
-- encryption algorithm - AES_256
-- ecryptor type: Certificate

-- encryption state 3 = database + log encrypted, 1 means db not yet encrypted, 2 = encryption is still taking place
SELECT db_name(database_id), encryption_state, encryptor_thumbprint, encryptor_type
FROM sys.dm_database_encryption_keys 



--------------------------------------------------------------------------------------------------



-- 1 verify instance has a Database Master Key (DMK) in Master - if not, create one
USE master
GO

SELECT * FROM sys.symmetric_keys
	--WHERE name = '##MS_DatabaseMasterKey##'

-- if database master key does not exist then we need to create one
CREATE MASTER KEY ENCRYPTION 
	BY PASSWORD = '3KHCyUCeTrrNAAg9DaPG';

CREATE CERTIFICATE DB_EncryptionCert
	WITH SUBJECT = N'TDE Certificate';

USE [TestDatabaseEncryption]
GO

CREATE DATABASE ENCRYPTION KEY
WITH ALGORITHM = AES_256
	ENCRYPTION BY SERVER CERTIFICATE DB_EncryptionCert;

USE [master]
GO

BACKUP CERTIFICATE DB_EncryptionCert TO FILE = 'F:\Certficate\DB_EncryptionCert';

USE [TestDatabaseEncryption]
GO

ALTER DATABASE [TestDatabaseEncryption] SET ENCRYPTION ON;

