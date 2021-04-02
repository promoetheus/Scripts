USE AdventureWorks2017;
GO

-- Run a stored procedure or query
EXEC getSalesOrder @PersonID = 288;

-- Find the plan handle for that query 
-- OPTION (RECOMPILE) keeps this query from going into the plan cache
SELECT cp.plan_handle, cp.objtype, cp.usecounts, 
DB_NAME(st.dbid) AS [DatabaseName]
FROM sys.dm_exec_cached_plans AS cp 
CROSS APPLY sys.dm_exec_sql_text(plan_handle) AS st 
WHERE OBJECT_NAME (st.objectid)
LIKE N'%getSalesOrder%' OPTION (RECOMPILE); 


-- Very important to clear the plan cache for only the affected query
-- Remove the specific query plan from the cache using the plan handle from the above query 
DBCC FREEPROCCACHE (0x05000600C0DE4B7F50D9C156B302000001000000000000000000000000000000000000000000000000000000);



 
 /**

 BELOW IS AN EXAMPLE 
 NEED TO TEST BETWEEN 
	-> OPTION(RECOMPILE)
	-> OPTION(OPTIMIZE FOR UKNOWNN)

-- TRY TO PREVENT PARAMETER SNIFFING



 use AdventureWorks2017
Go

CREATE OR ALTER PROCEDURE getSalesOrder

@PersonID INT

AS


DECLARE @PersonId_loc INT

SET @PersonId_loc = @PersonID

SELECT SalesOrderId, OrderDate
FROM Sales.SalesOrderHeader
WHERE SalesPersonID = @PersonID
OPTION(RECOMPILE)
GO


DBCC DROPCLEANBUFFERS;
DBCC FREEPROCCACHE WITH NO_INFOMSGS;


EXEC getSalesOrder @PersonID = 277;



**/


