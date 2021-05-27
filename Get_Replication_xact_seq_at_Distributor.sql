    SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	
	SELECT da.[name] AS [DistributionAgentName]
    ,dh.[start_time] AS [DistributionAgentStartTime]
    ,dh.[duration] AS [DistributionAgentRunningDurationInSeconds]
    ,md.[isagentrunningnow] AS [IsAgentRunning]
    ,CASE md.[status]
    WHEN 1 THEN '1 - Started'
    WHEN 2 THEN '2 - Succeeded'
    WHEN 3 THEN '3 - InProgress'
    WHEN 4 THEN '4 - Idle'
    WHEN 5 THEN '5 - Retrying'
    WHEN 6 THEN '6 - Failed'
    END AS [ReplicationStatus]
    ,dh.[time] AS [LastSynchronized]
    ,dh.[comments] AS [Comments]
    ,md.[publisher] AS [Publisher]
    ,da.[publication] AS [PublicationName]
    ,da.[publisher_db] AS [PublisherDB]
    ,CASE 
    WHEN da.[anonymous_subid] IS NOT NULL 
    THEN UPPER(da.[subscriber_name])
    ELSE UPPER (s.[name]) END AS [Subscriber]
    ,da.[subscriber_db] AS [SubscriberDB]
    ,CASE da.[subscription_type]
    WHEN '0' THEN 'Push'  
    WHEN '1' THEN 'Pull'  
    WHEN '2' THEN 'Anonymous'  
    ELSE CAST(da.[subscription_type] AS [varchar](64)) END AS [SubscriptionType]
    ,md.[distdb] AS [DistributionDB]
    ,ma.[article]    AS [Article]
    ,ds.[UndelivCmdsInDistDB] 
    ,ds.[DelivCmdsInDistDB]
    ,dh.[current_delivery_rate] AS [CurrentSessionDeliveryRate]
    ,dh.[current_delivery_latency] AS [CurrentSessionDeliveryLatency]
    ,dh.[delivered_transactions] AS [TotalTransactionsDeliveredInCurrentSession]
    ,dh.[delivered_commands] AS [TotalCommandsDeliveredInCurrentSession]
    ,dh.[average_commands] AS [AverageCommandsDeliveredInCurrentSession]
    ,dh.[delivery_rate] AS [DeliveryRate]
    ,dh.[delivery_latency] AS [DeliveryLatency]
    ,dh.[total_delivered_commands] AS [TotalCommandsDeliveredSinceSubscriptionSetup]
    ,dh.[xact_seqno] AS [SequenceNumber]
    ,md.[last_distsync] AS [LastDistributerSync]
    ,md.[retention] AS [Retention]
    ,md.[worst_latency] AS [WorstLatency]
    ,md.[best_latency] AS [BestLatency]
    ,md.[avg_latency] AS [AverageLatency]
    ,md.[cur_latency] AS [CurrentLatency]
    FROM [distribution_PBT01]..[MSdistribution_status] ds WITH(NOLOCK)
    INNER JOIN [distribution_PBT01]..[MSdistribution_agents] da WITH(NOLOCK)
    ON da.[id] = ds.[agent_id]                          
    INNER JOIN [distribution_PBT01]..[MSArticles] ma WITH(NOLOCK)
    ON ma.publisher_id = da.publisher_id 
    AND ma.[article_id] = ds.[article_id]
    INNER JOIN [distribution_PBT01]..[MSreplication_monitordata] md WITH(NOLOCK)
    ON [md].[job_id] = da.[job_id]
    INNER JOIN [distribution_PBT01]..[MSdistribution_history] dh WITH(NOLOCK)
    ON [dh].[agent_id] = md.[agent_id] 
    AND md.[agent_type] = 3
    INNER JOIN [master].[sys].[servers]  s WITH(NOLOCK)
    ON s.[server_id] = da.[subscriber_id] 
    --Created WHEN your publication has the immediate_sync property set to true. This property dictates 
    --whether snapshot is available all the time for new subscriptions to be initialized. 
    --This affects the cleanup behavior of transactional replication. If this property is set to true, 
    --the transactions will be retained for max retention period instead of it getting cleaned up
    --as soon as all the subscriptions got the change. 
    WHERE da.[subscriber_db] <> 'virtual' 
    AND da.[anonymous_subid] IS NULL
	AND da.name = 'UKDC2-PC-PBT01A-PaymentTrust-PaymentTrust_FES-UKDCX-PC-SFES02-99'
    --AND dh.[start_time] = (SELECT TOP 1 start_time
    --                FROM [distribution_PBT01]..[MSdistribution_history] a WITH(NOLOCK)
    --                JOIN [distribution_PBT01]..[MSdistribution_agents] b WITH(NOLOCK)
    --                ON a.[agent_id] = b.[id] AND b.[subscriber_db] <> 'virtual'
    --                WHERE [runstatus] <> 1
    --                ORDER BY [start_time] DESC)
	--AND dh.xact_seqno LIKE '0x000761FF001796AF0005000000000000%'
    --AND dh.[runstatus] <> 1
	ORDER BY LastSynchronized DESC

