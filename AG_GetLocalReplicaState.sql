USE [DBA_CONFIG]
GO

/****** Object:  StoredProcedure [dbo].[AG_GetLocalReplicaState]    Script Date: 12/01/2017 10:05:54 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =======================================================================================================================================
-- Author:		JJ
-- Create date: 24/11/2015
-- Description:	Get/output current AG node's state, e.g. PRIMARY vs. SECONDARY
--
-- Change History
-- --------------
-- 
-- =======================================================================================================================================
CREATE PROCEDURE [dbo].[AG_GetLocalReplicaState]
(
	@availabilityGroupName	NVARCHAR(128),
	@nodeState				NVARCHAR(60)	OUTPUT
)
AS
BEGIN

	BEGIN TRY

		--get this node's state, i.e. either PRIMARY or SECONDARY
		SELECT @nodeState = ars.role_desc
		FROM sys.dm_hadr_availability_replica_states ars
		INNER JOIN sys.availability_groups ag ON ars.group_id = ag.group_id
		WHERE 1 = 1
		AND ag.name = @availabilityGroupName
		AND ars.is_local = 1;	

	END TRY
	BEGIN CATCH
		
		--report error if query fails
		RETURN 11;

	END CATCH;

	--report error if node state not found in db
	IF (@nodeState IS NULL)
		RETURN 12;

	--otherwise report success
	RETURN 0;

END;
GO


