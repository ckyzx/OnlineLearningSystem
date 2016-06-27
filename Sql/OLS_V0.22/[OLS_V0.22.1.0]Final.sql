DECLARE @now VARCHAR(100)
DECLARE @fileName VARCHAR(100)
DECLARE @filePath VARCHAR(500)

SET @now = REPLACE(REPLACE(REPLACE(CONVERT(VARCHAR(100), GETDATE(), 20), '-', ''), ' ', ''), ':', '');
SET @fileName = 'OLS_' + @now + '.sqlserver2k8'
-- 下面填入保存数据库备份文件的路径
SET @filePath = 'D:\' + @fileName; -- 例如: 填入 'D:\' + @fileName

BACKUP DATABASE OLS TO DISK = @filePath

GO

USE OLS;

GO

/***************************************************
** [OLS_V0.22.1.1]01修改函数【获取学员考试试卷模板 fn_GetExaminationStudentPaperTemplate】.sql
****************************************************/
IF OBJECT_ID(N'dbo.fn_GetExaminationStudentPaperTemplate', 'TF') IS NOT NULL 
    DROP FUNCTION dbo.fn_GetExaminationStudentPaperTemplate;

GO

CREATE FUNCTION [dbo].[fn_GetExaminationStudentPaperTemplate] ( )
RETURNS @table TABLE
    (
      ESPT_TaskId INT NOT NULL ,
      ESPT_TaskName NVARCHAR(50) NOT NULL ,
      ESPT_TaskType TINYINT NOT NULL ,
      ESPT_UserId INT NOT NULL ,
      ESPT_UserName NVARCHAR(50) NOT NULL,
      ESPT_PaperTemplateId INT NOT NULL ,
      ESPT_Status TINYINT NOT NULL,
      ESPT_PaperTemplateStatus TINYINT NOT NULL ,
      ESPT_PaperTemplateStartTime DATETIME2 NOT NULL ,
      ESPT_PaperTemplateTimeSpan INT NOT NULL ,
      ESPT_PaperTemplateAddTime DATETIME2 NOT NULL ,
      ESPT_PaperTemplateRemark NVARCHAR(50) NULL ,
      ESPT_PaperId INT NULL ,
      ESPT_PaperStatus TINYINT NULL ,
      ESPT_PaperScore NVARCHAR(10) NULL ,
      ESPT_PageType TINYINT NOT NULL
    )
AS 
    BEGIN
	
        INSERT  INTO @table
                SELECT  et.ET_Id ESPT_TaskId ,
                        et.ET_Name ESPT_TaskName ,
                        et.ET_Type ESPT_TaskType ,
                        u.U_Id ESPT_UserId ,
                        u.U_Name ESPT_UserName,
                        ept.EPT_Id ESPT_PaperTemplateId ,
                        ept.EPT_Status ESPT_Status,
                        ept.EPT_PaperTemplateStatus ESPT_PaperTemplateStatus ,
                        ept.EPT_StartTime ESPT_PaperTemplateStartTime ,
                        ept.EPT_TimeSpan ESPT_PaperTemplateTimeSpan ,
                        ept.EPT_AddTime ESPT_PaperTemplateAddTime ,
                        ept.EPT_Remark ESPT_PaperTemplateRemark ,
                        ep.EP_Id ESPT_PaperId ,
                        ep.EP_PaperStatus ESPT_PaperStatus ,
                        CASE 
                          WHEN ep.EP_Score IS NULL THEN '[未参与]'
                          WHEN ep.EP_Score = -1 THEN '[未评分]'
                          ELSE CASE et.ET_StatisticType
                                 WHEN 1 THEN CAST(ep.EP_Score AS VARCHAR(10)) + '分'
                                 WHEN 2 THEN CAST(ep.EP_Score AS VARCHAR(10)) + '%'
                                 ELSE '[未预期]'
                               END
                        END ESPT_PaperScore ,
                        CASE WHEN ep.EP_Id IS NULL
                                  AND ept.EPT_PaperTemplateStatus = 1 THEN 1
							 WHEN ep.EP_Id IS NULL THEN 0
                             WHEN ep.EP_PaperStatus = 1 THEN 1
                             ELSE 2
                        END ESPT_PageType -- 0: 未参与; 1:未考完; 2:已考完。当未考试、正在考试时，将记录归为“未考完”页面类型。
                FROM    dbo.ExaminationTasks et
                        LEFT JOIN dbo.ExaminationPaperTemplates ept ON et.ET_Id = ept.ET_Id
                        LEFT JOIN dbo.ExaminationTaskAttendees eta ON et.ET_Id = eta.ET_Id
                        LEFT JOIN dbo.Users u ON eta.U_Id = u.U_Id
                        LEFT JOIN dbo.ExaminationPapers ep ON ept.EPT_Id = ep.EPT_Id
                                                              AND u.U_Id = ep.EP_UserId
                WHERE   et.ET_Status = 1
                        AND ept.EPT_Id IS NOT NULL
                        AND ept.EPT_PaperTemplateStatus <> 0 -- 不取未开始的试卷模板
        RETURN;
    END

