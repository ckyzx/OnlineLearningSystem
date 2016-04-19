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

/***************************************************
** [OLS_v0.14]01添加【考试统计导出视图 TaskStatisticToExcel】.sql
****************************************************/

IF OBJECT_ID(N'dbo.TaskStatisticToExcel') IS NOT NULL
	DROP VIEW dbo.TaskStatisticToExcel;

GO

CREATE VIEW dbo.TaskStatisticToExcel
AS
    SELECT  ETS_TaskName ,
			ETS_PaperTemplateId,
            ETS_PaperTemplateId 考试编号,
            ETS_TaskName 考试任务,
            ETS_PaperTemplateDate 考试日期,
            ETS_AttendeeNumber 应考,
            ETS_PaperNumber 已考,
            ETS_PassNumber 合格,
            ETS_FlunkNumber 未合格
    FROM    dbo.fn_GetExaminationTaskStatistic()

GO

/***************************************************
** [OLS_v0.14]02添加权限.sql
****************************************************/

DECLARE @pcId INT ,
    @pId INT;

SELECT  @pcId = 15;
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
          N'导出考试统计概览到表格' ,
          N'ExaminationTaskStatistic' ,
          N'TaskExportToExcel' ,
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

/***************************************************
** [OLS_v0.14]03添加【考试统计详情导出视图 UserStatisticToExcel】.sql
****************************************************/

IF OBJECT_ID(N'dbo.UserStatisticToExcel') IS NOT NULL 
    DROP VIEW dbo.UserStatisticToExcel;

GO

CREATE VIEW dbo.UserStatisticToExcel
AS
    SELECT  ETUS_PaperTemplateId ,
            ETUS_DepartmentName 部门 ,
            ETUS_UserName 用户 ,
            ETUS_DutyName 职务 ,
            CASE ETUS_Score
              WHEN -1 THEN ''
              ELSE CAST(ETUS_Score AS VARCHAR(5))
            END 成绩 ,
            CASE ETUS_State
              WHEN 0 THEN '[未设置]'
              WHEN 1 THEN '未考试'
              WHEN 2 THEN '合格'
              WHEN 3 THEN '未合格'
              WHEN 4 THEN '未打分'
            END 状态
    FROM    dbo.fn_GetExaminationTaskUserStatistic()

GO

/***************************************************
** [OLS_v0.14]04修改【任务模板】数据.sql
****************************************************/

UPDATE  dbo.ExaminationTaskTemplates
SET     ETT_EndTime = '1970-01-01 12:00:00.0000000'
WHERE   ETT_Mode = 1;

GO

/***************************************************
** [OLS_v0.14]05添加【资料】字段“视频（LD_Video）”.sql
****************************************************/

ALTER TABLE dbo.LearningDatas
ADD LD_Video VARCHAR(500) NULL;

GO

/***************************************************
** [OLS_v0.14]06修改【资料】字段“内容（LD_Content）”.sql
****************************************************/

ALTER TABLE dbo.LearningDatas
ALTER COLUMN LD_Content TEXT NULL;

GO
