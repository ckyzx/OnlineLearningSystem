USE OLS;

GO

DELETE FROM dbo.Role_Permission WHERE R_Id = 1;
DELETE FROM dbo.[Permissions] WHERE PC_Id = 13;
DELETE FROM dbo.PermissionCategories WHERE PC_Id = 13;