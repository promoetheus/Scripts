-- AD group created for accessing RPMI Schema
EXEC xp_logininfo 'WORLDPAY\SG EU RPMI USER', 'MEMBERS'

-- NOTE: New AD group created: [WORLDPAY\SG EU RPMI User]
---------------------------------------------------------------
-- Create Schema
USE [TCRUser]
GO
CREATE SCHEMA [RPMI]
GO
--------------------------------------------------------------
-- Create Role
USE [TCRUser]
GO
CREATE ROLE [RPMI] AUTHORIZATION dbo;
GO
--------------------------------------------------------------
-- Create user in TCRUser database
USE [TCRUser]
GO
CREATE USER [WORLDPAY\SG EU RPMI User] FOR LOGIN [WORLDPAY\SG EU RPMI User]
GO

-- Map User [WORLDPAY\SG EU RPMI User] to Role [RPMI]
USE [TCRUser]
GO
EXEC sp_addrolemember N'RPMI', N'WORLDPAY\SG EU RPMI User'
GO
---------------------------------------------------------
-- GRANT Schema permissions to the Role [RPMI]
USE [TCRUser]
GO
GRANT ALTER ON SCHEMA::[RPMI] TO [RPMI]
GO
USE [TCRUser]
GO
GRANT DELETE ON SCHEMA::[RPMI] TO [RPMI]
GO
USE [TCRUser]
GRANT SELECT ON SCHEMA::[RPMI] TO [RPMI]
GO
USE [TCRUser]
GO
GRANT UPDATE ON SCHEMA::[RPMI] TO [RPMI]
GO
USE [TCRUser]
GO
GRANT INSERT ON SCHEMA::[RPMI] TO [RPMI]
GO

------------------------------------------------------
-- GRANT permission to [RPMI] Role in [TCRUser] database!!!
USE [TCRUser]
GO
GRANT CREATE TABLE TO [RPMI]
GO
USE [TCRUser]
GO
GRANT INSERT TO [RPMI]
GO
USE [TCRUser]
GO
GRANT DELETE TO [RPMI]
GO
USE [TCRUser]
GO
GRANT SELECT TO [RPMI]
GO
use [TCRUser]
GO
GRANT UPDATE TO [RPMI]
GO

USE [TCRUser]
GO
GRANT CREATE VIEW TO [RPMI]
GO
USE [TCRUser]
GO
GRANT CREATE FUNCTION TO [RPMI]
GO



------------------------------------------------------

-- test permissions by impersonation
EXEC AS USER = 'WORLDPAY\THOMASN470'
DROP TABLE RPMI.NT_test_Sic

EXEC AS USER = 'WORLDPAY\THOMASN470'
select top 10 * 
into TCRUSer.RPMI.NT_test_Sic
from TCRUSer.CSAR.tbl_sic_v

use TCRUser
GO
SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'RPMI'


SELECT * 
FROM fn_my_permissions (NULL, 'WORLDPAY\THOMASN470');
GO
