USE OLS;

GO

-- 添加存储过程“更新系统管理员角色数据”
IF OBJECT_ID(N'dbo.UpdateAdminRole', 'P') IS NOT NULL 
    DROP PROCEDURE dbo.UpdateAdminRole;

GO

CREATE PROCEDURE UpdateAdminRole
AS -- 更新“系统管理员”角色记录
    DECLARE @table TABLE ( PC_Id INT );
    DECLARE @table1 TABLE ( P_Id INT );
    DECLARE @pcs VARCHAR(500) ,
        @ps VARCHAR(2000);
    DECLARE @id INT;

    SET @pcs = '';
    SET @ps = '';

    INSERT  INTO @table
            SELECT  PC_Id
            FROM    dbo.PermissionCategories
            ORDER BY PC_Id ASC;

    WHILE ( SELECT  COUNT(PC_Id)
            FROM    @table
          ) > 0 
        BEGIN
            SELECT TOP 1
                    @id = PC_Id
            FROM    @table
            ORDER BY PC_Id ASC;
            DELETE  FROM @table
            WHERE   PC_Id = @id;
            SET @pcs = @pcs + CAST(@id AS VARCHAR(5)) + ',';
        END

    SET @pcs = '[' + STUFF(@pcs, LEN(@pcs), 1, ']');

    INSERT  INTO @table1
            SELECT  P_Id
            FROM    dbo.[Permissions]
            ORDER BY P_Id ASC

    WHILE ( SELECT  COUNT(P_Id)
            FROM    @table1
          ) > 0 
        BEGIN
            SELECT TOP 1
                    @id = P_Id
            FROM    @table1
            ORDER BY P_Id ASC;
            DELETE  FROM @table1
            WHERE   P_Id = @id;
            SET @ps = @ps + CAST(@id AS VARCHAR(5)) + ',';
        END

    SET @ps = '[' + STUFF(@ps, LEN(@ps), 1, ']');

    UPDATE  Roles
    SET     R_Permissions = @ps ,
            R_PermissionCategories = @pcs
    WHERE   R_Id = 1

	-- 更新关联记录
    DELETE  FROM dbo.Role_Permission
    WHERE   R_Id = 1;
    INSERT  [dbo].[Role_Permission]
            SELECT  1 ,
                    P_Id
            FROM    dbo.[Permissions]

GO

-- 删除“非系统管理员”角色权限关联
DELETE  FROM dbo.Role_Permission
WHERE   R_Id <> 1;

GO

DELETE  FROM dbo.User_Role;
DELETE  FROM dbo.Department_Role

-- 删除“非系统管理员”角色
DELETE  FROM dbo.Roles
WHERE   R_Id <> 1;

GO

-- 清除部门角色值
UPDATE  dbo.Departments
SET     D_Roles = '[]'

GO

-- 添加新角色
DECLARE @rId INT;

SELECT  @rId = MAX(R_Id) + 1
FROM    Roles;
INSERT  INTO dbo.Roles
        ( R_Id ,
          R_Name ,
          R_Permissions ,
          R_PermissionCategories ,
          R_Remark ,
          R_AddTime ,
          R_Status
        )
VALUES  ( @rId , -- R_Id - int
          N'学员' , -- R_Name - nvarchar(50)
          '[46,47,79,81,89,90,93,94,95,96,168]' , -- R_Permissions - text
          '[6,11]' , -- R_PermissionCategories - text
          N'' , -- R_Remark - nvarchar(200)
          '2016-01-11 11:57:05 ' , -- R_AddTime - datetime2
          1  -- R_Status - tinyint
        )

-- 将所有角色为“非系统管理员”的用户的角色设置为“学员”
UPDATE  Users
SET     U_Roles = '[' + CAST(@rId AS VARCHAR(5)) + ']'
WHERE   CAST(U_Roles AS VARCHAR(1000)) <> '[1]';

GO

EXEC dbo.UpdateAdminRole;

GO

-- 添加用户角色关联
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

-- 添加“非系统管理员”角色权限关联
INSERT  INTO dbo.Role_Permission
        SELECT  2 ,
                P_Id
        FROM    dbo.[Permissions]
        WHERE   PC_Id = 6
                OR PC_Id = 11

GO
