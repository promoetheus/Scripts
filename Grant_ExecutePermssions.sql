USE EPACS_INVOICE;
GO

DECLARE @prc NVARCHAR(250), @sql NVARCHAR(MAX), @grp NVARCHAR(250)
SET @grp = N'WORLDPAYPP\SG EU NFT BAU Admin'

DECLARE Perm_Cursor CURSOR FOR
SELECT name
FROM sys.procedures 
WHERE name in ('MIS_GEN_MerchantMonthlyInvoices', 'MIS_GEN_Revenue', 'MIS_GEN_Revenue_MerchantPerformance', 'SageInvoice_Gen')

OPEN Perm_Cursor;

FETCH NEXT FROM Perm_Cursor INTO @prc 

WHILE @@FETCH_STATUS=0
BEGIN 


		SET @sql = 'GRANT EXECUTE ON ' + QUOTENAME(@prc) + ' TO ' + QUOTENAME(@grp) + ';'
		--PRINT @sql;

		EXEC sp_executesql @sql;

		FETCH NEXT FROM Perm_Cursor INTO @prc

END

CLOSE Perm_Cursor;
DEALLOCATE Perm_Cursor;


-- listing permissions on schema objects withing a database
SELECT pr.principal_id, pr.name, pr.type_desc,
	pr.authentication_type_desc, pe.state_desc,
	pe.permission_name, s.name + '.' + o.name AS ObjectName
FROM sys.database_principals AS pr
JOIN sys.database_permissions AS pe
	ON pe.grantee_principal_id = pr.principal_id
JOIN sys.objects AS o
	ON pe.major_id=o.object_id
JOIN sys.schemas AS s
	ON o.schema_id = s.schema_id