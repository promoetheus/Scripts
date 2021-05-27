USE TCRBusiness
GO

-- GRANT PERMISSION
GRANT SELECT ON SCHEMA::E_REF TO [WORLDPAY\svc_tcarbussql] WITH GRANT OPTION;;
GO

USE TCRBusiness
GO

select 
 a.*,
 b.name
from sys.database_permissions a
inner join sys.database_principals b
 on a.grantee_principal_id = b.principal_id 
  and b.name = 'WORLDPAY\svc_tcarbussql'


-- revoke if needed
REVOKE GRANT OPTION FOR SELECT ON SCHEMA::[E_REF] TO [WORLDPAY\svc_tcarbussql] CASCADE AS [WORLDPAY\MOOREA576]
GO

