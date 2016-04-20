USE OLS;

GO

DELETE  FROM dbo.User_Role;

GO

-- 添加[用户角色关联]
INSERT  INTO dbo.User_Role
        ( U_Id, R_Id )
VALUES  ( 1, -- U_Id - int
          1  -- R_Id - int
          )
INSERT  INTO dbo.User_Role
        SELECT  U_Id ,
                2
        FROM    Users
        WHERE   U_Id <> 1

GO

DELETE  FROM dbo.Role_Permission;

GO

-- 添加学员[角色权限关联]
INSERT  INTO dbo.Role_Permission
        SELECT  2 ,
                P_Id
        FROM    dbo.[Permissions]
        WHERE   PC_Id = 6
                OR PC_Id = 11
                OR ( P_Controller = 'LearningData'
                     AND P_Action = 'ListDataTablesAjax'
                   )
                OR ( P_Controller = 'LearningData'
                     AND P_Action = 'ListStudent'
                   )
                OR ( P_Controller = 'LearningData'
                     AND P_Action = 'View'
                   )

GO

-- 修改学员权限值
UPDATE  dbo.Roles
SET     R_PermissionCategories = '[6,11,13]' ,
        R_Permissions = '[46,47,79,81,89,90,93,94,95,96,130,131,132,148,158,159,168,170,171]'
WHERE   R_Id = 2;

GO

EXEC dbo.UpdateAdminRole;

GO
