-- Get the qureies which are in the plan cache

Select p.query_plan, t.text
From sys.dm_exec_cached_plans c
Cross Apply sys.dm_exec_query_plan(c.plan_handle) p
Cross Apply sys.dm_exec_sql_text(c.plan_handle) t
Where t.text Like '%DeleteFrom%'
