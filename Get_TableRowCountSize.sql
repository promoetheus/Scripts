USE TCRUser;
GO

SELECT QUOTENAME(s.name) AS SchemaName,
		QUOTENAME(t.name) AS TableName
		, t.create_date AS CreateDate
		, t.modify_date AS ModifyDate
		, p.rows AS RowCounts
		, SUM(u.total_pages*8)/1024.0/1024.0 AS TotalSpaceGB
		, SUM(u.used_pages*8)/1024.0/1024.0 AS TotalSpaceUsedGB
		, (SUM(u.total_pages) - SUM(u.used_pages))*8/1024.0/1024.0 AS UnusedSpaceGB
FROM sys.tables t
	INNER JOIN sys.schemas s 
			ON t.schema_id=s.schema_id
	INNER JOIN sys.indexes i 
			ON t.object_id=i.object_id
	INNER JOIN sys.partitions p 
			ON i.object_id=p.object_id AND i.index_id=p.index_id
	INNER JOIN sys.allocation_units u 
			ON p.partition_id=u.container_id
WHERE t.type='U'
	AND s.name LIKE '%worldpay%'
GROUP BY s.name, t.name,t.create_date,t.modify_date,p.rows
HAVING SUM(u.total_pages*8)/1024.0/1024.0 >= 1.0
ORDER BY SchemaName, SUM(u.total_pages*8)/1024.0/1024.0 