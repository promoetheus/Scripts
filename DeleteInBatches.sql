--Check the counts:
use DB;

--Data checks:
declare @DateToOverwrite DATE = '2025-10-08'

--Count of rows to delete
select count(*) FROM reports.T1 WHERE Date = @DateToOverwrite;

--Count of rows expected to be inserted
select count(*)
FROM metrics.T1
WHERE
    Scope IN ('All', 'Qualified', 'Unvalidated')
  AND Date = @DateToOverwrite;
go
--2. Delete the data in batches
SET NOCOUNT ON;

DECLARE @RowCount INT = 1;
DECLARE @BatchSize INT = 10000;
DECLARE @Message VARCHAR(255)

declare @DateToOverwrite DATE = '2025-10-08'

WHILE @RowCount > 0
    begin
        delete TOP (@BatchSize) from reports.T1 where Date = @DateToOverwrite;

        SET @RowCount = @@ROWCOUNT;
        SET @Message = 'Deleted: ' + CAST(@RowCount AS VARCHAR(11)) + ' row(s) from table: reports.T1';

        RAISERROR (@Message,0,1) WITH NOWAIT

        RAISERROR ('WAITFOR DELAY ''00:00:01''',0,1) WITH NOWAIT
        WAITFOR DELAY '00:00:01';
    end;
--3. Insert new data
INSERT INTO reports.T1 (DealId,
                                             Date,
                                             LastUpdatedAtUtc,
                                             Scope,
                                             AvailCount)
SELECT
    DealId, Date, CAST(LastUpdatedAtUtc AS datetime2), Scope, AvailCount
FROM metrics.T1
WHERE
    Scope IN ('All', 'Qualified', 'Unvalidated')
  AND Date = '2025-10-08';
