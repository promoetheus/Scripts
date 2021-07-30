--FWIW : Encrypt / Decrypt Test , Obviously you need to pass in the string to decrypt that has been encrypted



DECLARE @RC int

DECLARE @TransType varchar(2)

DECLARE @StringIn varchar(120)

DECLARE @Encrypted varchar(120)

EXECUTE @RC = [STCryptAdmin].[dbo].[EncryptAes256] 

   'PT'

  ,'Live2016'

  ,@Encrypted OUTPUT

print @Encrypted 


go
DECLARE @RC int

DECLARE @TransType varchar(2)

DECLARE @StringIn varchar(120)

DECLARE @Encrypted varchar(120)

EXECUTE @RC = [STCryptAdmin].[dbo].[DecryptAes256] 

   'PT'

  ,'AFhFtRqWGKDhiHFlkKnZoQEAAAB3bAlrPQHmVI6saRnLqiFhC7ia8Gr+rNa4NOpppPd88Amz/Dc9PjsQj/WDyIjxJJY='

  ,@Encrypted OUTPUT

print @Encrypted 
