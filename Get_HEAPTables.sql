SELECT OBJECT_NAME(object_id) AS TableName, count(*)
FROM sys.indexes 
WHERE index_id = 0
GROUP BY OBJECT_NAME(object_id);