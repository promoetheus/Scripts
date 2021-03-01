USE [PaymentTrust]
GO
/****** Object:  StoredProcedure [dbo].[DeleteFromPTT]    Script Date: 14/04/2020 10:09:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER Procedure [dbo].[DeleteFromPTT]
as
--NEW code from JB 2017/01/30
-- 2020/04/08 Updated Order By from PTTID to STNtime (INC2651500)
CREATE TABLE #FullList
                     (  
                     PTTID bigint 
                     )             
 
CREATE TABLE #IterList
                     (
                           PTTID bigint PRIMARY KEY CLUSTERED
                     )
 
SET NOCOUNT ON
Declare @stntime int, @maxrows int=10000 ,@delrows int=500, @UnArchivedSTNTimeEnd int, @rc int
 
set @UnArchivedSTNTimeEnd = STNCore.dbo.fn_STNTime(DATEADD(DAY,-10,GETDATE()))--archive retention period
set @stntime = dbo.fn_STNTime(dateadd(DAY,-61,GETDATE())) -- retention period
 
 
TRUNCATE TABLE #FullList
INSERT INTO #FullList (PttId) 
	SELECT p.PttId FROM PTT p WITH (NOLOCK)
	LEFT JOIN dbo.UnArchiveLogs u WITH (NOLOCK) 
	ON p.PTTId=u.Pttid AND UnArchivedSTNTime >= @UnArchivedSTNTimeEnd
	WHERE stntime < @stntime 
	AND OurResult NOT IN ('2040','2050')
	AND u.Pttid IS NULL
	order by p.STNTime 
	option(recompile);

SET @rc = @@ROWCOUNT;
 
IF @rc IS NOT NULL
	BEGIN
		CREATE CLUSTERED INDEX idx_FullList_PTTID ON #FullList (PTTID);
	END

WHILE (1=1) BEGIN
       TRUNCATE TABLE #IterList
       DELETE TOP (@delrows) FROM #FullList
       output DELETED.PTTID INTO #IterList
 
       IF (@@ROWCOUNT = 0)  BEGIN
              BREAK;
       END
       
       DELETE FROM Narrativestatement WHERE PTTID IN (SELECT PTTID FROM #IterList)
       DELETE FROM ICCDetails WHERE PTTID IN (SELECT PTTID FROM #IterList)
       DELETE FROM RBSISODetails WHERE PTTID IN (SELECT PTTID FROM #IterList)
       DELETE FROM PTT2 WHERE  PTTID IN (SELECT PTTID FROM #IterList)
       DELETE FROM PurchaseOrder WHERE PTTID IN (SELECT PTTID FROM #IterList)
       DELETE FROM APMDetails WHERE PTTID IN (SELECT PTTID FROM #IterList)
       DELETE FROM UnArchiveLogs WHERE Pttid IN (SELECT PTTID FROM #IterList) AND UnArchivedSTNTime < @UnArchivedSTNTimeEnd
       DELETE FROM PTT3 WHERE PTTID IN (SELECT PTTID FROM   #IterList)
	   DELETE FROM PTT WHERE PTTID IN (SELECT PTTID FROM #IterList)
       
END