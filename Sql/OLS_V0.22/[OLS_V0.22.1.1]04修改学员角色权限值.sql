USE OLS;

GO

IF OBJECT_ID(N'dbo.UpdateStudentRole', 'P') IS NOT NULL 
    DROP PROCEDURE dbo.UpdateStudentRole;

GO

CREATE PROCEDURE dbo.UpdateStudentRole
AS 
    DELETE  FROM dbo.User_Role
    WHERE   R_Id = 2;
    

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


    DELETE  FROM dbo.Role_Permission
    WHERE   R_Id = 2;


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


	-- 获取学员权限值
    DECLARE @permission VARCHAR(5000);

    SET @permission = '';

    SELECT  @permission = @permission + CAST(P_Id AS VARCHAR(5000)) + ','
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
    SET @permission = '[' + STUFF(@permission, LEN(@permission), 1, ']');

	-- 修改学员权限值
    UPDATE  dbo.Roles
    SET     R_PermissionCategories = '[6,11,13]' ,
            R_Permissions = @permission
    WHERE   R_Id = 2;

GO

EXEC dbo.UpdateStudentRole;

EXEC dbo.UpdateAdminRole;

GO
