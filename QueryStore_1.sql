select top 50 
  q.query_id
  --, qt.query_sql_text
  --, qp.plan_id, qp.query_plan
  , object_name(q.object_id)
  --,sum(rs.count_executions) as [Execution Cnt]
  ,convert(bigint,sum(rs.count_executions * 
    (rs.avg_logical_io_reads + rs.avg_logical_io_writes)) / 
      sum(rs.count_executions)) as [Avg IO]
  ,convert(bigint,sum(rs.count_executions * 
    (rs.avg_logical_io_reads + rs.avg_logical_io_writes))) as [Total IO]
  ,convert(bigint,sum(rs.count_executions * rs.avg_cpu_time) /
    sum(rs.count_executions)) as [Avg CPU]
  ,convert(bigint,sum(rs.count_executions * rs.avg_cpu_time)) as [Total CPU]
  ,convert(bigint,sum(rs.count_executions * rs.avg_duration) / 
    sum(rs.count_executions)) as [Avg Duration]
  --,convert(bigint,sum(rs.count_executions * rs.avg_duration)) 
  --  as [Total Duration]
  --,convert(bigint,sum(rs.count_executions * rs.avg_physical_io_reads) / 
  --  sum(rs.count_executions)) as [Avg Physical Reads]
  --,convert(bigint,sum(rs.count_executions * rs.avg_physical_io_reads)) 
  --  as [Total Physical Reads]
  --,convert(bigint,sum(rs.count_executions * rs.avg_query_max_used_memory) / 
  --  sum(rs.count_executions)) as [Avg Memory Grant Pages]
  --,convert(bigint,SUM(rs.count_executions * rs.avg_query_max_used_memory)) 
  --  AS [Total Memory Grant Pages]
  --,CONVERT(bigint,SUM(rs.count_executions * rs.avg_rowcount) /
  --  SUM(rs.count_executions)) AS [Avg Rows]
  --,CONVERT(bigint,SUM(rs.count_executions * rs.avg_rowcount)) AS [Total Rows]
  --,CONVERT(bigint,SUM(rs.count_executions * rs.avg_dop) /
  --  SUM(rs.count_executions)) AS [Avg DOP]
  --,CONVERT(bigint,SUM(rs.count_executions * rs.avg_dop)) AS [Total DOP]
from 
  sys.query_store_query q with (nolock)
    join sys.query_store_plan qp with (nolock) on
      q.query_id = qp.query_id
    join sys.query_store_query_text qt with (nolock) on
      q.query_text_id = qt.query_text_id
    join sys.query_store_runtime_stats rs with (nolock) on
      qp.plan_id = rs.plan_id 
    join sys.query_store_runtime_stats_interval rsi with (nolock) on
      rs.runtime_stats_interval_id = rsi.runtime_stats_interval_id
where 1=1
--and qt.query_sql_text like '% insert into #TDUStagingTableWithoutDuplicates_Targeting%'
--and object_name(q.object_id) like '%diffcache%'
and q.object_id = object_id('bidding.prc_QueueRamChangedAdGroups')

--and qt.query_sql_text like '%GetBulkAdGroupsData%'
group by
  q.query_id
  --, qt.query_sql_text
  --, qp.plan_id, qp.query_plan
  , object_name(q.object_id)
order by 
  [Avg Duration] desc
  --[Avg CPU] desc
  --[Total IO] desc
option (maxdop 1, recompile);
