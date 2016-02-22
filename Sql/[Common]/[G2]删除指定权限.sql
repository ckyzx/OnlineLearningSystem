USE OLS;

GO

DELETE FROM dbo.Role_Permission;

DELETE FROM dbo.[Permissions] WHERE PC_Id = 12;
DELETE FROM dbo.PermissionCategories WHERE PC_Id = 12;

DELETE FROM dbo.[Permissions] WHERE PC_Id = 13;
DELETE FROM dbo.PermissionCategories WHERE PC_Id = 13;
