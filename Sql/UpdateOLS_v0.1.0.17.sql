BEGIN TRAN UpdateSql_v01017

USE OLS;

GO

UPDATE Departments SET D_Name = '新陂分局（大税源管理分局）' WHERE D_Name = '新陂分局（大税源管理分局） '

GO

COMMIT TRAN UpdateSql_v01017