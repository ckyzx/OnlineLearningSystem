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

-- [1]更新数据结构
-- [OLS_v0.5.1]UpdateOLS.sql
-- 添加试卷字段“考试任务”
ALTER TABLE dbo.ExaminationPapers
ADD ET_Id INT NULL

GO

ALTER TABLE ExaminationPapers
ADD CONSTRAINT FK_EXAMINAT_EP_ET_EXAMINAT FOREIGN KEY (ET_Id)
REFERENCES ExaminationTasks (ET_Id)

GO
/******************************************************************************************************/

-- [2]添加权限值
-- [OLS_v0.5.2]添加权限值.sql
-- 添加角色权限“个人考试统计”
SET IDENTITY_INSERT [dbo].[Permissions] ON
INSERT [dbo].[Permissions] ([P_Id], [P_AutoId], [PC_Id], [P_Name], [P_Controller], [P_Action], [P_Remark], [P_AddTime]) 
VALUES (130, 130, 6, N'个人考试统计', N'ExaminationTaskStatistic', N'Personal', NULL, CAST(0x079DAEB04D8BAB3A0B AS DateTime2));
SET IDENTITY_INSERT [dbo].[Permissions] OFF
INSERT [dbo].[Role_Permission] ([R_Id], [P_Id]) VALUES (1, 130)
UPDATE Roles SET 
R_Permissions = '[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130]',
R_PermissionCategories = '[1,2,3,4,5,6,7,8,9,10,11]'
WHERE R_Id = 1

GO

-- 设置用户公共权限
INSERT [dbo].[Role_Permission]
SELECT R_Id, 130 FROM dbo.Roles WHERE R_Id <> 1;

UPDATE Roles SET 
R_Permissions = '[46,47,79,81,89,90,93,94,95,96,130]',
R_PermissionCategories = '[6,11]'
WHERE R_Id <> 1;

GO

-- 添加角色权限“获取用户试题数据”
SET IDENTITY_INSERT [dbo].[Permissions] ON
INSERT [dbo].[Permissions] ([P_Id], [P_AutoId], [PC_Id], [P_Name], [P_Controller], [P_Action], [P_Remark], [P_AddTime]) 
VALUES (131, 131, 11, N'获取用户试题数据', N'ExaminationPaperTemplate', N'GetQuestionsForUser', NULL, CAST(0x079DAEB04D8BAB3A0B AS DateTime2));
SET IDENTITY_INSERT [dbo].[Permissions] OFF
INSERT [dbo].[Role_Permission] ([R_Id], [P_Id]) VALUES (1, 131)
UPDATE Roles SET 
R_Permissions = '[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131]',
R_PermissionCategories = '[1,2,3,4,5,6,7,8,9,10,11]'
WHERE R_Id = 1

GO

-- 设置用户公共权限
INSERT [dbo].[Role_Permission]
SELECT R_Id, 131 FROM dbo.Roles WHERE R_Id <> 1;

UPDATE Roles SET 
R_Permissions = '[46,47,79,81,89,90,93,94,95,96,130,131]',
R_PermissionCategories = '[6,11]'
WHERE R_Id <> 1;

-- 添加角色权限“查看试卷”
SET IDENTITY_INSERT [dbo].[Permissions] ON
INSERT [dbo].[Permissions] ([P_Id], [P_AutoId], [PC_Id], [P_Name], [P_Controller], [P_Action], [P_Remark], [P_AddTime]) 
VALUES (132, 132, 11, N'查看试卷', N'ExaminationPaperTemplate', N'PaperView', NULL, CAST(0x079DAEB04D8BAB3A0B AS DateTime2));
SET IDENTITY_INSERT [dbo].[Permissions] OFF
INSERT [dbo].[Role_Permission] ([R_Id], [P_Id]) VALUES (1, 132)
UPDATE Roles SET 
R_Permissions = '[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132]',
R_PermissionCategories = '[1,2,3,4,5,6,7,8,9,10,11]'
WHERE R_Id = 1

GO

-- 设置用户公共权限
INSERT [dbo].[Role_Permission]
SELECT R_Id, 132 FROM dbo.Roles WHERE R_Id <> 1;

UPDATE Roles SET 
R_Permissions = '[46,47,79,81,89,90,93,94,95,96,130,131,132]',
R_PermissionCategories = '[6,11]'
WHERE R_Id <> 1;

GO
/******************************************************************************************************/

