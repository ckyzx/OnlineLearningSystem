USE OLS;

GO

/***************************************************
** [OLS_v0.12]1优化NotNull约束与修改字符字段类型.sql
****************************************************/

/* 试题表 */
DROP INDEX dbo.Questions.Index_1;

GO

ALTER TABLE dbo.Questions
ALTER COLUMN Q_Type NVARCHAR(20) NOT NULL;

ALTER TABLE dbo.Questions
ALTER COLUMN QC_Id INT NOT NULL;

ALTER TABLE dbo.Questions
ALTER COLUMN Q_Remark NVARCHAR(200) NULL;

GO

CREATE NONCLUSTERED INDEX Index_1 ON dbo.Questions(Q_Type, Q_DifficultyCoefficient);

GO

/* 试题分类表 */
DROP INDEX dbo.QuestionClassifies.Index_1;

GO

ALTER TABLE dbo.QuestionClassifies
ALTER COLUMN QC_Name NVARCHAR(100) NOT NULL;

ALTER TABLE dbo.QuestionClassifies
ALTER COLUMN QC_Remark NVARCHAR(200) NULL;

GO

CREATE NONCLUSTERED INDEX Index_1 ON dbo.QuestionClassifies(QC_Name);

GO

/* 任务模板表 */
ALTER TABLE dbo.ExaminationTaskTemplates
ALTER COLUMN ETT_Name NVARCHAR(50) NOT NULL;

ALTER TABLE dbo.ExaminationTaskTemplates
ALTER COLUMN ETT_AutoRatio NVARCHAR(500) NOT NULL;

ALTER TABLE dbo.ExaminationTaskTemplates
ALTER COLUMN ETT_Remark NVARCHAR(200) NULL;

ALTER TABLE dbo.ExaminationTaskTemplates
ALTER COLUMN ETT_ParticipatingDepartment TEXT NOT NULL;

ALTER TABLE dbo.ExaminationTaskTemplates
ALTER COLUMN ETT_Attendee TEXT NOT NULL;

ALTER TABLE dbo.ExaminationTaskTemplates
ALTER COLUMN ETT_AutoOffsetDay TINYINT NOT NULL;

GO

/* 任务参与人员表 */
ALTER TABLE dbo.ExaminationTaskAttendees
ALTER COLUMN ET_Id INT NOT NULL;

GO

/* 考试任务表 */
DROP INDEX dbo.ExaminationTasks.Index_1;

GO

ALTER TABLE dbo.ExaminationTasks
ALTER COLUMN ET_Name NVARCHAR(50) NOT NULL;

ALTER TABLE dbo.ExaminationTasks
ALTER COLUMN ET_AutoRatio NVARCHAR(500) NOT NULL;

ALTER TABLE dbo.ExaminationTasks
ALTER COLUMN ET_Remark NVARCHAR(200) NULL;

GO

CREATE NONCLUSTERED INDEX Index_1 ON dbo.ExaminationTasks(ET_Name);

GO

/* 试卷模板表 */
ALTER TABLE dbo.ExaminationPaperTemplates
ALTER COLUMN EPT_Remark NVARCHAR(200) NULL;

GO

/* 试卷表 */
ALTER TABLE dbo.ExaminationPapers
ALTER COLUMN ET_Id INT NOT NULL;

ALTER TABLE dbo.ExaminationPapers
ALTER COLUMN EPT_Id INT NOT NULL;

ALTER TABLE dbo.ExaminationPapers
ALTER COLUMN EP_UserName NVARCHAR(10) NOT NULL;

ALTER TABLE dbo.ExaminationPapers
ALTER COLUMN EP_Remark NVARCHAR(200) NULL;

GO

/* 试卷模板试题表 */
ALTER TABLE dbo.ExaminationPaperTemplateQuestions
ALTER COLUMN EPTQ_Type NVARCHAR(20) NOT NULL;

ALTER TABLE dbo.ExaminationPaperTemplateQuestions
ALTER COLUMN EPTQ_Remark NVARCHAR(200) NULL;

GO

/* 试卷试题表 */
ALTER TABLE dbo.ExaminationPaperQuestions
ALTER COLUMN EP_Id INT NOT NULL;

ALTER TABLE dbo.ExaminationPaperQuestions
ALTER COLUMN EPTQ_Id INT NOT NULL;

ALTER TABLE dbo.ExaminationPaperQuestions
ALTER COLUMN EPQ_Critique NVARCHAR(200) NULL;

GO

/* 用户表 */
DROP INDEX dbo.Users.Index_1;

GO

ALTER TABLE dbo.Users
ALTER COLUMN U_Name NVARCHAR(10) NOT NULL;

ALTER TABLE dbo.Users
ALTER COLUMN U_Remark NVARCHAR(200) NULL;

