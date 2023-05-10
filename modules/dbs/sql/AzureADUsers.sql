CREATE USER [$(adgroup)] FROM EXTERNAL PROVIDER
GO
EXEC sp_addrolemember 'db_datareader', '$(adgroup)';  
GO