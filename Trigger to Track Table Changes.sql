-- Trigger made to keep track of changes to the Orders table, storing changes into a auditing table

CREATE TRIGGER OrdersAudit
ON Orders
AFTER INSERT, UPDATE, DELETE
AS
	DECLARE @Insert BIT = 0;
	DECLARE @Delete BIT = 0;
	IF EXISTS (SELECT * FROM inserted) SET @Insert = 1;
	IF EXISTS (SELECT * FROM deleted) SET @Delete = 1;
	INSERT INTO TablesAudit (TableName, EventType, UserAccount, EventDate)
	SELECT 
	'Orders' AS TableName,
 	CASE 
	 	WHEN @Insert = 1 AND @Delete = 0 THEN 'INSERT'
	 	WHEN @Insert = 1 AND @Delete = 1 THEN 'UPDATE'
	 	WHEN @Insert = 0 AND @Delete = 1 THEN 'DELETE'
 	END AS Event,
   	ORIGINAL_LOGIN() AS UserAccount,
   	GETDATE() AS EventDate
;