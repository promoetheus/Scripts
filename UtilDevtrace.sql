select top (100)
try_convert(xml, t.TextData) XML_TextData, t.TextData,
       l.EndPointLabelId, l.EndpointLabel, l.DurationMS, convert(time,dateadd (ms, l.DurationMS, 0)) as 'Duration hh:mm:ss:ms'
, l.LoginName, l.SPID, l.StartTime, l.EndTime, l.Reads, l.Writes, l.cpu, l.ServerName, l.EventClass, l.DatabaseName, l.RowCounts, t.ObjectName, t.BinaryData
from UtilDevTrace..UIAPILongRunningByEndPointLabel l
inner join UtilDevTrace..UIAPILongRunningTextData t on l.StartTime = t.StartTime
                                                       and l.SPID = t.spid
where 1 = 1
--and t.TextData like '%vw_ActiveBidLinesInBidList%'
--and t.TextData like '%fn_AggregatedRtiAgileDailyRollupByPrivateContractId%'
--and t.TextData like '%fn_AggregatedRtiAgileRollupByPrivateContractGroupId%'
--and t.TextData like '%fn_AggregatedRtiAgileRollupByPrivateContractId%'
     and t.ObjectName like'%prc_QueueRamChangedAdGroups%'
      --and left (cast(t.TextData as nvarchar(max)), 1000) like'%PoliticalDataId%'
      and t.StartTime >= '2025-09-10' --yyyy-mm-dd
      --and t.StartTime < '2023-01-10'
      --and EndpointLabel like '%PublicAPI post dmp/thirdparty/advertiser%'
      --and l.EndpointLabel like '%ScheduledReportingController.GetGeneratedReportsV3%'
	  --and l.LoginName = 'ttd_platformcontrollerservice'
--and l.spid = 710
--whereEndpointLabellike'%UIPOSTcreativesController.GetCreativesTablesolimar%'
order by l.DurationMS desc;
