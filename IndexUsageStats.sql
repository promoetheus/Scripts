AdvertiserId is more selective than CreativeStateId

select AdvertiserId, count(*)
from dbo.Creative 
group by AdvertiserId
having count(*)>1
go

select CreativeStateId, count(*)
from dbo.Creative
group by CreativeStateId;
go

select AdFormatId, count(*)
from dbo.Creative
group by AdFormatId
having count(*)>1;
go

--

drop index if exists ix_Creative_AdvertiserId_AdFormatId_Incl on dbo.Creative;
go


if not exists (select 1 from sys.indexes where name ='ix_Creative_AdvertiserId_AdFormatId_Incl' and object_id = object_id('dbo.Creative'))
begin 
    create nonclustered index ix_Creative_AdvertiserId_AdFormatId_Incl on dbo.Creative
    (
        AdvertiserId ASC, 
        AdFormatId ASC
    )
    include([Name], [Description], CreatedAt, CreativeStateId, AdServerCreativeId)
    with(online=on, maxdop=8, data_compression = page);
end
go








SELECT
    s.name AS SchemaName,
    t.name AS TableName,
    i.name AS IndexName,
    i.type_desc AS IndexType,
    p.rows AS [RowCount],
    CAST((p.reserved_space_kb / 1024.0) AS DECIMAL(18, 2)) AS ReservedSpaceMB,
    CAST((p.used_space_kb / 1024.0) AS DECIMAL(18, 2)) AS UsedSpaceMB,
    ISNULL(us.user_seeks, 0) AS UserSeeks,
    ISNULL(us.user_scans, 0) AS UserScans,
    ISNULL(us.user_lookups, 0) AS UserLookups,
    ISNULL(us.user_updates, 0) AS UserUpdates,
    us.last_user_seek,
    us.last_user_scan,
    us.last_user_lookup,
	p.data_compression_desc
FROM
    sys.tables AS t
INNER JOIN
    sys.schemas AS s ON t.schema_id = s.schema_id
INNER JOIN
    sys.indexes AS i ON t.object_id = i.object_id
INNER JOIN
    (
        SELECT
            ps.object_id,
            ps.index_id,
			sp.data_compression_desc,
            SUM(row_count) AS rows,
            SUM(reserved_page_count) * 8 AS reserved_space_kb,
            SUM(used_page_count) * 8 AS used_space_kb
        FROM sys.dm_db_partition_stats ps
		inner join sys.partitions sp on sp.partition_id=ps.partition_id
        GROUP BY ps.object_id, ps.index_id,sp.data_compression_desc
    ) AS p ON i.object_id = p.object_id AND i.index_id = p.index_id
LEFT JOIN
    sys.dm_db_index_usage_stats AS us ON i.object_id = us.object_id AND i.index_id = us.index_id AND us.database_id = DB_ID()
WHERE
    t.is_ms_shipped = 0
    AND i.type_desc <> 'HEAP' -- Heaps don't have usage stats in the same way
    and t.name = 'Creative'
ORDER BY
    s.name,
    t.name,
    i.name;