GO

CREATE NONCLUSTERED INDEX Index_1 ON Users(U_Name, U_LoginName);

GO

/* 职务表 */
ALTER TABLE dbo.Duties
ALTER COLUMN Du_Name NVARCHAR(50) NOT NULL;

ALTER TABLE dbo.Duties
ALTER COLUMN Du_Remark NVARCHAR(200) NULL;

GO

/* 部门表 */
DROP INDEX dbo.Departments.Index_1;

GO

ALTER TABLE dbo.Departments
ALTER COLUMN D_Roles TEXT NOT NULL;

ALTER TABLE dbo.Departments
ALTER COLUMN D_Name NVARCHAR(50) NOT NULL;

ALTER TABLE dbo.Departments
ALTER COLUMN D_Remark NVARCHAR(200) NULL;

GO

CREATE NONCLUSTERED INDEX Index_1 ON dbo.Departments(D_Name);

GO

/* 部门权限表 */
ALTER TABLE dbo.Department_Role
ALTER COLUMN D_Id INT NOT NULL;

ALTER TABLE dbo.Department_Role
ALTER COLUMN R_Id INT NOT NULL;

GO

/* 角色表 */
DROP INDEX dbo.Roles.Index_1;

GO

ALTER TABLE dbo.Roles
ALTER COLUMN R_Name NVARCHAR(50) NOT NULL;

ALTER TABLE dbo.Roles
ALTER COLUMN R_Permissions TEXT NOT NULL;

ALTER TABLE dbo.Roles
ALTER COLUMN R_PermissionCategories TEXT NOT NULL;

ALTER TABLE dbo.Roles
ALTER COLUMN R_Remark NVARCHAR(200) NULL;

GO

CREATE NONCLUSTERED INDEX Index_1 ON Roles(R_Name);

GO

/* 权限表 */
DROP INDEX dbo.[Permissions].Index_1;

GO

ALTER TABLE dbo.[Permissions]
ALTER COLUMN PC_Id INT NOT NULL;

ALTER TABLE dbo.[Permissions]
ALTER COLUMN P_Name NVARCHAR(50) NOT NULL;

ALTER TABLE dbo.[Permissions]
ALTER COLUMN P_Remark NVARCHAR(200) NULL;

GO

CREATE NONCLUSTERED INDEX Index_1 ON [dbo].[Permissions](P_Name);

GO

/* 权限目录表 */
ALTER TABLE dbo.PermissionCategories
ALTER COLUMN PC_Name NVARCHAR(20) NOT NULL;

ALTER TABLE dbo.PermissionCategories
ALTER COLUMN PC_Remark NVARCHAR(200) NULL;

GO

/* 资料表 */
ALTER TABLE dbo.LearningDatas
ALTER COLUMN LDC_Id INT NOT NULL;

ALTER TABLE dbo.LearningDatas
ALTER COLUMN LD_Title NVARCHAR(200) NOT NULL;

ALTER TABLE dbo.LearningDatas
ALTER COLUMN LD_Remark NVARCHAR(200) NULL;

GO

/* 资料目录表 */
ALTER TABLE dbo.LearningDataCategories
ALTER COLUMN LDC_Name NVARCHAR(200) NOT NULL;

ALTER TABLE dbo.LearningDataCategories
ALTER COLUMN LDC_Remark NVARCHAR(200) NULL;

GO

/* 日志表 */
ALTER TABLE dbo.SystemLogs
ALTER COLUMN SL_Name NVARCHAR(500) NOT NULL;

ALTER TABLE dbo.SystemLogs
ALTER COLUMN SL_Remark NVARCHAR(200) NULL;

GO

/*********************************************
** [OLS_v0.12]2添加函数 fn_GetUserScoreSummary 
**********************************************/

IF OBJECT_ID(N'dbo.fn_GetUserScoreSummary', 'TF') IS NOT NULL 
    DROP FUNCTION dbo.fn_GetUserScoreSummary;
GO

CREATE FUNCTION dbo.fn_GetUserScoreSummary ( )
RETURNS @table TABLE
    (
      USS_UserId INT NOT NULL ,
      USS_UserName NVARCHAR(50) NOT NULL ,
      USS_DepartmentName NVARCHAR(50) NOT NULL ,
      USS_DutyName NVARCHAR(50) NULL ,
      USS_TotalNumber INT NOT NULL ,
      USS_DoneNumber INT NOT NULL ,
      USS_UndoNumber INT NOT NULL ,
      USS_PassNumber INT NOT NULL ,
      USS_DoneRatio DECIMAL NOT NULL ,
      USS_PassRatio DECIMAL NOT NULL
    )
