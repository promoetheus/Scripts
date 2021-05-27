use Storehouse3
go

-- Get counts from tables in DeleteFromStoreHouse3 job
select OBJECT_NAME(object_id) AS TableName, rows
from sys.partitions
where index_id in (0,1)
	ANd OBJECT_NAME(object_id) IN ('AnalysisXML'
					,'DTT'
					,'PWSResults'
					,'PWSDetails'
					,'GTTX'
					,'GTTS'
					,'CIATrxLog'
					,'GTT'
					,'Dispatcher', 'SearchQueryLogs', 'MATLog', 'ChartTrxLog', 'ChartTrx', 'ChartReasonTrx')
order by rows desc
Go

-- Get counts from tables in CleanupStoreHouse3 job 
select OBJECT_NAME(object_id) AS TableName, rows
from sys.partitions
where index_id in (0,1)
	ANd OBJECT_NAME(object_id) IN ('Dispatcher'
					,'AnalysisXML'
					,'DTT'
					,'PWSResults'
					,'PWSDetails'
					,'GTTX'
					,'GTTS'
					,'CIATrxLog'					)
order by rows desc
Go