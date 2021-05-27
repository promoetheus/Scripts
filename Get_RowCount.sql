use StoreHouse3
go

select OBJECT_NAME(object_id) AS TableName, rows
from sys.partitions
where index_id in (0,1)
order by rows desc