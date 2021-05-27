SELECT 
    a.name PublicationName
    , a.publication Publication
    , ditosu.comments AS MessageText
    , ditosu.[time] CommandDate
    , ditosu.xact_seqno xact_seqno
FROM MSdistribution_agents a
    INNER JOIN MSpublications p ON a.publisher_db = p.publisher_db
        AND a.publication = p.publication
    INNER JOIN MSdistribution_history ditosu ON ditosu.agent_id = a.id
-- Apply a filter here can minimize the noise
WHERE A.publication='PT_RT_Netflix'
ORDER BY ditosu.[time] DESC