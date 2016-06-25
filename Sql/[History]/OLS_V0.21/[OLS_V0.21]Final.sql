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
** [OLS_V0.21]1.sql
****************************************************/
BEGIN
DECLARE @pcId INT ,
    @pId INT;

SELECT  @pcId = 7;
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
          N'获取试题分类树表数据' ,
          N'QuestionClassify' ,
          N'GetZTreeResJson' ,
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
** [OLS_V0.21]2.sql
****************************************************/
BEGIN
DECLARE @pcId INT ,
    @pId INT;

SELECT  @pcId = 13;
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
          N'获取资料目录树表数据' ,
          N'LearningDataCategory' ,
          N'GetZTreeResJson' ,
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
** [OLS_V0.21]3.sql
****************************************************/
BEGIN
DECLARE @pcId INT ,
    @pId INT;

SELECT  @pcId = 3;
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
          N'获取部门树表数据' ,
          N'Department' ,
          N'GetZTreeResJson' ,
          NULL ,
          CAST(0x079DAEB04D8BAB3A0B AS DATETIME2)
        )
        
SET IDENTITY_INSERT [dbo].[Permissions] OFF
END

EXEC dbo.UpdateAdminRole;

GO


/***************************************************
** [OLS_V0.21]5.sql
****************************************************/
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


/***************************************************
** [OLS_V0.21.4]1.sql
****************************************************/
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
          N'考试任务列表，学员后台' ,
          N'ExaminationTask' ,
          N'ListStudent' ,
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
          N'进入练习' ,
          N'ExaminationTask' ,
          N'EnterExercise' ,
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
          N'查询考试任务' ,
          N'ExaminationTask' ,
          N'ListDataTablesAjaxByType' ,
          NULL ,
          CAST(0x079DAEB04D8BAB3A0B AS DATETIME2)
        )
SET IDENTITY_INSERT [dbo].[Permissions] OFF
END

GO


/***************************************************
** [OLS_V0.21.4]2.sql
****************************************************/
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
        R_Permissions = '[46,47,79,81,89,90,93,94,95,96,130,131,132,148,158,159,168,170,171,179,180]'
WHERE   R_Id = 2;

GO

EXEC dbo.UpdateAdminRole;

GO


/***************************************************
** [OLS_V0.21.4]3.sql
****************************************************/
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
                                    AND et.ET_Type = 0 /* 只统计"考试"类型 */
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


/***************************************************
** [OLS_V0.21.4]4.sql
****************************************************/
IF OBJECT_ID(N'fn_GetExaminationTaskUserStatistic', N'TF') IS NOT NULL 
    DROP FUNCTION fn_GetExaminationTaskUserStatistic;
GO

