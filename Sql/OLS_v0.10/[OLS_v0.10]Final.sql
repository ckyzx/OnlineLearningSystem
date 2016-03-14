-- [1]备份数据库
DECLARE @now VARCHAR(100)
DECLARE @fileName VARCHAR(100)
DECLARE @filePath VARCHAR(500)

SET @now = REPLACE(REPLACE(REPLACE(CONVERT(VARCHAR(100), GETDATE(), 20), '-', ''), ' ', ''), ':', '');
SET @fileName = 'OLS_' + @now + '.sqlserver2k8'
-- 下面填入保存数据库备份文件的路径
-- 例如: 填入 'D:\' + @fileName
SET @filePath = 'D:\' + @fileName;

BACKUP DATABASE OLS TO DISK = @filePath

GO

USE OLS;

GO

/* ------------------------------ 添加试卷试题外键关联 ------------------------------ */

ALTER TABLE dbo.ExaminationPaperQuestions
ADD CONSTRAINT FK_EPQ_EPTQ FOREIGN KEY (EPQ_Id)
REFERENCES dbo.ExaminationPaperTemplateQuestions (EPTQ_Id)

GO

/* ------------------------------ 添加资料库 ------------------------------ */

IF EXISTS ( SELECT  1
            FROM    sys.sysreferences r
                    JOIN sys.sysobjects o ON ( o.id = r.constid
                                               AND o.type = 'F'
                                             )
            WHERE   r.fkeyid = OBJECT_ID('LearningDatas')
                    AND o.name = 'FK_LD_LDC' ) 
    ALTER TABLE LearningDatas
    DROP CONSTRAINT FK_LD_LDC

GO

IF EXISTS ( SELECT  1
            FROM    sys.sysobjects
            WHERE   id = OBJECT_ID('LearningDataCategories')
                    AND type = 'U' ) 
    DROP TABLE LearningDataCategories;

IF EXISTS ( SELECT  1
            FROM    dbo.sysobjects
            WHERE   id = OBJECT_ID('LearningDatas')
                    AND type = 'U' ) 
    DROP TABLE LearningDatas
    
GO

/*==============================================================*/
/* Table: LearningDataCategories                                */
/*==============================================================*/
CREATE TABLE LearningDataCategories
    (
      LDC_Id INT NOT NULL ,
      LDC_AutoId INT IDENTITY ,
      LDC_Name VARCHAR(200) NOT NULL ,
      LDC_Remark VARCHAR(200) NULL ,
      LDC_AddTime DATETIME2 NOT NULL ,
      LDC_Status TINYINT NOT NULL,
      LDC_Sort FLOAT NOT NULL,
      CONSTRAINT PK_LEARNINGDATACLASSIFY PRIMARY KEY ( LDC_Id )
    )
GO

/*==============================================================*/
/* Table: LearningDatas                                         */
/*==============================================================*/
CREATE TABLE LearningDatas
    (
      LD_Id INT NOT NULL ,
      LD_AutoId INT IDENTITY ,
      LD_Title VARCHAR(200) NOT NULL ,
      LDC_Id INT NULL ,
      LD_Content TEXT NOT NULL ,
      LD_Remark VARCHAR(200) NULL ,
      LD_AddTime DATETIME2 NOT NULL ,
      LD_Status TINYINT NOT NULL,
      LD_Sort FLOAT NOT NULL,
      CONSTRAINT PK_LEARNINGDATAS PRIMARY KEY ( LD_Id )
    )
GO

ALTER TABLE LearningDatas
ADD CONSTRAINT FK_LD_LDC FOREIGN KEY (LDC_Id)
REFERENCES LearningDataCategories (LDC_Id)

GO

/* ------------------------------ 添加权限 ------------------------------ */

DELETE FROM [dbo].[Role_Permission];

DELETE FROM dbo.[Permissions] WHERE PC_Id = 12;
DELETE FROM dbo.PermissionCategories WHERE PC_Id = 12;

DELETE FROM dbo.[Permissions] WHERE PC_Id = 13;
DELETE FROM dbo.PermissionCategories WHERE PC_Id = 13;

DELETE FROM dbo.[Permissions] WHERE PC_Id = 14;
DELETE FROM dbo.PermissionCategories WHERE PC_Id = 14;