-- [3]修改函数
-- [OLS_v0.5.1]修改函数 fn_GetExaminationTaskStatistic.sql
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
                SELECT  et1.ET_Id AS ETS_TaskId ,
                        ET_Name AS ETS_TaskName ,
                        EPT_Id AS ETS_PaperTemplateId ,
                        EPT_StartDate AS ETS_PaperTemplateDate ,
                        ( CASE WHEN LEN(ET_Attendee1) = 2 THEN 0
                               WHEN LEN(ET_Attendee1) > 2 THEN CASE WHEN LEN(ET_Attendee1) = 3 THEN 1
                                                                    ELSE LEN(REPLACE(ET_Attendee1, ',', '||')) - LEN(ET_Attendee1) + 1
                                                               END
                          END ) AS ETS_AttendeeNumber ,
                        ( SELECT    COUNT(EP_Id)
                          FROM      ExaminationPapers ep
                                    LEFT JOIN ExaminationPaperTemplates ept ON ep.EPT_Id = ept.EPT_Id
                          WHERE     ept.ET_Id = et1.ET_Id
                                    AND ept.EPT_Id = ept1.EPT_Id
                        ) AS ETS_PaperNumber ,
                        ( SELECT    COUNT(EP_Id)
                          FROM      ExaminationPapers ep
                                    LEFT JOIN ExaminationPaperTemplates ept ON ep.EPT_Id = ept.EPT_Id
                          WHERE     ept.ET_Id = et1.ET_Id
                                    AND ept.EPT_Id = ept1.EPT_Id
                                    AND ( CASE WHEN ET_StatisticType = 1 THEN CASE WHEN EP_Score = -1 THEN 0
                                                                                   WHEN EP_Score >= et1.ET_TotalScore * 0.6 THEN 1
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
                          WHERE     ept.ET_Id = et1.ET_Id
                                    AND ept.EPT_Id = ept1.EPT_Id
                                    AND ( CASE WHEN ET_StatisticType = 1 THEN CASE WHEN EP_Score = -1 THEN 0
                                                                                   WHEN EP_Score < et1.ET_TotalScore * 0.6 THEN 1
                                                                                   ELSE 0
                                                                              END
                                               WHEN ET_StatisticType = 2 THEN CASE WHEN EP_Score < 60 THEN 1
                                                                                   ELSE 0
                                                                              END
                                          END ) = 1
                        ) AS ETS_FlunkNumber
                FROM    ( SELECT    CAST(ET_Attendee AS VARCHAR(MAX)) AS ET_Attendee1 ,
                                    *
                          FROM      dbo.ExaminationTasks et
                        ) et1 ,
                        dbo.ExaminationPaperTemplates AS ept1
                WHERE   et1.ET_Status = 1
                        AND ept1.EPT_Status = 1
                        AND et1.ET_Id = ept1.ET_Id
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
/******************************************************************************************************/

-- [OLS_v0.5.2]修改函数 fn_GetExaminationTaskUserStatistic.sql
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
                                            ) u
                                            LEFT JOIN Duties du ON u.Du_Id1 = du.Du_Id
                                  ) u_du ON eta.U_Id = u_du.U_Id
                        LEFT JOIN ExaminationPapers ep ON et_ept.EPT_Id = ep.EPT_Id
                                                          AND u_du.U_Id = ep.EP_UserId ,
                        User_Department ud ,
                        Departments d
                WHERE   et_ept.ET_Status = 1
                        AND u_du.U_Id IS NOT NULL
                        AND u_du.U_Id = ud.U_Id
                        AND ud.D_Id = d.D_Id
                
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
/******************************************************************************************************/

-- [4]添加函数
-- [OLS_v0.5.2]添加函数 fn_GetExaminationTaskPersonalStatistic.sql
IF OBJECT_ID(N'fn_GetExaminationTaskPersonalStatistic', N'TF') IS NOT NULL 
    DROP FUNCTION fn_GetExaminationTaskPersonalStatistic;
GO

CREATE FUNCTION fn_GetExaminationTaskPersonalStatistic ( )
RETURNS @table TABLE
    (
      ETPS_UserId INT ,
      ETPS_UserName VARCHAR(10) ,
      ETPS_DepartmentId INT,
      ETPS_DepartmentName VARCHAR(50),
      ETPS_DutyId INT,
      ETPS_DutyName VARCHAR(50),
      ETPS_ExaminationTotalNumber FLOAT ,
      ETPS_UnexamineNumber FLOAT ,
      ETPS_ExaminedNumber FLOAT ,
      ETPS_ExaminationPassRatio FLOAT ,
      ETPS_ExerciseTotalNumber FLOAT ,
      ETPS_UnexerciseNumber FLOAT ,
      ETPS_ExercisedNumber FLOAT ,
      ETPS_ExercisePassRatio FLOAT
    )
