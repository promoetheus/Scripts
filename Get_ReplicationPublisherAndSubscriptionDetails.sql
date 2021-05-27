USE distribution_MUM01;

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

DECLARE @subscriber NVARCHAR(255) = N'UKDC2-PC-TRX03'




-- Generate the script to disable the Log reader and Distribution jobs
SET NOCOUNT ON;

SELECT DISTINCT 'USE msdb; ' 
		+ 'EXEC dbo.sp_update_job @job_name =''' +distribution_agent_job_name + ''',  @enabled = 0;' + char(10)
			+ 'EXEC dbo.sp_stop_job @job_name = ''' + distribution_agent_job_name + ''';'
FROM 
	(
		-- Get the publication and subscriptions details
		SELECT 	DISTINCT p.publication AS publication_name,
				p.publisher_db, 
                r.srvname As publisher_server,
                r1.srvname As subscriber_server,
				s.subscriber_db,
				da.name AS distribution_agent_job_name,
				da.job_id AS distribution_agent_job_id,
				la.name AS logreader_agent_name,
				la.job_id AS logreader_job_id
		FROM [dbo].[MSpublications] AS p
		INNER JOIN [dbo].[MSsubscriptions] AS s 
		ON p.publisher_id = s.publisher_id 
			AND p.publisher_db = s.publisher_db
		              lEFT Join dbo.MSreplservers As r 
                     On r.srvid = p.publisher_id
              lEFT Join dbo.MSreplservers As r1 
                     On r1.srvid = s.subscriber_id
		JOIN MSdistribution_agents da ON da.publisher_id = p.publisher_id  
			 AND da.subscriber_id = s.subscriber_id 
			 AND p.publisher_db = da.publisher_db
			 AND p.publication = da.publication
		INNER JOIN MSlogreader_agents AS la ON la.publisher_id = p.publisher_id
			AND la.publisher_db = p.publisher_db
		WHERE r1.srvname = @subscriber
	) AS D
;

-- Generate the script to enable the the Log Reader 
SELECT DISTINCT 'USE msdb; ' 
		+ 'EXEC dbo.sp_update_job @job_name =''' +logreader_agent_name + ''',  @enabled = 1;' + char(10)
			+ 'EXEC dbo.sp_start_job @job_name = ''' + logreader_agent_name + ''';'
FROM	(
		-- Get the publication and subscriptions details
		SELECT 	DISTINCT p.publication AS publication_name,
				p.publisher_db, 
                r.srvname As publisher_server,
                r1.srvname As subscriber_server,
				s.subscriber_db,
				da.name AS distribution_agent_job_name,
				da.job_id AS distribution_agent_job_id,
				la.name AS logreader_agent_name,
				la.job_id AS logreader_job_id
		FROM [dbo].[MSpublications] AS p
		INNER JOIN [dbo].[MSsubscriptions] AS s 
		ON p.publisher_id = s.publisher_id 
			AND p.publisher_db = s.publisher_db
		AND p.publisher_db = s.publisher_db
		lEFT Join dbo.MSreplservers As r 
                On r.srvid = p.publisher_id
        lEFT Join dbo.MSreplservers As r1 
                On r1.srvid = s.subscriber_id
		JOIN MSdistribution_agents da ON da.publisher_id = p.publisher_id  
			 AND da.subscriber_id = s.subscriber_id 
			 AND p.publisher_db = da.publisher_db
			 AND p.publication = da.publication
		INNER JOIN MSlogreader_agents AS la ON la.publisher_id = p.publisher_id
			AND la.publisher_db = p.publisher_db
		WHERE r1.srvname = @subscriber
	) AS D