GO

/* 添加“系统日志”角色权限 */
-- 添加权限目录
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
VALUES  ( 12 ,
          12 ,
          '日志管理' ,
          '0012' ,
          NULL ,
          CAST(0x079DAEB04D8BAB3A0B AS DATETIME2) ,
          1
        )

SET IDENTITY_INSERT dbo.PermissionCategories OFF

GO

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
VALUES  ( 133 ,
          133 ,
          12 ,
          N'系统日志列表' ,
          N'SystemLog' ,
          N'List' ,
          NULL ,
          CAST(0x079DAEB04D8BAB3A0B AS DATETIME2)
        )
        
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
VALUES  ( 134 ,
          134 ,
          12 ,
          N'查询系统日志' ,
          N'SystemLog' ,
          N'ListDataTablesAjax' ,
          NULL ,
          CAST(0x079DAEB04D8BAB3A0B AS DATETIME2)
        )
                
SET IDENTITY_INSERT [dbo].[Permissions] OFF

-- 添加关联记录
INSERT  [dbo].[Role_Permission]
        SELECT  1 ,
                133
        UNION ALL
        SELECT  1 ,
                134

GO

/* 添加“查询考试任务”权限 */
-- 添加权限值
SET IDENTITY_INSERT [dbo].[Permissions] ON

IF EXISTS(SELECT P_Id FROM dbo.[Permissions] WHERE P_Id = 135)
	DELETE FROM dbo.[Permissions] WHERE P_Id = 135;
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
VALUES  ( 135 ,
          135 ,
          9 ,
          N'查询考试任务' ,
          N'ExaminationTask' ,
          N'ListDataTablesAjaxByMode' ,
          NULL ,
          CAST(0x079DAEB04D8BAB3A0B AS DATETIME2)
        )
                
SET IDENTITY_INSERT [dbo].[Permissions] OFF

GO

-- 添加关联记录
INSERT  [dbo].[Role_Permission]
        SELECT  1 ,
                135

GO

/* 添加“资料目录”权限 */
-- 添加权限目录
SET IDENTITY_INSERT dbo.PermissionCategories ON

INSERT  INTO PermissionCategories
        ( PC_Id ,
          PC_AutoId ,
          PC_Name ,
          PC_Level ,
          PC_Remark ,
          PC_AddTime ,
          PC_Status
        )
VALUES  ( 13 ,
          13 ,
          '资料库管理' ,
          '0013' ,
          NULL ,
          CAST(0x079DAEB04D8BAB3A0B AS DATETIME2) ,
          1
        )

SET IDENTITY_INSERT dbo.PermissionCategories OFF

-- 添加权限值
SET IDENTITY_INSERT [dbo].[Permissions] ON

INSERT  INTO [dbo].[Permissions]
        ( P_Id ,
          P_AutoId ,
          PC_Id ,
          P_Name ,
          P_Controller ,
          P_Action ,
          P_Remark ,
          P_AddTime
        )
VALUES  ( 136 ,
          136 ,
          13 ,
          N'资料目录列表' ,
          N'LearningDataCategory' ,
          N'List' ,
          NULL ,
          CAST(0x079DAEB04D8BAB3A0B AS DATETIME2)
        )

INSERT  INTO [dbo].[Permissions]
        ( P_Id ,
          P_AutoId ,
          PC_Id ,
          P_Name ,
          P_Controller ,
          P_Action ,
          P_Remark ,
          P_AddTime
        )
VALUES  ( 137 ,
          137 ,
          13 ,
          N'查询资料目录' ,
          N'LearningDataCategory' ,
          N'ListDataTablesAjax' ,
          NULL ,
          CAST(0x079DAEB04D8BAB3A0B AS DATETIME2)
        )

INSERT  INTO [dbo].[Permissions]
        ( P_Id ,
          P_AutoId ,
          PC_Id ,
          P_Name ,
          P_Controller ,
          P_Action ,
          P_Remark ,
          P_AddTime
        )
VALUES  ( 138 ,
          138 ,
          13 ,
          '新建资料目录' ,
          'LearningDataCategory' ,
          'Create' ,
          NULL ,
          CAST(0x079DAEB04D8BAB3A0B AS DATETIME2)
        )