AS 
    BEGIN
	
        INSERT  INTO @table
                SELECT  ETPS_UserId ,
                        ETPS_UserName ,
                        ETPS_DepartmentId,
                        ETPS_DepartmentName,
                        ETPS_DutyId,
                        ETPS_DutyName,
                        ETPS_ExaminationTotalNumber ,
                        ETPS_UnexamineNumber ,
                        ETPS_ExaminedNumber ,
                        ( CASE WHEN ETPS_ExaminationTotalNumber = 0 THEN 0
                               ELSE ROUND(( ETPS_ExaminedNumber + 0.0 ) / ETPS_ExaminationTotalNumber, 2)
                          END ) AS ETPS_ExaminationPassRatio ,
                        ETPS_ExerciseTotalNumber ,
                        ETPS_UnexerciseNumber ,
                        ETPS_ExercisedNumber ,
                        ( CASE WHEN ETPS_ExerciseTotalNumber = 0 THEN 0
                               ELSE ROUND(( ETPS_ExercisedNumber + 0.0 ) / ETPS_ExerciseTotalNumber, 2)
                          END ) AS ETPS_ExercisePassRatio
                FROM    ( SELECT    u.U_Id AS ETPS_UserId ,
                                    u.U_Name AS ETPS_UserName ,
                                    d.D_Id AS ETPS_DepartmentId,
                                    d.D_Name AS ETPS_DepartmentName,
                                    du.Du_Id AS ETPS_DutyId,
                                    du.Du_Name AS ETPS_DutyName,
                                    ( SELECT    COUNT(ETUS_UserId)
                                      FROM      ExaminationTaskUserStatistic
                                      WHERE     ETUS_UserId = u.U_Id
                                                AND ETUS_TaskType = 0
                                    ) AS ETPS_ExaminationTotalNumber ,
                                    ( SELECT    COUNT(ETUS_UserId)
                                      FROM      ExaminationTaskUserStatistic
                                      WHERE     ETUS_UserId = u.U_Id
                                                AND ETUS_TaskType = 0
                                                AND ETUS_PaperId IS NULL
                                    ) AS ETPS_UnexamineNumber ,
                                    ( SELECT    COUNT(ETUS_UserId)
                                      FROM      ExaminationTaskUserStatistic
                                      WHERE     ETUS_UserId = u.U_Id
                                                AND ETUS_TaskType = 0
                                                AND ETUS_PaperId IS NOT NULL
                                    ) AS ETPS_ExaminedNumber ,
                                    ( SELECT    COUNT(ETUS_UserId)
                                      FROM      ExaminationTaskUserStatistic
                                      WHERE     ETUS_UserId = u.U_Id
                                                AND ETUS_TaskType = 1
                                    ) AS ETPS_ExerciseTotalNumber ,
                                    ( SELECT    COUNT(ETUS_UserId)
                                      FROM      ExaminationTaskUserStatistic
                                      WHERE     ETUS_UserId = u.U_Id
                                                AND ETUS_TaskType = 1
                                                AND ETUS_PaperId IS NULL
                                    ) AS ETPS_UnexerciseNumber ,
                                    ( SELECT    COUNT(ETUS_UserId)
                                      FROM      ExaminationTaskUserStatistic
                                      WHERE     ETUS_UserId = u.U_Id
                                                AND ETUS_TaskType = 1
                                                AND ETUS_PaperId IS NOT NULL
                                    ) AS ETPS_ExercisedNumber
                          FROM      Users u LEFT JOIN Duties du ON u.Du_Id = du.Du_Id
									LEFT JOIN dbo.User_Department ud ON u.U_Id = ud.U_Id
									LEFT JOIN dbo.Departments d ON ud.D_Id = d.D_Id
                          WHERE     U_Status = 1
                        ) tmp;
	
        RETURN;
    END

GO
/******************************************************************************************************/

-- [5]添加视图
-- [OLS_v0.5.2]添加视图 ExaminationTaskPersonalStatistic.sql
IF OBJECT_ID(N'ExaminationTaskPersonalStatistic', N'V') IS NOT NULL
	DROP VIEW ExaminationTaskPersonalStatistic

GO

CREATE VIEW ExaminationTaskPersonalStatistic
AS
    SELECT  *
    FROM    dbo.fn_GetExaminationTaskPersonalStatistic()

GO
/******************************************************************************************************/