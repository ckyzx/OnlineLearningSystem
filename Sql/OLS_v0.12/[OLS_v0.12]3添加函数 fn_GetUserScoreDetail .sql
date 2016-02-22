USE OLS;

GO

IF OBJECT_ID(N'dbo.fn_GetUserScoreDetail', 'TF') IS NOT NULL 
    DROP FUNCTION dbo.fn_GetUserScoreDetail;
GO

CREATE FUNCTION dbo.fn_GetUserScoreDetail ()
RETURNS @table TABLE
    (
      USD_UserId INT NOT NULL ,
      USD_UserName NVARCHAR(50) NOT NULL ,
      USD_TaskId INT NOT NULL ,
      USD_TaskName NVARCHAR(50) NOT NULL ,
      USD_TaskStatisticType TINYINT NOT NULL ,
      USD_PaperTemplateId INT NOT NULL ,
      USD_StartDate DATETIME2 NOT NULL ,
      USD_StartTime DATETIME2 NOT NULL ,
      USD_PaperId INT NOT NULL ,
      USD_Score INT NOT NULL ,
      USD_State TINYINT NOT NULL
    )
AS 
    BEGIN
        INSERT  INTO @table
                SELECT  u.U_Id USD_UserId ,
                        u.U_Name USD_UserName ,
                        et.ET_Id USD_TaskId ,
                        et.ET_Name USD_TaskName ,
                        et.ET_StatisticType USD_TaskStatisticType ,
                        ept.EPT_Id USD_PaperTemplateId ,
                        ept.EPT_StartDate USD_StartDate ,
                        ept.EPT_StartTime USD_StartTime ,
                        ep.EP_Id USD_PaperId ,
                        ep.EP_Score USD_Score ,
                        ( CASE WHEN ep.EP_Score IS NULL THEN 1
                               ELSE CASE WHEN et.ET_StatisticType = 1
                                         THEN CASE WHEN EP_Score = -1 THEN 2
                                                   WHEN ( ep.EP_Score
                                                          / CAST(et.ET_TotalScore AS FLOAT)
                                                          * 100 ) > 59 THEN 3
                                                   ELSE 4
                                              END
                                         WHEN et.ET_StatisticType = 2
                                         THEN CASE WHEN EP_Score = -1 THEN 2
                                                   WHEN ep.EP_Score > 59
                                                   THEN 3
                                                   ELSE 4
                                              END
                                         ELSE 0
                                    END
                          END ) AS ETUS_State /* 0未设置 1未考试 2未打分 3合格 4未合格 */
                FROM    dbo.Users u
                        LEFT JOIN dbo.User_Department ud ON u.U_Id = ud.U_Id
                        LEFT JOIN dbo.Departments d ON ud.D_Id = d.D_Id
                        LEFT JOIN dbo.Duties du ON u.Du_Id = du.Du_Id
                        LEFT JOIN dbo.ExaminationTaskAttendees eta ON u.U_Id = eta.U_Id
                        LEFT JOIN dbo.ExaminationTasks et ON eta.ET_Id = et.ET_Id
                        LEFT JOIN dbo.ExaminationPaperTemplates ept ON et.ET_Id = ept.ET_Id
                        LEFT JOIN dbo.ExaminationPapers ep ON ept.EPT_Id = ep.EPT_Id
                WHERE   u.U_Id = ep.EP_UserId
        RETURN;
    END