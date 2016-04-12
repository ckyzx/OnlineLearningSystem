DECLARE @now VARCHAR(100)
DECLARE @fileName VARCHAR(100)
DECLARE @filePath VARCHAR(500)

SET @now = REPLACE(REPLACE(REPLACE(CONVERT(VARCHAR(100), GETDATE(), 20), '-', ''), ' ', ''), ':', '');
SET @fileName = 'OLS_V0.16_' + @now + '.sqlserver2k8'
-- 下面填入保存数据库备份文件的路径
SET @filePath = 'D:\' + @fileName; -- 例如: 填入 'D:\' + @fileName

BACKUP DATABASE OLS TO DISK = @filePath

GO

USE OLS;

GO

/***************************************************
** [OLS_V0.17]01更改权限名“资料列表”改为“资料管理”.sql
****************************************************/
UPDATE  dbo.[Permissions]
SET     P_Name = '资料管理'
WHERE   P_Controller = 'LearningData'
        AND P_Action = 'List'

GO

/***************************************************
** [OLS_V0.17]02添加权限“获取未答题数量”.sql
****************************************************/
-- 添加存储过程“更新系统管理员角色数据”
IF OBJECT_ID(N'dbo.UpdateAdminRole', 'P') IS NOT NULL 
    DROP PROCEDURE dbo.UpdateAdminRole;

GO

CREATE PROCEDURE UpdateAdminRole
AS -- 更新“系统管理员”角色记录
BEGIN
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
            FROM    dbo.[Permissions];
END
GO

BEGIN
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
END
GO

BEGIN

EXEC dbo.UpdateAdminRole;

END
GO

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

/***************************************************
** [OLS_V0.17]03添加“在线用户（UserOnlines）表”.sql
****************************************************/
IF EXISTS ( SELECT  1
            FROM    sysobjects
            WHERE   id = OBJECT_ID('UserOnlines')
                    AND type = 'U' ) 
    DROP TABLE UserOnlines
   
go

CREATE TABLE UserOnlines
    (
      UO_Id INT NOT NULL
                PRIMARY KEY
                IDENTITY(1, 1) ,
      U_Id INT NOT NULL ,
      UO_Name NVARCHAR(50) NOT NULL ,
      UO_IdCardNumber VARCHAR(20) NOT NULL ,
      UO_RefreshTime DATETIME2 NOT NULL
    )

GO

/***************************************************
** [OLS_V0.17]04添加考试任务字段“持续天数（ET_ContinuedDays）”.sql
****************************************************/
ALTER TABLE dbo.ExaminationTasks
ADD ET_ContinuedDays TINYINT NULL;

GO

UPDATE  dbo.ExaminationTasks
SET     ET_ContinuedDays = 0
WHERE   ET_Mode = 0;
UPDATE  dbo.ExaminationTasks
SET     ET_ContinuedDays = 1
WHERE   ET_Mode <> 0;

GO

ALTER TABLE dbo.ExaminationTasks
ALTER COLUMN ET_ContinuedDays TINYINT NOT NULL;

GO

ALTER TABLE dbo.ExaminationTaskTemplates
ADD ETT_ContinuedDays TINYINT NULL;

GO

UPDATE  dbo.ExaminationTaskTemplates
SET     ETT_ContinuedDays = 0
WHERE   ETT_Mode = 0;
UPDATE  dbo.ExaminationTaskTemplates
SET     ETT_ContinuedDays = 1
WHERE   ETT_Mode <> 0;

GO

ALTER TABLE dbo.ExaminationTaskTemplates
ALTER COLUMN ETT_ContinuedDays TINYINT NOT NULL;

GO

/***************************************************
** [OLS_V0.17]05添加权限“刷新在线时间”和“在线用户列表”.sql
****************************************************/
BEGIN
DELETE FROM dbo.Role_Permission;
DELETE FROM [dbo].[Permissions] WHERE P_Id IN (171, 172);
END
GO

BEGIN
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
END
GO

BEGIN

EXEC dbo.UpdateAdminRole;

END
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