GO

IF OBJECT_ID(N'dbo.ExaminationStudentPaperTemplates', 'V') IS NOT NULL 
    DROP VIEW dbo.ExaminationStudentPaperTemplates;

GO

CREATE VIEW dbo.ExaminationStudentPaperTemplates
AS
    SELECT  *
    FROM    dbo.fn_GetExaminationStudentPaperTemplate()

GO


/***************************************************
** [OLS_V0.22.1.1]02添加[评改试卷]权限值.sql
****************************************************/
BEGIN

DECLARE @pcId INT ,
    @pId INT;

SELECT  @pcId = 10;
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
          N'评改试卷' ,
          N'ExaminationPaperTemplate' ,
          N'PaperGrade' ,
          NULL ,
          CAST(0x079DAEB04D8BAB3A0B AS DATETIME2)
        )
        
SET IDENTITY_INSERT [dbo].[Permissions] OFF

END

BEGIN

EXEC dbo.UpdateAdminRole;

END

GO


/***************************************************
** [OLS_V0.22.1.1]03添加[查询考试任务]权限值.sql
****************************************************/
BEGIN

DECLARE @pcId INT ,
    @pId INT;

SELECT  @pcId = 11;
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
          N'查询考试任务' ,
          N'ExaminationTask' ,
          N'ListDataTablesAjaxByUser' ,
          NULL ,
          CAST(0x079DAEB04D8BAB3A0B AS DATETIME2)
        )
        
SET IDENTITY_INSERT [dbo].[Permissions] OFF
END

BEGIN

EXEC dbo.UpdateAdminRole;

END

GO


/***************************************************
** [OLS_V0.22.1.1]04修改学员角色权限值.sql
****************************************************/
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


/***************************************************
** [OLS_V0.22.1.1]05更新“进入练习”权限值.sql
****************************************************/
UPDATE  dbo.[Permissions]
SET     P_Controller = 'ExaminationPaperTemplate'
WHERE   P_Controller = 'ExaminationTask'
        AND P_Action = 'EnterExercise'

GO

EXEC dbo.UpdateAdminRole;

GO

EXEC dbo.UpdateStudentRole;

GO


/***************************************************
** [OLS_V0.22.1.4]01添加数据库表＜已出试题表 ExaminationQuestionDones＞.sql
****************************************************/

IF OBJECT_ID(N'dbo.ExaminationQuestionDones', 'U') IS NOT NULL 
    DROP TABLE dbo.ExaminationQuestionDones;

GO

CREATE TABLE ExaminationQuestionDones
    (
      EQD_Id INT IDENTITY ,
      ET_Id INT NOT NULL ,
      EPT_Id INT NOT NULL ,
      U_Id INT NOT NULL ,
      Q_Id INT NOT NULL ,
      CONSTRAINT PK_EQD PRIMARY KEY ( EQD_Id )
    );

GO