AS 
    BEGIN
		
        INSERT  INTO @table
                SELECT  USS_UserId ,
                        USS_UserName ,
                        USS_DepartmentName ,
                        ISNULL(USS_DutyName, '') ,
                        USS_TotalNumber ,
                        USS_DoneNumber ,
                        ( USS_TotalNumber - USS_DoneNumber ) USS_UndoNumber ,
                        USS_PassNumber ,
                        ( CASE USS_TotalNumber
                            WHEN 0 THEN 0
                            ELSE ROUND(( USS_DoneNumber / CAST(USS_TotalNumber AS FLOAT) ), 2) * 100
                          END ) USS_DoneRatio ,
                        ( CASE USS_TotalNumber
                            WHEN 0 THEN 0
                            ELSE ROUND(( USS_PassNumber / CAST(USS_TotalNumber AS FLOAT) ), 2) * 100
                          END ) USS_PassRatio
                FROM    ( SELECT    USS_UserId ,
                                    USS_UserName ,
                                    USS_DepartmentName ,
                                    USS_DutyName ,
                                    COUNT(USS_TaskName) USS_TotalNumber ,
                                    SUM(USS_DoneNumber) USS_DoneNumber ,
                                    SUM(ISNULL(USS_PassNumber, 0)) USS_PassNumber
                          FROM      ( SELECT    u.U_Id USS_UserId ,
                                                u.U_Name USS_UserName ,
                                                d.D_Name USS_DepartmentName ,
                                                du.Du_Name USS_DutyName ,
                                                et.ET_Id USS_TaskId ,
                                                et.ET_Name USS_TaskName ,
                                                ept.EPT_Id USS_PaperTemplateId ,
                                                ept.EPT_StartDate USS_StartTime ,
                                                ( SELECT    COUNT(ep1.EP_Id)
                                                  FROM      dbo.ExaminationTasks et1
                                                            LEFT JOIN dbo.ExaminationTaskAttendees eta1 ON et1.ET_Id = eta1.ET_Id
                                                            LEFT JOIN dbo.Users u1 ON eta1.U_Id = u1.U_Id
                                                            LEFT JOIN dbo.ExaminationPaperTemplates ept1 ON et1.ET_Id = ept1.ET_Id
                                                            LEFT JOIN dbo.ExaminationPapers ep1 ON et1.ET_Id = ep1.ET_Id
                                                  WHERE     et1.ET_Id = et.ET_Id
                                                            AND ept1.EPT_Id = ept.EPT_Id
                                                            AND ep1.EP_UserId = u.U_Id
                                                            AND ep1.EP_UserId = u1.U_Id
                                                            AND ept1.EPT_Id = ep1.EPT_Id
                                                            AND ep1.EP_Id IS NOT NULL
                                                ) USS_DoneNumber ,
                                                ( SELECT    SUM(CASE et2.ET_StatisticType
                                                                  WHEN 1 THEN ( CASE WHEN ( ep2.EP_Score / CAST(et2.ET_TotalScore AS FLOAT) * 100 ) > 59 THEN 1
                                                                                     ELSE 0
                                                                                END )
                                                                  WHEN 2 THEN ( CASE WHEN ep2.EP_Score > 59 THEN 1
                                                                                     ELSE 0
                                                                                END )
                                                                  ELSE 0
                                                                END)
                                                  FROM      dbo.ExaminationTasks et2
                                                            LEFT JOIN dbo.ExaminationTaskAttendees eta2 ON et2.ET_Id = eta2.ET_Id
                                                            LEFT JOIN dbo.Users u2 ON eta2.U_Id = u2.U_Id
                                                            LEFT JOIN dbo.ExaminationPaperTemplates ept2 ON et2.ET_Id = ept2.ET_Id
                                                            LEFT JOIN dbo.ExaminationPapers ep2 ON et2.ET_Id = ep2.ET_Id
                                                  WHERE     et2.ET_Id = et.ET_Id
                                                            AND ept2.EPT_Id = ept.EPT_Id
                                                            AND ep2.EP_UserId = u.U_Id
                                                            AND ep2.EP_UserId = u2.U_Id
                                                            AND ept2.EPT_Id = ep2.EPT_Id
                                                            AND ep2.EP_Id IS NOT NULL
                                                ) USS_PassNumber
                                      FROM      dbo.Users u
                                                LEFT JOIN dbo.User_Department ud ON u.U_Id = ud.U_Id
                                                LEFT JOIN dbo.Departments d ON ud.D_Id = d.D_Id
                                                LEFT JOIN dbo.Duties du ON u.Du_Id = du.Du_Id
                                                LEFT JOIN dbo.ExaminationTaskAttendees eta ON u.U_Id = eta.U_Id
                                                LEFT JOIN dbo.ExaminationTasks et ON eta.ET_Id = et.ET_Id
                                                LEFT JOIN dbo.ExaminationPaperTemplates ept ON et.ET_Id = ept.ET_Id
                                      WHERE     ( et.ET_Status = 1
                                                  OR et.ET_Status IS NULL
                                                )
                                                AND u.U_Status = 1
                                                AND d.D_Status = 1
                                                AND ( du.Du_Status = 1
                                                      OR du.Du_Status IS NULL
                                                    )
                                    ) TmpTable
                          GROUP BY  USS_UserId ,
                                    USS_UserName ,
                                    USS_DepartmentName ,
                                    USS_DutyName
                        ) TmpTable1
		
        RETURN;
    END

