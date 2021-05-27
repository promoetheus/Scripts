-- get partitioned tables / indexes
select DISTINCT t.name [table name], I.name [index name], i.type_desc, i.object_id
from sys.partitions p
JOIN sys.tables t ON p.object_id=t.object_id
JOIN sys.indexes i ON P.object_id=I.object_id and P.index_id=I.index_id
where partition_number <> 1


-- get index details
select [Index Name] = i.name
		, i.type_desc
		, ps.avg_fragmentation_in_percent
		, ps.fragment_count
		, ps.avg_fragment_size_in_pages
		, ps.page_count
from sys.dm_db_index_physical_stats(DB_ID('WPSP2013_Search_SA_CrawlStore'), NULL, NULL, NULL,NULL) ps
join sys.indexes i
on ps.object_id=i.object_id and ps.index_id=i.index_id
where i.name = 'IX_MSSBatchHistory'

WHERE object_id='2137058649'


SELECT * FROM SYS.databases WHERE database_id=47