INSERT  INTO [dbo].[Permissions]
        ( P_Id ,
          P_AutoId ,
          PC_Id ,
          P_Name ,
          P_Controller ,
          P_Action ,
          P_Remark ,
          P_AddTime
        )
VALUES  ( 139 ,
          139 ,
          13 ,
          '添加资料目录' ,
          'LearningDataCategory' ,
          'Create' ,
          NULL ,
          CAST(0x079DAEB04D8BAB3A0B AS DATETIME2)
        )
INSERT  INTO [dbo].[Permissions]
        ( P_Id ,
          P_AutoId ,
          PC_Id ,
          P_Name ,
          P_Controller ,
          P_Action ,
          P_Remark ,
          P_AddTime
        )
VALUES  ( 140 ,
          140 ,
          13 ,
          '查看资料目录' ,
          'LearningDataCategory' ,
          'Edit' ,
          NULL ,
          CAST(0x079DAEB04D8BAB3A0B AS DATETIME2)
        )
INSERT  INTO [dbo].[Permissions]
        ( P_Id ,
          P_AutoId ,
          PC_Id ,
          P_Name ,
          P_Controller ,
          P_Action ,
          P_Remark ,
          P_AddTime
        )
VALUES  ( 141 ,
          141 ,
          13 ,
          '修改资料目录' ,
          'LearningDataCategory' ,
          'Edit' ,
          NULL ,
          CAST(0x079DAEB04D8BAB3A0B AS DATETIME2)
        )
INSERT  INTO [dbo].[Permissions]
        ( P_Id ,
          P_AutoId ,
          PC_Id ,
          P_Name ,
          P_Controller ,
          P_Action ,
          P_Remark ,
          P_AddTime
        )
VALUES  ( 142 ,
          142 ,
          13 ,
          '回收资料目录' ,
          'LearningDataCategory' ,
          'Recycle' ,
          NULL ,
          CAST(0x079DAEB04D8BAB3A0B AS DATETIME2)
        )
INSERT  INTO [dbo].[Permissions]
        ( P_Id ,
          P_AutoId ,
          PC_Id ,
          P_Name ,
          P_Controller ,
          P_Action ,
          P_Remark ,
          P_AddTime
        )
VALUES  ( 143 ,
          143 ,
          13 ,
          '恢复资料目录' ,
          'LearningDataCategory' ,
          'Resume' ,
          NULL ,
          CAST(0x079DAEB04D8BAB3A0B AS DATETIME2)
        )
INSERT  INTO [dbo].[Permissions]
        ( P_Id ,
          P_AutoId ,
          PC_Id ,
          P_Name ,
          P_Controller ,
          P_Action ,
          P_Remark ,
          P_AddTime
        )
VALUES  ( 144 ,
          144 ,
          13 ,
          '删除资料目录' ,
          'LearningDataCategory' ,
          'Delete' ,
          NULL ,
          CAST(0x079DAEB04D8BAB3A0B AS DATETIME2)
        )

INSERT  INTO [dbo].[Permissions]
        ( P_Id ,
          P_AutoId ,
          PC_Id ,
          P_Name ,
          P_Controller ,
          P_Action ,
          P_Remark ,
          P_AddTime
        )
VALUES  ( 145 ,
          145 ,
          13 ,
          '检查资料目录名称' ,
          'LearningDataCategory' ,
          'DuplicateName' ,
          NULL ,
          CAST(0x079DAEB04D8BAB3A0B AS DATETIME2)
        )

INSERT  INTO [dbo].[Permissions]
        ( P_Id ,
          P_AutoId ,
          PC_Id ,
          P_Name ,
          P_Controller ,
          P_Action ,
          P_Remark ,
          P_AddTime
        )
VALUES  ( 146 ,
          146 ,
          13 ,
          '资料目录排序' ,
          'LearningDataCategory' ,
          'Sort' ,
          NULL ,
          CAST(0x079DAEB04D8BAB3A0B AS DATETIME2)
        )

SET IDENTITY_INSERT [dbo].[Permissions] OFF

GO

/* 添加“资料”权限 */
-- 添加权限值
SET IDENTITY_INSERT [dbo].[Permissions] ON

