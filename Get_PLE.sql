-- Page Life Expectancy (PLE) value for each NUMA node in current instance  (Query 40) (PLE by NUMA Node)
SELECT @@SERVERNAME AS [Server Name], [object_name], instance_name, cntr_value AS [Page Life Expectancy]
FROM sys.dm_os_performance_counters WITH (NOLOCK)
WHERE [object_name] LIKE N'%Buffer Node%' -- Handles named instances
AND counter_name = N'Page life expectancy' OPTION (RECOMPILE);

-- PLE is a good measurement of memory pressure.
-- Higher PLE is better. Watch the trend over time, not the


/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP 1000 [id]
      ,[date_time]
      ,[server_name]
      ,[object_name]
      ,[counter_name]
      ,[instance_name]
      ,[cntr_value]
      ,[cntr_type]
  FROM [ProDBA].[dbo].[sys_dm_os_performance_counters] WITH (NOLOCK)
  WHERE counter_name = 'Page life expectancy'
		--AND CAST(date_time as DATE) = '2016-04-04'
  ORDER BY 1 DESC