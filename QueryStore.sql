/**

Use Query store to get the query_id for the Aborted Query. 
The quer_id can then be passed into the Tracked Queries Dashboard on the reportsdb instance\

**/
use Provisioning
go


declare @ProcName nvarchar(128) = null
set @ProcName = 'prc_GetCreativeIdsThatNeedToBeSubmittedForApproval'
--select @ProcName 

drop table if exists #temp;
SELECT 
    qsq.*,
    object_name(qsq.object_id) as proctname,
    qsqt.query_sql_text, qsqt.statement_sql_handle, 
    sts.runtime_stats_interval_id, sts.execution_type, sts.execution_type_desc, sts.first_execution_time, sts.count_executions, sts.avg_duration, sts.last_duration, sts.min_duration, sts.max_duration, sts.stdev_duration, sts.avg_cpu_time, sts.last_cpu_time, sts.min_cpu_time, sts.max_cpu_time, sts.stdev_cpu_time, sts.avg_logical_io_reads, sts.last_logical_io_reads, sts.min_logical_io_reads, sts.max_logical_io_reads, sts.stdev_logical_io_reads, sts.avg_logical_io_writes, sts.last_logical_io_writes, sts.min_logical_io_writes, sts.max_logical_io_writes, sts.stdev_logical_io_writes, sts.avg_physical_io_reads, sts.last_physical_io_reads, sts.min_physical_io_reads, sts.max_physical_io_reads, sts.stdev_physical_io_reads, sts.avg_clr_time, sts.last_clr_time, sts.min_clr_time, sts.max_clr_time, sts.stdev_clr_time, sts.avg_dop, sts.last_dop, sts.min_dop, sts.max_dop, sts.stdev_dop, sts.avg_query_max_used_memory, sts.last_query_max_used_memory, sts.min_query_max_used_memory, sts.max_query_max_used_memory, sts.stdev_query_max_used_memory, sts.avg_rowcount, sts.last_rowcount, sts.min_rowcount, sts.max_rowcount, sts.stdev_rowcount, sts.avg_num_physical_io_reads, sts.last_num_physical_io_reads, sts.min_num_physical_io_reads, sts.max_num_physical_io_reads, sts.stdev_num_physical_io_reads, sts.avg_log_bytes_used, sts.last_log_bytes_used, sts.min_log_bytes_used, sts.max_log_bytes_used, sts.stdev_log_bytes_used, sts.avg_tempdb_space_used, sts.last_tempdb_space_used, sts.min_tempdb_space_used, sts.max_tempdb_space_used, sts.stdev_tempdb_space_used
 into #temp	
from sys.query_store_query qsq
inner join sys.query_store_query_text qsqt
    on qsq.query_text_id = qsqt.query_text_id
inner join sys.query_store_plan AS p
    ON qsq.query_id = p.query_id
inner join sys.query_store_runtime_stats sts
    on sts.plan_id = p.plan_id
WHERE 1 = 1
    --and qsqt.query_sql_text LIKE '%@__categoryProviderId_0 bigint)SELECT [m].[CategoryId], [m].[CategoryName], [m].[CategoryProviderId]%' 
    and object_name(qsq.object_id) = @ProcName -- if know the stored procedure <<< add it here
    --and qsqt.query_sql_text like '%@ApprovalTargetType%nvarchar(64)%,%@SupplyVendorId bigint%,%@PublisherId%nvarchar(255)%,%@ThirdPartyDataBrandId nvarchar(32)%'
    --and qsqt.query_sql_text LIKE '%CASE WHEN ( EXISTS (SELECT%';
    --and qsq.query_id=2027685
    --and qsq.initial_compile_start_time > '2025-08-01 00:00:00.0000000 +00:00'
   --and qsq.query_id = '2006631630'
order by initial_compile_start_time desc

select * from #temp
where  1 = 1
--and query_hash = 0xDAF5DA8B90B2FD9F
--and query_sql_text like '%project1%'
--and query_sql_text LIKE '%fn_GetDataRateCardsForAdvertiser%'
--and last_duration >= 58 * 1000000 --(58 secs)
--and execution_type_desc = 'Aborted'
order by 1 desc
option (recompile)



--916,975,033           
--Exec sp_spaceused 'ExpandedThirdPartyDataRate'

select query_id, count(*) 
from #temp
where  1 = 1
--and query_sql_text like '%project1%'
--and query_sql_text like '%row_number%'
--and query_sql_text LIKE '%#countersToFetchWithDupes%'
--and last_duration >= 20 * 1000000 --(58 secs)
and execution_type_desc = 'Aborted'
group by query_id
order by 1
option (recompile)


-- there are a lot of things which can be done to understand what is the slowest / least 
-- performing part of the query

select query_id, 
        avg(avg_duration) as AvgDuration, 
        sum(count_executions) as TotalExecutions, 
        max(query_sql_text) as QueryText
from #temp
where  1 = 1
--and query_hash = 0xDAF5DA8B90B2FD9F
--and query_sql_text like '%project1%'
--and query_sql_text LIKE '%fn_GetDataRateCardsForAdvertiser%'
--and last_duration >= 58 * 1000000 --(58 secs)
--and execution_type_desc = 'Aborted'
group by query_id
order by 2 desc
option (recompile)

/**

(@CreativeId nvarchar(32),@CreativeApproverId int,@CreativeApprovalTargetId int,@CreativeVersion int,@CreativeAuditStatus nvarchar(32),@DisplayableReasonForStatus nvarchar(max),@SubmissionState nvarchar(32),@SubmissionTime datetime,@ExpirationTime datetime,@LastUpdatedBy nvarchar(256),@Lastmod bigint,@CreativeAuditStatusIsPartial bit,@IabStatus int)
UPDATE dbo.CreativeApprovalStatus                 
SET                     CreativeVersion = COALESCE(@CreativeVersion, CreativeVersion),                     CreativeAuditStatus = COALESCE(@CreativeAuditStatus, CreativeAuditStatus),                     DisplayableReasonForStatus = COALESCE(@DisplayableReasonForStatus, DisplayableReasonForStatus),                     SubmissionState = COALESCE(@SubmissionState, SubmissionState),                     SubmissionTime = COALESCE(@SubmissionTime, SubmissionTime),                     ExpirationTime = COALESCE(@ExpirationTime, ExpirationTime),                     LastUpdatedBy = @LastUpdatedBy,                     LastUpdatedAt = GETUTCDATE(),                     Lastmod = COALESCE(@Lastmod, Lastmod),                     CreativeAuditStatusIsPartial = COALESCE(@CreativeAuditStatusIsPartial, CreativeAuditStatusIsPartial),                     IabStatus = COALESCE(@IabStatus, IabStatus)                 
WHERE                     CreativeId = @CreativeId                     
AND CreativeApproverId = @CreativeApproverId                     
AND CreativeApprovalTargetId = @CreativeApprovalTargetId

	[CreativeId] ASC,
	[CreativeApproverId] ASC,
	[CreativeApprovalTargetId] ASC


 **/
