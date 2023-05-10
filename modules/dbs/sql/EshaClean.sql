UPDATE dbo.UPreferences SET PreferenceValue = '$(esha_genesis_serial_key)' WHERE PreferenceName = 'GenSerialKey';
UPDATE dbo.UPreferences SET PreferenceValue = '$(esha_port_sql_serial_key)' WHERE PreferenceName = 'ESHAPortSerialKey';
UPDATE dbo.UPreferences SET PreferenceValue = '$(esha_customer_number)' WHERE PreferenceName = 'CustomerNumber';
DELETE FROM dbo.UMachineActivations;