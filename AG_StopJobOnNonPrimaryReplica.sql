USE [DBA_CONFIG]
GO

/****** Object:  StoredProcedure [dbo].[AG_StopJobOnNonPrimaryReplica]    Script Date: 12/01/2017 10:03:18 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =======================================================================================================================================
-- Author:		JJ
-- Create date: 24/11/2015
-- Description:	Stop a SQL Agent job on non-primary node
--				Call from job's step 1 ('WPAP AG Replica Check') using following syntax:
--				EXEC [dbo].[AG_StopJobOnNonPrimaryReplica] $(ESCAPE_NONE(JOBID));
--
-- Change History
-- --------------
-- 
-- =======================================================================================================================================
CREATE PROCEDURE [dbo].[AG_StopJobOnNonPrimaryReplica]
(
	@job_id					UNIQUEIDENTIFIER = NULL,			--job to be stopped
	@availabilityGroupName	NVARCHAR(128) = 'WPGWAG01',	--change to real WPAP AG name that replica belongs to !!!!!!!!!!!!!
	@forcedErrorLevel		TINYINT = 2							--set to level that fails Agent Job
)
AS
BEGIN

	DECLARE @nodeState		NVARCHAR(60);						--node state, i.e. either PRIMARY or SECONDARY
	DECLARE @stopReturn		INT;								--result of stopping @job_id job on non-PRIMARY
	DECLARE	@returnValue	INT;
	DECLARE @returnMessage	VARCHAR(128);

	SET @stopReturn = 0;										--initialise stop job result
	SET @returnValue = 0;										--initialise return value
	SET @returnMessage = 'HCG_AG:';							--initialise return message

	-------------------------------------------------------------------
	--get this node's state, i.e. either PRIMARY or SECONDARY
	SET @returnValue = 0;

	BEGIN TRY

		EXEC @returnValue = [dbo].[AG_GetLocalReplicaState] @availabilityGroupName, @nodeState OUTPUT;

	END TRY
	BEGIN CATCH

		--if execution throws error
		SET @returnValue = 3;
		SET @returnMessage = 'HCG_AG: Cannot execute AG replica state check: dbo.AG_GetLocalReplicaState [' + CAST(@returnValue AS VARCHAR(3)) + '].';

		RAISERROR(@returnMessage, @forcedErrorLevel, 1);
		RETURN @returnValue;

	END CATCH;

	--if replica state not found
	IF (@returnValue <> 0)
	BEGIN

		SET @returnMessage = 'HCG_AG: AG replica state not found [' + CAST(@returnValue AS VARCHAR(3)) + '].';

		RAISERROR(@returnMessage, @forcedErrorLevel, 1);
		RETURN @returnValue;

	END;

	-------------------------------------------------------------------
	--if it's not PRIMARY stop job(@job_id)
	SET @returnValue = 0;
	SET @returnMessage = 'HCG_AG: This is not the primary replica [retVal = ';

	IF (ISNULL(@nodeState, '') <> 'PRIMARY')
	BEGIN

		--try stopping the job
		BEGIN TRY

			--attempt to stop job and capture result of operation
			EXEC @stopReturn = msdb.dbo.sp_stop_job 
				@job_name = NULL,
				@job_id = @job_id,
				@originating_server = NULL,
				@server_name = NULL;

			--if stopping the job is unsuccessfull use forced failure and exit with ERROR code > 0
			IF (@stopReturn <> 0)
			BEGIN

				SET @returnValue = 1;
				SET @returnMessage = @returnMessage + CAST(@returnValue AS VARCHAR(3)) + '].';

				RAISERROR(@returnMessage, @forcedErrorLevel, 1);
				RETURN @returnValue;

			END;

		END TRY
		BEGIN CATCH

			--if stopping the job throws an error use forced failure and exit with ERROR code > 0
			SET @returnValue = 2;
			SET @returnMessage = @returnMessage + CAST(@returnValue AS VARCHAR(3)) + '].';

			RAISERROR(@returnMessage, @forcedErrorLevel, 1);
			RETURN @returnValue;

		END CATCH;

	END; 

	-------------------------------------------------------------------
	--otherwise let it run and exit with SUCCESS code = 0
	RETURN @returnValue;

END;


GO


