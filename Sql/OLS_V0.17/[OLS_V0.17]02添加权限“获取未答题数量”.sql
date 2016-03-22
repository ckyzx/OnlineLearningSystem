USE OLS;

GO

/*-- 添加存储过程“更新系统管理员角色数据”
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
            WHERE   P_Name <> '资料列表'
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

DECLARE @pcId INT ,
    @pId INT;

SELECT  @pcId = 6;
SELECT  @pId = MAX(P_Id) + 1
FROM    dbo.[Permissions]

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
          N'获取未答题数量' ,
          N'ExaminationPaper' ,
          N'GetUndoNumber' ,
          NULL ,
          CAST(0x079DAEB04D8BAB3A0B AS DATETIME2)
        )

SET IDENTITY_INSERT [dbo].[Permissions] OFF

GO

EXEC dbo.UpdateAdminRole;

GO*/

-- 更新“学员”角色权限
UPDATE  dbo.Roles
SET     R_Permissions = '[46,47,89,90,130,168,170,79,81,93,94,95,96,131,132,148,158,159]' ,
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