CREATE FUNCTION fn_GetExaminationTaskUserStatistic ( )
RETURNS @table TABLE
    (
      ETUS_TaskId INT ,
      ETUS_TaskName VARCHAR(50) ,
      ETUS_TaskType TINYINT ,
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
                        et_ept.ET_Type AS ETUS_TaskType ,
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
                          WHERE     et.ET_Type = 0 /* 只统计"考试"类型 */
                        ) et_ept
                        LEFT JOIN ExaminationTaskAttendees eta ON et_ept.ET_Id = eta.ET_Id
                        LEFT JOIN ( SELECT  *
                                    FROM    ( SELECT    U_Id ,
                                                        U_Name ,
                                                        Du_Id AS Du_Id1
                                              FROM      Users
                                              WHERE     U_Status = 1
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


/***************************************************
** [OLS_V0.21.4]5.sql
****************************************************/
IF OBJECT_ID(N'dbo.fn_GetUserScoreDoneNumber', 'FN') IS NOT NULL 
    DROP FUNCTION dbo.fn_GetUserScoreDoneNumber;
GO

CREATE FUNCTION fn_GetUserScoreDoneNumber
    (
      @etId INT ,
      @eptId INT ,
      @uId INT 
    )
RETURNS INT
AS 
    BEGIN
    
        DECLARE @doneNumber INT;
    
        SELECT  @doneNumber = COUNT(ep1.EP_Id)
        FROM    ( SELECT    *
                  FROM      dbo.ExaminationTasks
                  WHERE     ET_Status = 1 AND ET_Type = 0 /* 只统计"考试"类型 */
                ) et1
                LEFT JOIN dbo.ExaminationTaskAttendees eta1 ON et1.ET_Id = eta1.ET_Id
                LEFT JOIN dbo.Users u1 ON eta1.U_Id = u1.U_Id
                LEFT JOIN dbo.ExaminationPaperTemplates ept1 ON et1.ET_Id = ept1.ET_Id
                LEFT JOIN dbo.ExaminationPapers ep1 ON et1.ET_Id = ep1.ET_Id
        WHERE   ep1.EP_UserId = u1.U_Id
                AND ept1.EPT_Id = ep1.EPT_Id
                AND ep1.EP_Id IS NOT NULL
                AND et1.ET_Id = @etId
                AND ept1.EPT_Id = @eptId
                AND ep1.EP_UserId = @uId
                
        RETURN @doneNumber;
    END

GO

IF OBJECT_ID(N'dbo.fn_GetUserScorePassNumber', 'FN') IS NOT NULL 
    DROP FUNCTION dbo.fn_GetUserScorePassNumber;
GO

CREATE FUNCTION dbo.fn_GetUserScorePassNumber
    (
      @etId INT ,
      @eptId INT ,
      @uId INT 
    )
RETURNS INT
AS 
    BEGIN

        DECLARE @passNumber INT;

        SELECT  @passNumber = SUM(CASE et2.ET_StatisticType
                                    WHEN 1 THEN ( CASE WHEN ( ep2.EP_Score / CAST(et2.ET_TotalScore AS FLOAT) * 100 ) > 59 THEN 1
                                                       ELSE 0
                                                  END )
                                    WHEN 2 THEN ( CASE WHEN ep2.EP_Score > 59 THEN 1
                                                       ELSE 0
                                                  END )
                                    ELSE 0
                                  END)
        FROM    ( SELECT    *
                  FROM      dbo.ExaminationTasks
                  WHERE     ET_Status = 1 AND ET_Type = 0 /* 只统计"考试"类型 */
                ) et2
                LEFT JOIN dbo.ExaminationTaskAttendees eta2 ON et2.ET_Id = eta2.ET_Id
                LEFT JOIN dbo.Users u2 ON eta2.U_Id = u2.U_Id
                LEFT JOIN dbo.ExaminationPaperTemplates ept2 ON et2.ET_Id = ept2.ET_Id
                LEFT JOIN dbo.ExaminationPapers ep2 ON et2.ET_Id = ep2.ET_Id
        WHERE   ep2.EP_UserId = u2.U_Id
                AND ept2.EPT_Id = ep2.EPT_Id
                AND ep2.EP_Id IS NOT NULL
                AND et2.ET_Id = @etId
                AND ept2.EPT_Id = @eptId
                AND ep2.EP_UserId = @uId
                                                            
        RETURN @passNumber;
    END

GO

IF OBJECT_ID(N'dbo.sfn_GetUserScoreSummary', 'TF') IS NOT NULL 
    DROP FUNCTION dbo.sfn_GetUserScoreSummary;
GO

CREATE FUNCTION dbo.sfn_GetUserScoreSummary ( )
RETURNS @table TABLE
    (
      USS_UserId INT NOT NULL ,
      USS_UserName NVARCHAR(50) NOT NULL ,
      USS_DepartmentId INT NULL ,
      USS_DepartmentName NVARCHAR(50) NULL ,
      USS_DutyName NVARCHAR(50) NULL ,
      USS_TaskId INT NULL ,
      USS_TaskName NVARCHAR(50) NULL ,
      USS_PaperTemplateId INT NULL ,
      USS_StartTime DATETIME2 NULL ,
      USS_DoneNumber INT NULL ,
      USS_PassNumber INT NULL
    )
AS 
    BEGIN
        INSERT  INTO @table
                SELECT  u.U_Id USS_UserId ,
                        u.U_Name USS_UserName ,
                        d.D_Id USS_DepartmentId ,
                        d.D_Name USS_DepartmentName ,
                        du.Du_Name USS_DutyName ,
                        et.ET_Id USS_TaskId ,
                        et.ET_Name USS_TaskName ,
                        ept.EPT_Id USS_PaperTemplateId ,
                        ept.EPT_StartDate USS_StartTime ,
                        dbo.fn_GetUserScoreDoneNumber(et.ET_Id, ept.EPT_Id, u.U_Id) USS_DoneNumber ,
                        dbo.fn_GetUserScorePassNumber(et.ET_Id, ept.EPT_Id, u.U_Id) USS_PassNumber
                FROM    dbo.Users u
                        LEFT JOIN dbo.User_Department ud ON u.U_Id = ud.U_Id
                        LEFT JOIN dbo.Departments d ON ud.D_Id = d.D_Id
                        LEFT JOIN dbo.Duties du ON u.Du_Id = du.Du_Id
                        LEFT JOIN dbo.ExaminationTaskAttendees eta ON u.U_Id = eta.U_Id
                        LEFT JOIN ( SELECT  *
                                    FROM    dbo.ExaminationTasks
                                    WHERE   ET_Status = 1 AND ET_Type = 0 /* 只统计"考试"类型 */
                                  ) et ON eta.ET_Id = et.ET_Id
                        LEFT JOIN dbo.ExaminationPaperTemplates ept ON et.ET_Id = ept.ET_Id
                WHERE   u.U_Status = 1
                        AND d.D_Status = 1
                        AND ( du.Du_Status = 1
                              OR du.Du_Status IS NULL
                            )
                        AND ept.EPT_Status IS NOT NULL
        RETURN;
    END

GO

IF OBJECT_ID(N'dbo.fn_GetUserScoreSummary', 'TF') IS NOT NULL 
    DROP FUNCTION dbo.fn_GetUserScoreSummary;
GO

CREATE FUNCTION dbo.fn_GetUserScoreSummary ( )
RETURNS @table TABLE
    (
      USS_UserId INT NOT NULL ,
      USS_UserName NVARCHAR(50) NOT NULL ,
      USS_DepartmentId INT NOT NULL ,
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
                        USS_DepartmentId ,
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
                                    USS_DepartmentId ,
                                    USS_DepartmentName ,
                                    USS_DutyName ,
                                    COUNT(USS_TaskName) USS_TotalNumber ,
                                    SUM(USS_DoneNumber) USS_DoneNumber ,
                                    SUM(ISNULL(USS_PassNumber, 0)) USS_PassNumber
                          FROM      dbo.sfn_GetUserScoreSummary( )
                          GROUP BY  USS_UserId ,
                                    USS_UserName ,
                                    USS_DepartmentId ,
                                    USS_DepartmentName ,
                                    USS_DutyName
                        ) TmpTable1
		
        RETURN;
    END

GO

IF OBJECT_ID(N'dbo.UserScoreSummaries', 'V') IS NOT NULL 
    DROP VIEW dbo.UserScoreSummaries;
GO

CREATE VIEW dbo.UserScoreSummaries
AS
    SELECT  *
    FROM    dbo.fn_GetUserScoreSummary()

GO


/***************************************************
** [OLS_V0.21.4]6.sql
****************************************************/
IF OBJECT_ID(N'dbo.fn_GetUserInfo', 'TF') IS NOT NULL 
    DROP FUNCTION dbo.fn_GetUserInfo;

GO

CREATE FUNCTION dbo.fn_GetUserInfo ( )
RETURNS @table TABLE
    (
      U_Id INT NOT NULL ,
      U_Name NVARCHAR(50) NOT NULL ,
      U_Status TINYINT NOT NULL ,
      D_Id INT NULL ,
      D_Name NVARCHAR(50) NULL ,
      D_Status TINYINT NULL ,
      Du_Id INT NULL ,
      Du_Name NVARCHAR(50) NULL ,
      Du_Status TINYINT NULL
    )
AS 
    BEGIN
        INSERT  INTO @table
                SELECT  u.U_Id ,
                        u.U_Name ,
                        u.U_Status ,
                        d.D_Id ,
                        d.D_Name ,
                        d.D_Status ,
                        du.Du_Id ,
                        du.Du_Name ,
                        du.Du_Status
                FROM    dbo.Users u
                        LEFT JOIN dbo.User_Department ud ON u.U_Id = ud.U_Id
                        LEFT JOIN dbo.Departments d ON ud.D_Id = d.D_Id
                        LEFT JOIN dbo.Duties du ON u.Du_Id = du.Du_Id
        RETURN;
    END

GO

IF OBJECT_ID(N'dbo.sfn_UserScoreState', 'FN') IS NOT NULL 
    DROP FUNCTION dbo.sfn_UserScoreState;
GO

CREATE FUNCTION dbo.sfn_UserScoreState
    (
      @epScore INT ,
      @etStatisticType TINYINT ,
      @etTotalScore INT
    )
RETURNS INT
AS 
    BEGIN
		/* 0未设置 1未考试 2未打分 3合格 4未合格 */
        RETURN 
			CASE WHEN @epScore IS NOT NULL THEN 
					CASE WHEN @etStatisticType = 1 THEN 
							CASE WHEN @epScore = -1 THEN 2 
								 WHEN ( @epScore / CAST(@etTotalScore AS FLOAT) * 100 ) > 59 THEN 3
								 ELSE 4
							END
						 WHEN @etStatisticType = 2 THEN 
							CASE WHEN @epScore = -1 THEN 2
								 WHEN @epScore > 59 THEN 3
								 ELSE 4
							END
						 ELSE 0
				   END
				 ELSE 1
		   END
    END
GO

IF OBJECT_ID(N'dbo.fn_UserScoreState', 'FN') IS NOT NULL 
    DROP FUNCTION dbo.fn_UserScoreState;
GO

CREATE FUNCTION dbo.fn_UserScoreState
    (
      @eptId INT ,
      @epScore INT ,
      @etStatisticType TINYINT ,
      @etTotalScore INT
    )
RETURNS INT
AS 
    BEGIN
		/* 0未设置 1未考试 2未打分 3合格 4未合格 */
        RETURN 
			CASE WHEN @eptId IS NOT NULL THEN 
					dbo.sfn_UserScoreState(@epScore,@etStatisticType,@etTotalScore)
                 ELSE 0
            END
    END

GO

IF OBJECT_ID(N'dbo.sfn_GetUserScoreDetail', 'TF') IS NOT NULL 
    DROP FUNCTION dbo.sfn_GetUserScoreDetail;

GO

CREATE FUNCTION dbo.sfn_GetUserScoreDetail ( )
RETURNS @table TABLE
    (
      USD_UserId INT NOT NULL ,
      USD_UserName NVARCHAR(50) NOT NULL ,
      USD_DepartmentId INT NULL ,
      USD_DepartmentName NVARCHAR(50) NULL ,
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
                SELECT  u1.U_Id USD_UserId ,
                        u1.U_Name USD_UserName ,
                        u1.D_Id USD_DepartmentId ,
                        u1.D_Name USD_DepartmentName ,
                        et.ET_Id USD_TaskId ,
                        et.ET_Name USD_TaskName ,
                        et.ET_StatisticType USD_TaskStatisticType ,
                        ept.EPT_Id USD_PaperTemplateId ,
                        ept.EPT_StartDate USD_StartDate ,
                        ept.EPT_StartTime USD_StartTime ,
                        ISNULL(ep.EP_Id, 0) USD_PaperId ,
                        ISNULL(ep.EP_Score, -1) USD_Score ,
                        dbo.fn_UserScoreState(ept.EPT_Id, ep.EP_Score, et.ET_StatisticType, et.ET_TotalScore) AS ETUS_State
                FROM    fn_GetUserInfo() u1
                        LEFT JOIN dbo.ExaminationTaskAttendees eta ON eta.U_Id = u1.U_Id
                        LEFT JOIN ( SELECT  *
                                    FROM    dbo.ExaminationTasks
                                    WHERE   ET_Status = 1
                                            AND ET_Type = 0 /* 只统计"考试"类型 */
                                  ) et ON et.ET_Id = eta.ET_Id
                        LEFT JOIN dbo.ExaminationPaperTemplates ept ON ept.ET_Id = et.ET_Id
                        LEFT JOIN dbo.ExaminationPapers ep ON ep.EPT_Id = ept.EPT_Id
                                                              AND ep.EP_UserId = u1.U_Id
                WHERE   ept.EPT_Id IS NOT NULL
        RETURN;
    END

GO

IF OBJECT_ID(N'dbo.fn_GetUserScoreDetail', 'TF') IS NOT NULL 
    DROP FUNCTION dbo.fn_GetUserScoreDetail;
GO

CREATE FUNCTION dbo.fn_GetUserScoreDetail ( )
RETURNS @table TABLE
    (
      USD_UserId INT NOT NULL ,
      USD_UserName NVARCHAR(50) NOT NULL ,
      USD_DepartmentId INT NULL ,
      USD_DepartmentName NVARCHAR(50) NULL ,
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
                FROM    ( SELECT    *
                          FROM      sfn_GetUserScoreDetail()
                          WHERE     USD_PaperId IS NOT NULL
                                    AND USD_TaskId IS NOT NULL
						  --添加未考试的记录
                          UNION ALL
                          SELECT    *
                          FROM      sfn_GetUserScoreDetail()
                          WHERE     USD_PaperId IS NULL
                                    AND USD_TaskId IS NOT NULL
                        ) tmp
                ORDER BY USD_PaperTemplateId ASC ,
                        USD_TaskId ASC ,
                        USD_PaperId ASC
        RETURN;
    END

GO

IF OBJECT_ID(N'dbo.UserScoreDetails', 'V') IS NOT NULL 
    DROP VIEW dbo.UserScoreDetails;
GO

CREATE VIEW dbo.UserScoreDetails
AS
    SELECT  *
    FROM    dbo.fn_GetUserScoreDetail()

GO