GO

/********************************************
** [OLS_v0.12]3添加函数 fn_GetUserScoreDetail 
*********************************************/

IF OBJECT_ID(N'dbo.fn_GetUserScoreDetail', 'TF') IS NOT NULL 
    DROP FUNCTION dbo.fn_GetUserScoreDetail;
GO

CREATE FUNCTION dbo.fn_GetUserScoreDetail ( )
RETURNS @table TABLE
    (
      USD_UserId INT NOT NULL ,
      USD_UserName NVARCHAR(50) NOT NULL ,
      USD_TaskId INT NULL ,
      USD_TaskName NVARCHAR(50) NULL ,
      USD_TaskStatisticType TINYINT NULL ,
      USD_PaperTemplateId INT NULL ,
      USD_StartDate DATETIME2 NULL ,
      USD_StartTime DATETIME2 NULL ,
      USD_PaperId INT NULL ,
      USD_Score INT NULL ,
      USD_State TINYINT NOT NULL
    )
AS 
    BEGIN
        INSERT  INTO @table
                SELECT  *
                FROM    ( SELECT    u1.U_Id USD_UserId ,
                                    u1.U_Name USD_UserName ,
                                    et.ET_Id USD_TaskId ,
                                    et.ET_Name USD_TaskName ,
                                    et.ET_StatisticType USD_TaskStatisticType ,
                                    ept.EPT_Id USD_PaperTemplateId ,
                                    ept.EPT_StartDate USD_StartDate ,
                                    ept.EPT_StartTime USD_StartTime ,
                                    ISNULL(ep.EP_Id, 0) USD_PaperId ,
                                    ISNULL(ep.EP_Score, -1) USD_Score ,
                                    ( CASE WHEN ept.EPT_Id IS NULL THEN 0
                                           ELSE CASE WHEN ep.EP_Score IS NULL THEN 1
                                                     ELSE CASE WHEN et.ET_StatisticType = 1
                                                               THEN CASE WHEN EP_Score = -1 THEN 2
                                                                         WHEN ( ep.EP_Score / CAST(et.ET_TotalScore AS FLOAT) * 100 ) > 59 THEN 3
                                                                         ELSE 4
                                                                    END
                                                               WHEN et.ET_StatisticType = 2 THEN CASE WHEN EP_Score = -1 THEN 2
                                                                                                      WHEN ep.EP_Score > 59 THEN 3
                                                                                                      ELSE 4
                                                                                                 END
                                                               ELSE 0
                                                          END
                                                END
                                      END ) AS ETUS_State /* 0未设置 1未考试 2未打分 3合格 4未合格 */
                          FROM      ( SELECT    u.U_Id ,
                                                u.U_Name ,
                                                u.U_Status,
                                                d.D_Id ,
                                                d.D_Name ,
                                                d.D_Status,
                                                du.Du_Id ,
                                                du.Du_Name,
                                                du.Du_Status
                                      FROM      dbo.Users u
                                                LEFT JOIN dbo.User_Department ud ON u.U_Id = ud.U_Id
                                                LEFT JOIN dbo.Departments d ON ud.D_Id = d.D_Id
                                                LEFT JOIN dbo.Duties du ON u.Du_Id = du.Du_Id
                                    ) u1
                                    LEFT JOIN dbo.ExaminationTaskAttendees eta ON eta.U_Id = u1.U_Id
                                    LEFT JOIN dbo.ExaminationTasks et ON et.ET_Id = eta.ET_Id
                                    LEFT JOIN dbo.ExaminationPaperTemplates ept ON ept.ET_Id = et.ET_Id
                                    FULL OUTER JOIN dbo.ExaminationPapers ep ON ep.EPT_Id = ept.EPT_Id
                          WHERE     ep.EP_UserId = u1.U_Id
						  --添加未考试的记录
                          UNION ALL
                          SELECT    u1.U_Id USD_UserId ,
                                    u1.U_Name USD_UserName ,
                                    et.ET_Id USD_TaskId ,
                                    et.ET_Name USD_TaskName ,
                                    et.ET_StatisticType USD_TaskStatisticType ,
                                    ept.EPT_Id USD_PaperTemplateId ,
                                    ept.EPT_StartDate USD_StartDate ,
                                    ept.EPT_StartTime USD_StartTime ,
                                    ISNULL(ep.EP_Id, 0) USD_PaperId ,
                                    ISNULL(ep.EP_Score, -1) USD_Score ,
                                    ( CASE WHEN ept.EPT_Id IS NULL THEN 0
                                           ELSE CASE WHEN ep.EP_Score IS NULL THEN 1
                                                     ELSE CASE WHEN et.ET_StatisticType = 1
                                                               THEN CASE WHEN EP_Score = -1 THEN 2
                                                                         WHEN ( ep.EP_Score / CAST(et.ET_TotalScore AS FLOAT) * 100 ) > 59 THEN 3
                                                                         ELSE 4
                                                                    END
                                                               WHEN et.ET_StatisticType = 2 THEN CASE WHEN EP_Score = -1 THEN 2
                                                                                                      WHEN ep.EP_Score > 59 THEN 3
                                                                                                      ELSE 4
                                                                                                 END
                                                               ELSE 0
                                                          END
                                                END
                                      END ) AS ETUS_State /* 0未设置 1未考试 2未打分 3合格 4未合格 */
                          FROM      ( SELECT    u.U_Id ,
                                                u.U_Name ,
                                                u.U_Status,
                                                d.D_Id ,
                                                d.D_Name ,
                                                d.D_Status,
                                                du.Du_Id ,
                                                du.Du_Name,
                                                du.Du_Status
                                      FROM      dbo.Users u
                                                LEFT JOIN dbo.User_Department ud ON u.U_Id = ud.U_Id
                                                LEFT JOIN dbo.Departments d ON ud.D_Id = d.D_Id
                                                LEFT JOIN dbo.Duties du ON u.Du_Id = du.Du_Id
                                    ) u1
                                    LEFT JOIN dbo.ExaminationTaskAttendees eta ON eta.U_Id = u1.U_Id
                                    LEFT JOIN dbo.ExaminationTasks et ON et.ET_Id = eta.ET_Id
                                    LEFT JOIN dbo.ExaminationPaperTemplates ept ON ept.ET_Id = et.ET_Id
                                    FULL OUTER JOIN dbo.ExaminationPapers ep ON ep.EPT_Id = ept.EPT_Id
                          WHERE     ep.EP_Id IS NULL
                        ) tmp
                ORDER BY USD_PaperTemplateId ASC ,
                        USD_TaskId ASC ,
                        USD_PaperId ASC
        RETURN;
    END

