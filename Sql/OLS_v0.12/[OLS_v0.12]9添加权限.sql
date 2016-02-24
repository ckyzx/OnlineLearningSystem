USE OLS;

GO

DECLARE @pcId INT;

SELECT  @pcId = MAX(PC_Id) + 1
FROM    dbo.PermissionCategories;

/* 添加“用户成绩”角色权限 */
-- 添加权限目录“数据统计”
SET IDENTITY_INSERT dbo.PermissionCategories ON

INSERT  INTO dbo.PermissionCategories
        ( PC_Id ,
          PC_AutoId ,
          PC_Name ,
          PC_Level ,
          PC_Remark ,
          PC_AddTime ,
          PC_Status
        )
VALUES  ( @pcId ,
          @pcId ,
          '数据统计' ,
          '00' + CAST(@pcId AS VARCHAR(10)) ,
          NULL ,
          CAST(0x079DAEB04D8BAB3A0B AS DATETIME2) ,
          1
        )

SET IDENTITY_INSERT dbo.PermissionCategories OFF

GO

DECLARE @pcId INT ,
    @pId INT;

SELECT  @pcId = MAX(PC_Id)
FROM    dbo.PermissionCategories;
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
          N'用户成绩概览' ,
          N'UserScore' ,
          N'ListSummary' ,
          NULL ,
          CAST(0x079DAEB04D8BAB3A0B AS DATETIME2)
        )

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
          N'查询用户成绩概览' ,
          N'UserScore' ,
          N'ListSummaryDataTablesAjax' ,
          NULL ,
          CAST(0x079DAEB04D8BAB3A0B AS DATETIME2)
        )

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
          N'用户成绩详情' ,
          N'UserScore' ,
          N'ListDetail' ,
          NULL ,
          CAST(0x079DAEB04D8BAB3A0B AS DATETIME2)
        )

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
          N'查询用户成绩详情' ,
          N'UserScore' ,
          N'ListDetailDataTablesAjax' ,
          NULL ,
          CAST(0x079DAEB04D8BAB3A0B AS DATETIME2)
        )

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
          N'导出用户成绩概览到表格' ,
          N'UserScore' ,
          N'SummaryExportToExcel' ,
          NULL ,
          CAST(0x079DAEB04D8BAB3A0B AS DATETIME2)
        )

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
          N'导出用户成绩详情到表格' ,
          N'UserScore' ,
          N'DetailExportToExcel' ,
          NULL ,
          CAST(0x079DAEB04D8BAB3A0B AS DATETIME2)
        )

SET IDENTITY_INSERT [dbo].[Permissions] OFF

GO

-- 添加关联记录
DELETE  FROM dbo.Role_Permission
WHERE   R_Id = 1;
INSERT  [dbo].[Role_Permission]
        SELECT  1 ,
                P_Id
        FROM    dbo.[Permissions]

GO

-- 更新角色记录
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

GO
