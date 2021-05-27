USE distribution_PRC01;

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SET NOCOUNT ON;

		-- Get the publication and subscriptions details
		SELECT 	
			DISTINCT 
				r.srvname As publisher_server,
				r1.srvname As subscriber_server,
				p.publication AS publication_name,
				p.publisher_db, 
				s.subscriber_db,
				da.name AS distribution_agent_job_name,
				la.name AS logreader_agent_name
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
		WHERE R1.srvname is not null




			