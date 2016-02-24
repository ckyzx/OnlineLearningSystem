USE OLS;

GO

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
