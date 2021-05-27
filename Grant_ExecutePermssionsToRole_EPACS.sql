USE EPACS
GO

-- Create the new Role
CREATE ROLE SG_EU_WPAP_APS_Execute;
GO

-- Grant Execute on the specified sp to the new Role
GRANT EXECUTE ON [dbo].[PayeeSingleNameWhitelist_Add_Manual] TO [SG_EU_WPAP_APS_Execute];
GRANT EXECUTE ON [dbo].[PayeeSingleNameWhitelist_Update_Manual] TO [SG_EU_WPAP_APS_Execute];
GRANT EXECUTE ON [dbo].[PayeeSingleNameWhitelist_Delete_Manual] TO [SG_EU_WPAP_APS_Execute]; 
GO

-- Alter Role and add member login
ALTER ROLE [SG_EU_WPAP_APS_Execute] ADD MEMBER [WORLDPAY\SG EU WPAP APS];
GO