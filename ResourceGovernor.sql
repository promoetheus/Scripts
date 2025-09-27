SELECT 
    rp.name AS ResourcePoolName,
    wg.name  AS WorkloadGroupName,
    wg.max_dop AS Configured_MaxDOPSetting,
    max_cpu_percent, 
    max_memory_percent, *--  cap_cpu_percent
FROM sys.resource_governor_resource_pools rp
JOIN 
    sys.resource_governor_workload_groups wg ON rp.pool_id = wg.pool_id
ORDER BY wg.max_dop DESC
