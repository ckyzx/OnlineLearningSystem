USE OLS;

GO

UPDATE  dbo.Departments
SET     D_Name = REPLACE(D_Name, ' ', '')
WHERE   D_Name LIKE '% %'

GO
