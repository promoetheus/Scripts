/**

run the below at the Subscriber to get the last replicated LSN

SET NOCOUNT ON;

SELECT MAX(transaction_timestamp) 
FROM [PaymentTrust].dbo.MSreplication_subscriptions
WHERE publisher = 'UKDC2-PC-PBT01A'
AND publisher_db = 'PaymentTrust'
AND publication = 'PaymentTrust_FES';
GO

**/

/** run script at the distributor **/

----------------------------------------------

--2020-02-17 15:14:54.090
select min(entry_time), max(entry_time) from MSrepl_transactions with(nolock) where publisher_database_id=14

-----------------------------------


USE distribution_PBT01
GO 

SELECT TOP(1) xact_seqno, entry_time
FROM MSpublications p
JOIN master..sysservers srv 
ON srv.srvid = p.publisher_id
JOIN MSpublisher_databases d
ON d.publisher_id = p.publisher_id
JOIN MSrepl_transactions trans
ON trans.publisher_database_id = d.id
WHERE p.publication = 'PaymentTrust_FES'
AND p.publisher_db = 'PaymentTrust'
AND srv.srvname = 'UKDC2-PC-PBT01A'
--and xact_seqno = 0x0007620100039AD60012000000000000
AND id = 14
and entry_time >= DATEADD(minute,-30,GETDATE())
ORDER BY entry_time ASC

--0x0007620000102E6A0026000000000000
--0x00076220000BBD160013000000000000
