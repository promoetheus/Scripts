USE Redirect
GO

DECLARE @stntimeSt INT, @stntimeEd INT;

SET @stntimeSt = STNCore.dbo.fn_STNTime('20190101');
SET @STNTimeEd = STNCore.dbo.fn_STNTime('20191001');


CREATE TABLE #TempHolding (RDID BIGINT NOT NULL PRIMARY KEY CLUSTERED)

-- 1. Get records for the date range (1,010,363,065) runtime: ~18mins
INSERT INTO #TempHolding(RDID)
				SELECT RDID
				FROM dbo.RDT r WITH (NOLOCK)
				WHERE STNTime >= @stntimeSt AND STNTime < @stntimeEd;


-- 2. Find records which do not exist in the target		
CREATE TABLE #TempHolding2 (RDID BIGINT NOT NULL PRIMARY KEY CLUSTERED)

-- 7,959,642
INSERT INTO #TempHolding2(RDID)
SELECT RDID
FROM #TempHolding AS c
WHERE NOT EXISTS (
					SELECT RDID
					FROM [UKDCX-PC-SARH01].[Redirect].[dbo].[RDT] WITH(NOLOCK)
					WHERE RDID = c.RDID		
				)
GO

--DROP TABLE #TempHolding;
--DROP TABLE #TempHolding2;


SELECT * FROM [UKDCX-PC-SARH01].[Redirect].[dbo].[RDT] 
WHERE RDID IN (SELECT TOP(100) RDID FROM #TempHolding2					)


USE DBA_CONFIG
GO

CREATE TABLE ARH01_RedirectBackFill
(
	ID BIGINT IDENTITY(1,1),
	RDID BIGINT NOT NULL PRIMARY KEY CLUSTERED,
	PTQueueOneProcessed BIT NULL DEFAULT(0),
	DispatcherProcessed BIT NULL DEFAULT(0),
	CVNQueueoneProcessed BIT NULL DEFAULT(0),
	RDTProcessed BIT NULL DEFAULT(0)
)

INSERT INTO DBA_CONFIG.dbo.ARH01_RedirectBackFill (RDID)
SELECT RDID FROM #TempHolding2


SELECT TOP(100) ar.RDID
FROM dbo.ARH01_RedirectBackFill As ar
LEFT JOIN [UKDCX-PC-SARH01].[Redirect].dbo.RDT AS rd 
ON ar.RDID = rd.RDID
WHERE rd.RDID IS NULL
ORDER BY ar.RDID




SELECT TOP(100) ar.RDID
FROM dbo.ARH01_RedirectBackFill As ar
ORDER BY ar.RDID


/*-------------------------------------------------------------------------------------------------------------------------

1. RDT Backfill Script

-------------------------------------------------------------------------------------------------------------------------*/

DECLARE @rc INT;

SET NOCOUNT ON;

CREATE TABLE #FullList (RDID BIGINT NOT NULL PRIMARY KEY CLUSTERED)
CREATE TABLE #IterList (RDID BIGINT NOT NULL PRIMARY KEY CLUSTERED)

INSERT INTO #FullList
SELECT TOP(10000) ar.RDID
FROM [DBA_CONFIG].[dbo].[ARH01_RedirectBackFill] ar 
WHERE ISNULL(ar.RDTProcessed,0) = 0

-- RDT
WHILE 1=1
BEGIN
	
	TRUNCATE TABLE #IterList
	
	DELETE TOP(500) f
	OUTPUT deleted.RDID INTO #IterList (RDID)
	FROM #FullList f
		
	INSERT INTO [UKDCX-PC-SARH01].[Redirect].dbo.RDT (RDID, RequestType, SVC, SVCRT, StrId, OrderNumber, CustomerInfoId, MCustomerId, SharedSecret, ResultURL, CSSURL, Token, AuthCode, MerchantId, StoreID, Amount, CurrencyId, [Status], MessageCode, StampIn, StampOut, ExpiryTimeSecs, STNTime, YearOf, MonthOf, WeekOf, DayOf, HourOf, MinuteOf, Processed, MerchantData, SVCID, DisableUpdate, CancelURL, PTEnabled, [3DEnabled], RGEnabled, RTEnabled, BillingOverRide, ShippingOverRide, CustomerCreditCardId, ProductType, TypeOfSale, IsAnalysis, IsMember, IsExtended, MerchantReference, AcctNumber2, AcctNumber2Hash, AcctNumber2Crypt, BLID, BillingSource, ShippingSource, IsCVNMem, LAN)
	SELECT ar.RDID, ar.RequestType, ar.SVC, ar.SVCRT, ar.StrId, ar.OrderNumber, ar.CustomerInfoId, ar.MCustomerId, ar.SharedSecret, ar.ResultURL, ar.CSSURL, ar.Token, ar.AuthCode, ar.MerchantId, ar.StoreID, ar.Amount, ar.CurrencyId, ar.Status, ar.MessageCode, ar.StampIn, ar.StampOut, ar.ExpiryTimeSecs, ar.STNTime, ar.YearOf, ar.MonthOf, ar.WeekOf, ar.DayOf, ar.HourOf, ar.MinuteOf, ar.Processed, ar.MerchantData, ar.SVCID, ar.DisableUpdate, ar.CancelURL, ar.PTEnabled, ar.[3DEnabled], ar.RGEnabled, ar.RTEnabled, ar.BillingOverRide, ar.ShippingOverRide, ar.CustomerCreditCardId, ar.ProductType, ar.TypeOfSale, ar.IsAnalysis, ar.IsMember, ar.IsExtended, ar.MerchantReference, ar.AcctNumber2, ar.AcctNumber2Hash, ar.AcctNumber2Crypt, ar.BLID, BillingSource, ar.ShippingSource, ar.IsCVNMem, ar.LAN 
	FROM Redirect.dbo.RDT AS ar
	INNER JOIN #IterList As t
	ON ar.RDID = t.RDID 
	OPTION(RECOMPILE)

	SET @rc = @@ROWCOUNT	

	IF @rc = 0 BREAK;

	UPDATE  [DBA_CONFIG].[dbo].[ARH01_RedirectBackFill]
	SET RDTProcessed =0
	WHERE RDID IN (SELECT RDID FROM #IterList)


	WAITFOR DELAY '00:00:02.000'

END 