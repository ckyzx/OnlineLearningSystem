USE OLS;

GO

DELETE FROM dbo.Role_Permission;

GO

DELETE FROM [dbo].[Permissions] WHERE P_Id IN (171, 172);

GO

DECLARE @pcId INT ,
    @pId INT;

SET  @pcId = 6;
SET  @pId = 171;

-- 添加权限值
SET IDENTITY_INSERT [dbo].[Permissions] ON

INSERT  [dbo].[Permissions]
        ( P_Id ,
          P_AutoId ,
          PC_Id ,
          P_Name ,
          P_Controller ,
          P_Action ,
          P_Remark ,
          P_AddTime
        )
VALUES  ( @pId ,
          @pId ,
          @pcId ,
          N'刷新在线时间' ,
          N'User' ,
          N'RefreshTime' ,
          NULL ,
          CAST(0x079DAEB04D8BAB3A0B AS DATETIME2)
        )
        
SET  @pcId = 5;
SET @pId = @pId + 1;
INSERT  [dbo].[Permissions]
        ( P_Id ,
          P_AutoId ,
          PC_Id ,
          P_Name ,
          P_Controller ,
          P_Action ,
          P_Remark ,
          P_AddTime
        )
VALUES  ( @pId ,
          @pId ,
          @pcId ,
          N'在线用户列表' ,
          N'User' ,
          N'ListOnline' ,
          NULL ,
          CAST(0x079DAEB04D8BAB3A0B AS DATETIME2)
        )

SET IDENTITY_INSERT [dbo].[Permissions] OFF

GO

EXEC dbo.UpdateAdminRole;

GO

-- 更新“学员”角色权限
UPDATE  dbo.Roles
SET     R_Permissions = '[46,47,89,90,130,168,170,171,79,81,93,94,95,96,131,132,148,158,159]' ,
        R_PermissionCategories = '[6,11,13]'
WHERE   R_Name = '学员'

GO

DELETE FROM dbo.Role_Permission WHERE R_Id = 2;

GO

-- 添加“非系统管理员”角色权限关联
INSERT  INTO dbo.Role_Permission
        SELECT  2 ,
                P_Id
        FROM    dbo.[Permissions]
        WHERE   PC_Id = 6
                OR PC_Id = 11
                OR P_Id IN (148,158,159)

GO
