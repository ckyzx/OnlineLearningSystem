USE OLS;

GO

IF OBJECT_ID(N'dbo.fn_GetUserScoreDetail', 'TF') IS NOT NULL 
    DROP FUNCTION dbo.fn_GetUserScoreDetail;
GO

CREATE FUNCTION dbo.fn_GetUserScoreDetail ( )
RETURNS @table TABLE
    (
      USD_UserId INT NOT NULL ,
      USD_UserName NVARCHAR(50) NOT NULL ,
      USD_DepartmentId INT NOT NULL,
      USD_DepartmentName NVARCHAR(50) NOT NULL,
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
                                    u1.D_Id USD_DepartmentId,
                                    u1.D_Name USD_DepartmentName,
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
                                                u.U_Status ,
                                                d.D_Id ,
                                                d.D_Name ,
                                                d.D_Status ,
                                                du.Du_Id ,
                                                du.Du_Name ,
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
                                    u1.D_Id USD_DepartmentId,
                                    u1.D_Name USD_DepartmentName,
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
                                                u.U_Status ,
                                                d.D_Id ,
                                                d.D_Name ,
                                                d.D_Status ,
                                                du.Du_Id ,
                                                du.Du_Name ,
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
                                    AND et.ET_Id IS NOT  NULL
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
