
-- run this script from UKDCX-PC-LARH01
SET NOCOUNT ON;

DECLARE @ServerName NVARCHAR(200), @Sql NVARCHAR(MAX), @MerchantId INT, @Array NVARCHAR(2000) 
SET @ServerName = 'UKDCX-PC-LPST01' --<< insert target server name
SET @MerchantId = 201032 --<< insert Merchantid
SET @Array = '11468295685, 11781917354, 11846767832, 11470287295' --<< insert TMOrder list

BEGIN TRAN
BEGIN TRY
SET @Sql = 'INSERT INTO '+ QUOTENAME(@ServerName) + '.PaymentTrust.dbo.PTT ([PTTID], [TMOrder], [StrId], [OrderNumber], [MerchantId], [CurrencyId], [Amount], [RequestType], [AcctType], [MOP], [AcctName], [AcctNumber], [ExpDate], [StringFromBank], [Result], [OurResult], [AuthCode], [ResponseDate], [RespMsg], [AVSZip], [AVSAddr], [OTStatus], [Settlement], [FinInstId], [Status], [StoreID], [EmployeeId], [TiTle], [FirstName], [MiddleName], [LastName], [Address1], [Address2], [Address3], [City], [StateCode], [ZipCode], [CountryCode], [PhoneType], [PhoneNumber], [PhoneExtension], [ShipToTitle], [ShipToFirstName], [ShipToMiddleName], [ShipToLastName], [ShipToAddress1], [ShipToAddress2], [ShipToAddress3], [ShipToCity], [ShipToStateCode], [ShipToCountryCode], [ShipToZipCode], [ShipToPhoneType], [ShipToPhoneNumber], [ShipToPhoneExtension], [Email], [AvsOption], [TypeOfSale], [REMOTE_ADDR], [HTTP_USER_AGENT], [HTTP_ACCEPT_LANGUAGE], [HTTP_HTTP_CHARSET], [HTTP_REFERER], [StampIn], [StampOut], [TimeOut], [Comment], [TransactionFee], [IssueNumber], [StartDate], [AccountNo], [OutletNo], [MasterCurrencyId], [TriggerOveride], [TrxSourceValue], [Track2], [GCANumber], [Issuer], [SortOrder], [Company], [ShipToCompany], [Suffix], [ShipToSuffix], [CVNResult], [ReconciliationId], [RetrievalReferenceNumber], [oPttId], [DirectAcceptNumber], [FXID], [AcctNumberHash], [AcctNumberCrypt], [ECI], [CAV], [Secure], [SecureID], [ICCType], [ProviderId], [CHEnrolled], [TXStatus], [IssueCountryCode], [STNTime], [IsRT], [RTProfileId], [RTID], [RTMessageCode], [MerchantReference], [AcctNumber2], [AcctNumber2Hash], [AcctNumber2Crypt], [BLId], [MCustomerId], [ServiceBatchId], [AmountCS], [IsPartial], [PFId], [PFName], [PFSubMName], [PFSubMCardAcceptorId], [PFSubMStreet], [PFSubMCity], [PFSubMStateCode], [PFSubMZipCode], [PFSubMCountryCodeISO], [PFSalesOrgId], [PFSubMTaxId], [PFCategory])
  SELECT [PTTID], [TMOrder], [StrId], [OrderNumber], [MerchantId], [CurrencyId], [Amount], [RequestType], [AcctType], [MOP], [AcctName], [AcctNumber], [ExpDate], [StringFromBank], [Result], [OurResult], [AuthCode], [ResponseDate], [RespMsg], [AVSZip], [AVSAddr], [OTStatus], [Settlement], [FinInstId], [Status], [StoreID], [EmployeeId], [TiTle], [FirstName], [MiddleName], [LastName], [Address1], [Address2], [Address3], [City], [StateCode], [ZipCode], [CountryCode], [PhoneType], [PhoneNumber], [PhoneExtension], [ShipToTitle], [ShipToFirstName], [ShipToMiddleName], [ShipToLastName], [ShipToAddress1], [ShipToAddress2], [ShipToAddress3], [ShipToCity], [ShipToStateCode], [ShipToCountryCode], [ShipToZipCode], [ShipToPhoneType], [ShipToPhoneNumber], [ShipToPhoneExtension], [Email], [AvsOption], [TypeOfSale], [REMOTE_ADDR], [HTTP_USER_AGENT], [HTTP_ACCEPT_LANGUAGE], [HTTP_HTTP_CHARSET], [HTTP_REFERER], [StampIn], [StampOut], [TimeOut], [Comment], [TransactionFee], [IssueNumber], [StartDate], [AccountNo], [OutletNo], [MasterCurrencyId], [TriggerOveride], [TrxSourceValue], [Track2], [GCANumber], [Issuer], [SortOrder], [Company], [ShipToCompany], [Suffix], [ShipToSuffix], [CVNResult], [ReconciliationId], [RetrievalReferenceNumber], [oPttId], [DirectAcceptNumber], [FXID], [AcctNumberHash], [AcctNumberCrypt], [ECI], [CAV], [Secure], [SecureID], [ICCType], [ProviderId], [CHEnrolled], [TXStatus], [IssueCountryCode], [STNTime], [IsRT], [RTProfileId], [RTID], [RTMessageCode], [MerchantReference], [AcctNumber2], [AcctNumber2Hash], [AcctNumber2Crypt], [BLId], [MCustomerId], [ServiceBatchId], [AmountCS], [IsPartial], [PFId], [PFName], [PFSubMName], [PFSubMCardAcceptorId], [PFSubMStreet], [PFSubMCity], [PFSubMStateCode], [PFSubMZipCode], [PFSubMCountryCodeISO], [PFSalesOrgId], [PFSubMTaxId], [PFCategory] 
  FROM PaymentTrust.dbo.PTT with (NOLOCK)
WHERE MerchantId = ' + CONVERT(NVARCHAR(16),@MerchantId) + '
   AND TMOrder in (' + @Array + ')  '

PRINT @sql

--EXEC sp_executesql @sql;

END TRY
BEGIN CATCH
		SELECT 
			ERROR_NUMBER() AS ErrorNumber,
			ERROR_MESSAGE() AS ErrorMessage;

		IF @@TRANCOUNT > 0
		ROLLBACK TRAN;
END CATCH

IF @@TRANCOUNT > 0
	COMMIT TRAN;
GO