GO

/**************************************************************************
** [OLS_v0.12]4添加用户成绩视图 UserScoreSummaries 和 UserScoreDetails .sql
***************************************************************************/

IF OBJECT_ID(N'dbo.UserScoreSummaries', 'V') IS NOT NULL
	DROP VIEW dbo.UserScoreSummaries;
GO

CREATE VIEW dbo.UserScoreSummaries
AS
SELECT * FROM dbo.fn_GetUserScoreSummary()

GO

IF OBJECT_ID(N'dbo.UserScoreDetails', 'V') IS NOT NULL
	DROP VIEW dbo.UserScoreDetails;
GO

CREATE VIEW dbo.UserScoreDetails
AS
SELECT * FROM dbo.fn_GetUserScoreDetail()

GO

/******************************************************************
** [OLS_v0.12]5添加用户成绩详情导出视图 UserScoreDetailToExcel .sql
*******************************************************************/

IF OBJECT_ID(N'dbo.UserScoreDetailToExcel', 'V') IS NOT NULL 
    DROP VIEW dbo.UserScoreDetailToExcel;
GO

CREATE VIEW dbo.UserScoreDetailToExcel
AS
    SELECT  USD_UserId,
			USD_TaskName,
			USD_StartTime,
			USD_PaperId,
			CASE WHEN USD_PaperId = 0 THEN '' ELSE CAST(USD_PaperId AS NVARCHAR(20)) END 试卷编号,
			USD_TaskName 考试任务 ,
            CONVERT(VARCHAR(20), USD_StartTime, 20) 考试时间 ,
            CASE USD_TaskStatisticType
              WHEN 1 THEN '得分'
              WHEN 2 THEN '正确率'
              ELSE '[未设置]'
            END 成绩类型 ,
            CASE USD_Score
              WHEN -1 THEN ''
              ELSE CASE USD_TaskStatisticType
                     WHEN 1 THEN CAST(USD_Score AS VARCHAR(10)) + '分'
                     WHEN 2 THEN CAST(USD_Score AS VARCHAR(10)) + '%'
                     ELSE ''
                   END
            END 成绩 ,
            CASE USD_State
              WHEN 1 THEN '未考试'
              WHEN 2 THEN '未打分'
              WHEN 3 THEN '合格'
              WHEN 4 THEN '未合格'
              ELSE '[未设置]'
            END 状态
    FROM    dbo.fn_GetUserScoreDetail()

