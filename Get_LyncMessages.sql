/**------------------------------------
Written by Justin Belling
Note: Get Lync conversation history
	Script must be run on UKDC1-PC-SQL23\WPSISDB01
-----------------------------------------**/
USE [LcsLog]
GO

DECLARE @To VARCHAR(4000), @From VARCHAR(4000), @StartDate DATETIME, @EndDate DATETIME
--SET @From = 'robert.thacker@worldpay.com' 
--SET @To = 'mark.heimbouch@worldpay.com' 
SET @StartDate = '2019-08-01 00:00:00'
SET @EndDate = '2020-02-18 23:59:59';

WITH CTE AS (SELECT *
			FROM dbo.Users u	
			WHERE u.UserUri IN ('Liz.Martin@fisglobal.com',
								'Paul.Zimmerman@fisglobal.com',
								'Jeremy.Paris@fisglobal.com',
								'Liz.Martin@worldpay.com',
								'Paul.Zimmerman@worldpay.com',
								'Jeremy.Paris@worldpay.com'
								))

SELECT m.MessageIdTime,
		u.UserUri AS [FROM],
		u1.UserUri AS [TO],
		m.Body AS [MESSAGE]
FROM dbo.Messages m WITH(NOLOCK)
INNER JOIN dbo.Users u WITH(NOLOCK) ON u.UserId=m.FromId
INNER JOIN dbo.Users u1 WITH(NOLOCK) ON u1.UserId=m.ToId
WHERE m.FromId IN (SELECT UserId FROM CTE)
AND m.ToId IN (SELECT UserId FROM CTE)
AND m.MessageIdTime BETWEEN @StartDate AND @EndDate
ORDER BY 1 DESC


