use Redirect
go
Create role [db_HCG_App_Support]
Go

use Redirect
go
Alter Role [db_HCG_App_Support] ADD MEMBER [WORLDPAY\p-sql-hcg-prod-dbaccess-appsuport]
GO

-- Grant Insert / Update permissions to Role [db_HCG_App_Support]
GRANT INSERT ON [dbo].[MerchantCardLogoConfig] TO [db_HCG_App_Support];
Go
GRANT UPDATE ON [dbo].[MerchantCardLogoConfig] TO [db_HCG_App_Support];
Go

-- Grant execute permissions to the below SP's for the service accounts:
--> WORLDPAY\svc_hcg_rdpymt_frm
--> WORLDPAY\svc_hcg_rdpymt_frm_l

/**

[data].[SetCardLogoConfig], 
[data].[SetMerchantCardLogoConfig]
[dbo].[GetCardLogoConfig], 
[dbo].[GetMerchantCardLogoConfig]

**/

grant execute on [data].[SetCardLogoConfig] to [WORLDPAY\svc_hcg_rdpymt_frm_l];