GO

/*******************************************************************
** [OLS_v0.12]6添加用户成绩概览导出视图 UserScoreSummaryToExcel .sql
********************************************************************/

IF OBJECT_ID(N'dbo.UserScoreSummaryToExcel') IS NOT NULL 
    DROP VIEW dbo.UserScoreSummaryToExcel

GO

CREATE VIEW dbo.UserScoreSummaryToExcel
AS
    SELECT  USS_UserId ,
            USS_UserName 用户 ,
            USS_DepartmentName 部门 ,
            USS_DutyName 职务 ,
            USS_TotalNumber 应考 ,
            USS_DoneNumber 已考 ,
            USS_UndoNumber 未考 ,
            USS_PassNumber 合格 ,
            CAST(USS_DoneRatio AS varchar(5)) + '%' 参考率 ,
            CAST(USS_PassRatio AS VARCHAR(5)) + '%' 合格率
    FROM    dbo.fn_GetUserScoreSummary()

GO

/*********************************************
** [OLS_v0.12]7添加函数 fn_GetPaperDetail .sql
**********************************************/

IF OBJECT_ID(N'dbo.fn_GetPaperDetail', 'TF') IS NOT NULL 
    DROP FUNCTION dbo.fn_GetPaperDetail
GO

CREATE FUNCTION dbo.fn_GetPaperDetail ( )
RETURNS @table TABLE
    (
      PD_TaskId INT NOT NULL ,
      PD_PaperTemplateId INT NOT NULL ,
      PD_PaperId INT NOT NULL ,
      PD_UserId INT NOT NULL ,
      PD_QuestionType NVARCHAR(20) NOT NULL ,
      PD_QuestionContent TEXT NOT NULL ,
      PD_QuestionAnswer TEXT NULL ,
      PD_QuestionScore INT NOT NULL ,
      PD_QuestionExactness VARCHAR(5) NULL
    )
AS 
    BEGIN
		
        INSERT  INTO @table
                SELECT  et.ET_Id PD_TaskId ,
                        ept.EPT_Id PD_PaperTemplateId ,
                        ep.EP_Id PD_PaperId ,
                        u.U_Id PD_UserId ,
                        eptq.EPTQ_Type PD_QuestionType ,
                        eptq.EPTQ_Content PD_QuestionContent ,
                        ISNULL(epq.EPQ_Answer, '') PD_QuestionAnswer ,
                        eptq.EPTQ_Score PD_QuestionScore ,
                        CASE epq.EPQ_Exactness WHEN 1 THEN '√' WHEN 2 THEN '×' ELSE '' END PD_QuestionExactness
                FROM    dbo.ExaminationTasks et
                        JOIN dbo.ExaminationTaskAttendees eta ON et.ET_Id = eta.ET_Id
                        JOIN dbo.ExaminationPaperTemplates ept ON et.ET_Id = ept.ET_Id
                        JOIN dbo.ExaminationPapers ep ON et.ET_Id = ep.ET_Id
                        JOIN dbo.Users u ON eta.U_Id = u.U_Id
                        JOIN dbo.ExaminationPaperTemplateQuestions eptq ON eptq.EPT_Id = ept.EPT_Id
                        FULL OUTER JOIN dbo.ExaminationPaperQuestions epq ON epq.EPTQ_Id = eptq.EPTQ_Id
                WHERE   ep.EP_UserId = u.U_Id
        RETURN;
    END

GO

/**********************************************************
** [OLS_v0.12]8添加试卷详情导出视图 PaperDetailToExcel .sql
***********************************************************/

IF OBJECT_ID(N'dbo.PaperDetailToExcel', 'V') IS NOT NULL 
    DROP VIEW dbo.PaperDetailToExcel
GO

CREATE VIEW dbo.PaperDetailToExcel
AS
    SELECT  PD_TaskId ,
            PD_PaperTemplateId ,
            PD_PaperId ,
            PD_UserId ,
            PD_QuestionType 类型 ,
            PD_QuestionContent 题目 ,
            PD_QuestionAnswer 回答 ,
            PD_QuestionScore 分数 ,
            PD_QuestionExactness 状态
    FROM    dbo.fn_GetPaperDetail()

GO

/**************************
** [OLS_v0.12]9添加权限.sql
***************************/

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

/**********************************************************
** [OLS_v0.12]10修改函数 fn_GetExaminationTaskStatistic.sql
***********************************************************/

