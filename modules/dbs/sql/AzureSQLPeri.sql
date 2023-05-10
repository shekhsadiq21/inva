
		
-- Add Database Users     
  

	CREATE USER Plum with password = '$(db_pass)' 
	GO
	CREATE USER PeriScope with password = '$(db_pass)' 
	GO
	CREATE USER FreshTrax with password = '$(db_pass)'
	GO
   
	
    
	GRANT ALL to Plum
	GRANT ALL to PeriScope
	GRANT ALL to FreshTrax

-- Grant db_owner role prior to creating tables, It is a must.
	ALTER ROLE db_owner ADD MEMBER Plum
	GO
	ALTER ROLE db_owner ADD MEMBER PeriScope
	GO
	ALTER ROLE db_owner ADD MEMBER FreshTrax
	GO
	
	


IF NOT EXISTS (
	SELECT SCHEMA_NAME
	FROM INFORMATION_SCHEMA.SCHEMATA
	WHERE SCHEMA_NAME='Plum' )
BEGIN
	EXEC sp_executesql N'CREATE SCHEMA Plum AUTHORIZATION dbo'
END

IF NOT EXISTS (
	SELECT SCHEMA_NAME
	FROM INFORMATION_SCHEMA.SCHEMATA
	WHERE SCHEMA_NAME='Periscope' )
BEGIN
	EXEC sp_executesql N'CREATE SCHEMA Periscope AUTHORIZATION dbo'
END

IF NOT EXISTS (
	SELECT SCHEMA_NAME
	FROM INFORMATION_SCHEMA.SCHEMATA
	WHERE SCHEMA_NAME='FreshTrax' )
BEGIN
	EXEC sp_executesql N'CREATE SCHEMA FreshTrax AUTHORIZATION dbo'
END
