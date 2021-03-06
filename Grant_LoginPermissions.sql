SET NOCOUNT ON;
DECLARE @rws INT=1, @rwcnt INT, @DBName NVARCHAR(MAX), @SQL NVARCHAR(MAX)
DECLARE @T AS TABLE (ID INT IDENTITY(1,1), DBName NVARCHAR(MAX), processed BIT DEFAULT 0)
INSERT INTO @T (DBName)
VALUES ('BO_DATA'), ('CHARGEB_RFI'), ('COSTING'),('Costing_model'),('EMIS'), ('EURO_CHB'), ('IMS_RECONCILIATION'), ('IMSFRD'), ('INTCHG_CHECK'),('IVOR'), ('MARKET_SHARE'),('MERLIN'), 
	('POFFLE_INT'), ('POFFSTATIC'), ('RAMISYS_CC'), ('RAMISYS_MI'), ('RS_RISK'), ('Saramis'), ('sl_auths'), ('sl_trans'), ('transmis'), ('USER_RS') 
--SELECT ID, DBName, processed FROM @T
--SELECT @@rowcount

SET @rwcnt = @@rowcount

WHILE @rws <= @rwcnt
	BEGIN
		SET @DBName = (SELECT DBName FROM @T WHERE id = @rws)

		SET @SQL = 'USE ' + @DBName + '
					CREATE USER [WORLDPAY\SG EU EDP SQLServer Data Readers] FOR LOGIN [WORLDPAY\SG EU EDP SQLServer Data Readers]
					USE ' + @DBName + '
					ALTER ROLE [db_datareader] ADD MEMBER [WORLDPAY\SG EU EDP SQLServer Data Readers]'

		EXEC sys.sp_executesql @SQL
		--PRINT @SQL
		SET @rws = @rws + 1;
	END

						
		
	