IF OBJECT_ID(N'dbo.fn_GetExaminationTaskStatistic', N'TF') IS NOT NULL 
    DROP FUNCTION dbo.fn_GetExaminationTaskStatistic;
GO

CREATE FUNCTION fn_GetExaminationTaskStatistic ( )
RETURNS @table TABLE
    (
      ETS_TaskId INT ,
      ETS_TaskName VARCHAR(50) ,
      ETS_PaperTemplateId INT ,
      ETS_PaperTemplateDate DATETIME2 ,
      ETS_AttendeeNumber INT ,
      ETS_PaperNumber INT ,
      ETS_PassNumber INT ,
      ETS_FlunkNumber INT
    )
AS 
    BEGIN
        
        INSERT  INTO @table
                SELECT  ETS_TaskId ,
                        ETS_TaskName ,
                        ETS_PaperTemplateId ,
                        ETS_PaperTemplateDate ,
                        COUNT(ETS_TaskId) ETS_AttendeeNumber ,
                        ETS_PaperNumber ,
                        ETS_PassNumber ,
                        ETS_FlunkNumber
                FROM    ( SELECT    et.ET_Id AS ETS_TaskId ,
                                    ET_Name AS ETS_TaskName ,
                                    EPT_Id AS ETS_PaperTemplateId ,
                                    EPT_StartDate AS ETS_PaperTemplateDate ,
                                    ( SELECT    COUNT(EP_Id)
                                      FROM      ExaminationPapers ep
                                                LEFT JOIN ExaminationPaperTemplates ept ON ep.EPT_Id = ept.EPT_Id
                                      WHERE     ept.ET_Id = et.ET_Id
                                                AND ept.EPT_Id = ept1.EPT_Id
                                    ) AS ETS_PaperNumber ,
                                    ( SELECT    COUNT(EP_Id)
                                      FROM      ExaminationPapers ep
                                                LEFT JOIN ExaminationPaperTemplates ept ON ep.EPT_Id = ept.EPT_Id
                                      WHERE     ept.ET_Id = et.ET_Id
                                                AND ept.EPT_Id = ept1.EPT_Id
                                                AND ( CASE WHEN ET_StatisticType = 1 THEN CASE WHEN EP_Score = -1 THEN 0
                                                                                               WHEN EP_Score >= et.ET_TotalScore * 0.6 THEN 1
                                                                                               ELSE 0
                                                                                          END
                                                           WHEN ET_StatisticType = 2 THEN CASE WHEN EP_Score >= 60 THEN 1
                                                                                               ELSE 0
                                                                                          END
                                                      END ) = 1
                                    ) AS ETS_PassNumber ,
                                    ( SELECT    COUNT(EP_Id)
                                      FROM      ExaminationPapers ep
                                                LEFT JOIN ExaminationPaperTemplates ept ON ep.EPT_Id = ept.EPT_Id
                                      WHERE     ept.ET_Id = et.ET_Id
                                                AND ept.EPT_Id = ept1.EPT_Id
                                                AND ( CASE WHEN ET_StatisticType = 1 THEN CASE WHEN EP_Score = -1 THEN 0
                                                                                               WHEN EP_Score < et.ET_TotalScore * 0.6 THEN 1
                                                                                               ELSE 0
                                                                                          END
                                                           WHEN ET_StatisticType = 2 THEN CASE WHEN EP_Score < 60 THEN 1
                                                                                               ELSE 0
                                                                                          END
                                                      END ) = 1
                                    ) AS ETS_FlunkNumber
                          FROM      dbo.ExaminationTasks et
                                    LEFT JOIN dbo.ExaminationTaskAttendees eta ON et.ET_Id = eta.ET_Id
                                    LEFT JOIN dbo.ExaminationPaperTemplates ept1 ON et.ET_Id = ept1.ET_Id
                                    LEFT JOIN dbo.Users u ON eta.U_Id = u.U_Id
                          WHERE     et.ET_Status = 1
                                    AND ept1.EPT_Status = 1
                                    AND u.U_Status = 1
                        ) tmp
                GROUP BY ETS_TaskId ,
                        ETS_TaskName ,
                        ETS_PaperTemplateId ,
                        ETS_PaperTemplateDate ,
                        ETS_PaperNumber ,
                        ETS_PassNumber ,
                        ETS_FlunkNumber
        RETURN
    END
    
    GO
    
IF OBJECT_ID('ExaminationTaskStatistic', 'V') IS NOT NULL 
    DROP VIEW ExaminationTaskStatistic;

GO

CREATE VIEW ExaminationTaskStatistic
AS
    SELECT  *
    FROM    dbo.fn_GetExaminationTaskStatistic()

GO

/**************************************************************
** [OLS_v0.12]11修改函数 fn_GetExaminationTaskUserStatistic.sql
***************************************************************/