INSERT  INTO [dbo].[Permissions]
        ( P_Id ,
          P_AutoId ,
          PC_Id ,
          P_Name ,
          P_Controller ,
          P_Action ,
          P_Remark ,
          P_AddTime
        )
VALUES  ( 147 ,
          147 ,
          13 ,
          N'资料列表' ,
          N'LearningData' ,
          N'List' ,
          NULL ,
          CAST(0x079DAEB04D8BAB3A0B AS DATETIME2)
        )

INSERT  INTO [dbo].[Permissions]
        ( P_Id ,
          P_AutoId ,
          PC_Id ,
          P_Name ,
          P_Controller ,
          P_Action ,
          P_Remark ,
          P_AddTime
        )
VALUES  ( 148 ,
          148 ,
          13 ,
          N'查询资料' ,
          N'LearningData' ,
          N'ListDataTablesAjax' ,
          NULL ,
          CAST(0x079DAEB04D8BAB3A0B AS DATETIME2)
        )

INSERT  INTO [dbo].[Permissions]
        ( P_Id ,
          P_AutoId ,
          PC_Id ,
          P_Name ,
          P_Controller ,
          P_Action ,
          P_Remark ,
          P_AddTime
        )
VALUES  ( 149 ,
          149 ,
          13 ,
          '新建资料' ,
          'LearningData' ,
          'Create' ,
          NULL ,
          CAST(0x079DAEB04D8BAB3A0B AS DATETIME2)
        )
INSERT  INTO [dbo].[Permissions]
        ( P_Id ,
          P_AutoId ,
          PC_Id ,
          P_Name ,
          P_Controller ,
          P_Action ,
          P_Remark ,
          P_AddTime
        )
VALUES  ( 150 ,
          150 ,
          13 ,
          '添加资料' ,
          'LearningData' ,
          'Create' ,
          NULL ,
          CAST(0x079DAEB04D8BAB3A0B AS DATETIME2)
        )
INSERT  INTO [dbo].[Permissions]
        ( P_Id ,
          P_AutoId ,
          PC_Id ,
          P_Name ,
          P_Controller ,
          P_Action ,
          P_Remark ,
          P_AddTime
        )
VALUES  ( 151 ,
          151 ,
          13 ,
          '查看资料' ,
          'LearningData' ,
          'Edit' ,
          NULL ,
          CAST(0x079DAEB04D8BAB3A0B AS DATETIME2)
        )
INSERT  INTO [dbo].[Permissions]
        ( P_Id ,
          P_AutoId ,
          PC_Id ,
          P_Name ,
          P_Controller ,
          P_Action ,
          P_Remark ,
          P_AddTime
        )
VALUES  ( 152 ,
          152 ,
          13 ,
          '修改资料' ,
          'LearningData' ,
          'Edit' ,
          NULL ,
          CAST(0x079DAEB04D8BAB3A0B AS DATETIME2)
        )
INSERT  INTO [dbo].[Permissions]
        ( P_Id ,
          P_AutoId ,
          PC_Id ,
          P_Name ,
          P_Controller ,
          P_Action ,
          P_Remark ,
          P_AddTime
        )
VALUES  ( 153 ,
          153 ,
          13 ,
          '回收资料' ,
          'LearningData' ,
          'Recycle' ,
          NULL ,
          CAST(0x079DAEB04D8BAB3A0B AS DATETIME2)
        )
INSERT  INTO [dbo].[Permissions]
        ( P_Id ,
          P_AutoId ,
          PC_Id ,
          P_Name ,
          P_Controller ,
          P_Action ,
          P_Remark ,
          P_AddTime
        )
VALUES  ( 154 ,
          154 ,
          13 ,
          '恢复资料' ,
          'LearningData' ,
          'Resume' ,
          NULL ,
          CAST(0x079DAEB04D8BAB3A0B AS DATETIME2)
        )
INSERT  INTO [dbo].[Permissions]
        ( P_Id ,
          P_AutoId ,
          PC_Id ,
          P_Name ,
          P_Controller ,
          P_Action ,
          P_Remark ,
          P_AddTime
        )
VALUES  ( 155 ,
          155 ,
          13 ,
          '删除资料' ,
          'LearningData' ,
          'Delete' ,
          NULL ,
          CAST(0x079DAEB04D8BAB3A0B AS DATETIME2)
        )

