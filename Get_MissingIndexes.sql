-- index operational stats
-- index usage stats

SELECT * FROM sys.dm_db_index_operational_stats(DB_ID(),NULL,NULL,NULL)
SELECT * FROM sys.dm_db_index_usage_stats

-- Missing index details
SELECT index_handle, DB_NAME(database_id) AS DBName, object_id, equality_columns, inequality_columns,included_columns,statement
FROM sys.dm_db_missing_index_Details;
