use DMS
go

-- Get index size / each page is 8K, so it is pretty simple to work out the index size.....
SELECT OBJECT_NAME(p.object_id) AS TableName
	,i.[name] AS IndexName
	,(SUM(s.[used_page_count]) * 8) AS IndexSizeKB
	, [rows] as [Rows]
	, data_compression_desc
FROM sys.dm_db_partition_stats AS s
INNER JOIN sys.indexes AS i ON s.[object_id] = i.[object_id]
	AND s.[index_id] = i.[index_id]
INNER JOIN sys.partitions As p ON p.object_id = s.object_id
	AND p.partition_id = s.partition_id 
	AND p.index_id = s.index_id
WHERE 
	p.index_id not in (0,1) --0 = heap, 1 Clustered, 2= Nonclustered
 And i.name IN ('IX_StampIn_BatchId', 'IX_StampIn','IX_EmailDateSent_EmailStatus','IX_STnTime','IX_STnTime_Status','IX_DMTAcquirer_DMOrder','IX_DMTAcquirerStats_DMOrder','IX_LastUpdateDMID_LastUpdate')
	And OBJECT_NAME(p.object_id) <> 'PTT2'
GROUP BY p.object_id, i.[name], rows, data_compression_desc
ORDER BY rows DESC, p.object_id, i.[name]
GO

--select top 1 * From sys.partitions
--select top 1 * from sys.dm_db_partition_stats