INSERT  INTO [dbo].[Permissions]
        ( P_Id ,
          P_AutoId ,
          PC_Id ,
          P_Name ,
          P_Controller ,
          P_Action ,
          P_Remark ,
          P_AddTime
        )
VALUES  ( 156 ,
          156 ,
          13 ,
          '检查资料标题' ,
          'LearningData' ,
          'DuplicateName' ,
          NULL ,
          CAST(0x079DAEB04D8BAB3A0B AS DATETIME2)
        )

INSERT  INTO [dbo].[Permissions]
        ( P_Id ,
          P_AutoId ,
          PC_Id ,
          P_Name ,
          P_Controller ,
          P_Action ,
          P_Remark ,
          P_AddTime
        )
VALUES  ( 157 ,
          157 ,
          13 ,
          '资料排序' ,
          'LearningData' ,
          'Sort' ,
          NULL ,
          CAST(0x079DAEB04D8BAB3A0B AS DATETIME2)
        )

INSERT  INTO [dbo].[Permissions]
        ( P_Id ,
          P_AutoId ,
          PC_Id ,
          P_Name ,
          P_Controller ,
          P_Action ,
          P_Remark ,
          P_AddTime
        )
VALUES  ( 158 ,
          158 ,
          13 ,
          '查看资料' ,
          'LearningData' ,
          'View' ,
          NULL ,
          CAST(0x079DAEB04D8BAB3A0B AS DATETIME2)
        )

INSERT  INTO [dbo].[Permissions]
        ( P_Id ,
          P_AutoId ,
          PC_Id ,
          P_Name ,
          P_Controller ,
          P_Action ,
          P_Remark ,
          P_AddTime
        )
VALUES  ( 159 ,
          159 ,
          13 ,
          '资料列表，学员后台' ,
          'LearningData' ,
          'ListStudent' ,
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

-- 设置用户公共权限
INSERT [dbo].[Role_Permission]
SELECT R_Id, 46 FROM dbo.Roles WHERE R_Id <> 1
UNION ALL
SELECT R_Id, 47 FROM dbo.Roles WHERE R_Id <> 1
UNION ALL
SELECT R_Id, 79 FROM dbo.Roles WHERE R_Id <> 1
UNION ALL
SELECT R_Id, 81 FROM dbo.Roles WHERE R_Id <> 1
UNION ALL
SELECT R_Id, 89 FROM dbo.Roles WHERE R_Id <> 1
UNION ALL
SELECT R_Id, 90 FROM dbo.Roles WHERE R_Id <> 1
UNION ALL
SELECT R_Id, 93 FROM dbo.Roles WHERE R_Id <> 1
UNION ALL
SELECT R_Id, 94 FROM dbo.Roles WHERE R_Id <> 1
UNION ALL
SELECT R_Id, 95 FROM dbo.Roles WHERE R_Id <> 1
UNION ALL
SELECT R_Id, 96 FROM dbo.Roles WHERE R_Id <> 1
UNION ALL
SELECT R_Id, 130 FROM dbo.Roles WHERE R_Id <> 1
UNION ALL
SELECT R_Id, 131 FROM dbo.Roles WHERE R_Id <> 1
UNION ALL
SELECT R_Id, 132 FROM dbo.Roles WHERE R_Id <> 1
UNION ALL
SELECT R_Id, 148 FROM dbo.Roles WHERE R_Id <> 1
UNION ALL
SELECT R_Id, 158 FROM dbo.Roles WHERE R_Id <> 1
UNION ALL
SELECT R_Id, 159 FROM dbo.Roles WHERE R_Id <> 1;

UPDATE Roles SET 
R_Permissions = '[46,47,79,81,89,90,93,94,95,96,130,131,132,148,158,159]',
R_PermissionCategories = '[6,11,13]'
WHERE R_Id <> 1;

GO

-- 添加权限目录“权限回收”
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
VALUES  ( 14 ,
          14 ,
          '权限回收' ,
          '0014' ,
          NULL ,
          CAST(0x079DAEB04D8BAB3A0B AS DATETIME2) ,
          1
        )

SET IDENTITY_INSERT dbo.PermissionCategories OFF

GO