IF OBJECT_ID(N'fn_GetExaminationTaskUserStatistic', N'TF') IS NOT NULL 
    DROP FUNCTION fn_GetExaminationTaskUserStatistic;
GO

CREATE FUNCTION fn_GetExaminationTaskUserStatistic ( )
RETURNS @table TABLE
    (
      ETUS_TaskId INT ,
      ETUS_TaskName VARCHAR(50) ,
      ETUS_TaskType TINYINT,
      ETUS_TaskAutoType TINYINT ,
      ETUS_TaskStatisticType TINYINT ,
      ETUS_PaperTemplateId INT ,
      ETUS_PaperTemplateDate DATETIME2 ,
      ETUS_DepartmentId INT ,
      ETUS_DepartmentName VARCHAR(50) ,
      ETUS_UserId INT ,
      ETUS_UserName VARCHAR(10) ,
      ETUS_DutyId INT ,
      ETUS_DutyName VARCHAR(50) ,
      ETUS_PaperId INT ,
      ETUS_PaperAddTime DATETIME2 ,
      ETUS_Score INT ,
      ETUS_State TINYINT
    )
AS 
    BEGIN
    
        INSERT  INTO @table
                SELECT  et_ept.ET_Id AS ETUS_TaskId ,
                        et_ept.ET_Name AS ETUS_TaskName ,
                        et_ept.ET_Type AS ETUS_TaskType,
                        et_ept.ET_AutoType AS ETUS_TaskAutoType ,
                        et_ept.ET_StatisticType AS ETUS_TaskStatisticType ,
                        et_ept.EPT_Id AS ETUS_PaperTemplateId ,
                        et_ept.EPT_StartDate AS ETUS_Date ,
                        d.D_Id AS ETUS_DepartmentId ,
                        d.D_Name AS ETUS_DepartmentName ,
                        u_du.U_Id AS ETUS_UserId ,
                        u_du.U_Name AS ETUS_UserName ,
                        u_du.Du_Id AS ETUS_DutyId ,
                        u_du.Du_Name AS ETUS_DutyName ,
                        ep.EP_Id AS ETUS_PaperId ,
                        ep.EP_AddTime AS ETUS_PaperAddTime ,
                        ISNULL(ep.EP_Score, -1) AS ETUS_Score ,
                        ( CASE WHEN ep.EP_Score IS NULL THEN 1
                               ELSE CASE WHEN et_ept.ET_StatisticType = 1 THEN CASE WHEN EP_Score = -1 THEN 4
                                                                                    WHEN ep.EP_Score >= et_ept.ET_TotalScore * 0.6 THEN 2
                                                                                    ELSE 3
                                                                               END
                                         WHEN et_ept.ET_StatisticType = 2 THEN CASE WHEN EP_Score = -1 THEN 4
                                                                                    WHEN ep.EP_Score >= 60 THEN 2
                                                                                    ELSE 3
                                                                               END
                                         ELSE 0
                                    END
                          END ) AS ETUS_State /* 0未设置 1未考试 2合格 3未合格 4未打分 */
                FROM    ( SELECT    *
                          FROM      ExaminationTasks et
                                    LEFT JOIN ( SELECT  EPT_Id ,
                                                        ET_Id AS ET_Id1 ,
                                                        EPT_StartDate
                                                FROM    ExaminationPaperTemplates
                                              ) ept ON et.ET_Id = ept.ET_Id1
                        ) et_ept
                        LEFT JOIN ExaminationTaskAttendees eta ON et_ept.ET_Id = eta.ET_Id
                        LEFT JOIN ( SELECT  *
                                    FROM    ( SELECT    U_Id ,
                                                        U_Name ,
                                                        Du_Id AS Du_Id1
                                              FROM      Users
                                              WHERE U_Status = 1
                                            ) u
                                            LEFT JOIN Duties du ON u.Du_Id1 = du.Du_Id
                                  ) u_du ON eta.U_Id = u_du.U_Id
                        LEFT JOIN ExaminationPapers ep ON et_ept.EPT_Id = ep.EPT_Id
                                                          AND u_du.U_Id = ep.EP_UserId ,
                        User_Department ud ,
                        Departments d
                WHERE   u_du.U_Id IS NOT NULL
                        AND u_du.U_Id = ud.U_Id
                        AND ud.D_Id = d.D_Id
                        AND et_ept.ET_Status = 1
                
        RETURN;
    END
    
    GO
    
IF OBJECT_ID('ExaminationTaskUserStatistic', 'V') IS NOT NULL 
    DROP VIEW ExaminationTaskUserStatistic

GO

CREATE VIEW ExaminationTaskUserStatistic
AS
    SELECT  *
    FROM    dbo.fn_GetExaminationTaskUserStatistic()

GO
