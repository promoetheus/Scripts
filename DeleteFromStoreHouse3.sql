USE [StoreHouse3]
GO
/****** Object:  StoredProcedure [dbo].[DeleteFromStoreHouse3]    Script Date: 14/04/2020 10:15:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/****************************************************************

**  File: DeleteFromStoreHouse3.sql
**  Name: DeleteFromStoreHouse3
**  Desc: This procedure deletes old trxs from Dispatcher, DTT, GTTX, GTTS and GTT tables in StoreHouse3 on RRP01
			- @Retention : 14 months

**  Auth: Justin Belling
**  Date: 2017-08-29
********************************************************************
**  Change History
2020/04/08 Set Order By STNTime
			Create Clustered index constrain after temp table is populated (INC2638003 + INC2553070)
********************************************************************

*/
ALTER PROCEDURE [dbo].[DeleteFromStoreHouse3]
AS

BEGIN

SET NOCOUNT ON;

DECLARE @STNTimeEnd INT, @Retention INT;

SET @Retention = 14;
SET @STNTimeEnd = STNCore.dbo.fn_STNTime(DATEADD(MONTH,-1*@Retention,GETDATE()))

CREATE TABLE #IterList (
	Gttid BIGINT 
);

WHILE (0=0)
	BEGIN	
		
		TRUNCATE TABLE #IterList;
			INSERT INTO #IterList(Gttid)
			SELECT TOP(4999) Gttid
			FROM dbo.GTT WITH(NOLOCK) 
			WHERE STNTime < @STNTimeEnd
			ORDER BY STNTime
			OPTION(RECOMPILE); 

			IF @@ROWCOUNT=0 BEGIN
					BREAK; 
			END
			
			IF EXISTS (SELECT * 
						FROM tempdb.sys.indexes AS si 
						JOIN tempdb.sys.objects AS so ON si.object_id = so.object_id
						JOIN tempdb.sys.schemas AS ss ON so.schema_id = ss.schema_id
						WHERE ss.name = 'dbo'
							AND si.name = 'idx_IterList_Gttid' 
							AND so.name LIKE '#IterList[_]%')
			BEGIN
					DROP INDEX IF EXISTS dbo.#IterList.idx_IterList_Gttid;		
			END

			CREATE CLUSTERED INDEX idx_IterList_Gttid ON #IterList(Gttid);

			DELETE FROM dbo.Dispatcher WHERE GttId IN (SELECT Gttid FROM #IterList);
			DELETE FROM dbo.GTTX WHERE GttId IN (SELECT GttId FROM #IterList);
			DELETE FROM dbo.DTT WHERE GttId IN (SELECT GttId FROM #IterList);
			DELETE FROM dbo.GTTS WHERE GTTID IN (SELECT GttId FROM #IterList);	
			DELETE FROM dbo.GTT WHERE GttId IN (SELECT GttId FROM #IterList); /* moved to last to avoid orphans in other tables on error */

	END 

END
