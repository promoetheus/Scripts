--Databases users and roles
DECLARE @SQLStatement VARCHAR(4000) 
DECLARE @T_DBuser TABLE (DBName SYSNAME, UserName SYSNAME, AssociatedDBRole NVARCHAR(256)) 
SET @SQLStatement='
SELECT ''?'' AS DBName,dp.name AS UserName,USER_NAME(drm.role_principal_id) AS AssociatedDBRole 
FROM ?.sys.database_principals dp
LEFT OUTER JOIN ?.sys.database_role_members drm
ON dp.principal_id=drm.member_principal_id 
WHERE dp.sid NOT IN (0x01) AND dp.sid IS NOT NULL AND dp.type NOT IN (''C'') AND dp.is_fixed_role <> 1 AND dp.name NOT LIKE ''##%'' AND ''?'' NOT IN (''master'',''msdb'',''model'',''tempdb'') ORDER BY DBName'
INSERT @T_DBuser
EXEC sp_MSforeachdb @SQLStatement
SELECT * FROM @T_DBuser WHERE UserName IN ('AutoRekUsers','WORLDPAY\SG EU Autorek DB Support')
			and DBName = 'AutoRek5WorldPay'
ORDER BY DBName
		


--Get objects permission of specified user database 
USE AutoRek5Catalog
GO
DECLARE @Obj VARCHAR(4000)
DECLARE @T_Obj TABLE (UserName SYSNAME, ObjectName SYSNAME, Permission NVARCHAR(128))
SET @Obj='
SELECT Us.name AS username, Obj.name AS object,  dp.permission_name AS permission 
FROM sys.database_permissions dp
JOIN sys.sysusers Us 
ON dp.grantee_principal_id = Us.uid 
JOIN sys.sysobjects Obj
ON dp.major_id = Obj.id '
INSERT @T_Obj 
EXEC sp_MSforeachdb @Obj
SELECT DISTINCT UserName, objectName, Permission FROM @T_Obj WHERE Permission IN ('EXECUTE', 'ALTER')


-- get server level permissions
SELECT sys.server_role_members.role_principal_id, role.name AS RoleName,   
    sys.server_role_members.member_principal_id, member.name AS MemberName  
FROM sys.server_role_members  
JOIN sys.server_principals AS role  
    ON sys.server_role_members.role_principal_id = role.principal_id  
JOIN sys.server_principals AS member  
    ON sys.server_role_members.member_principal_id = member.principal_id
	where member.name = N'WORLDPAY\SG EU Infrastructure DB Admins'
