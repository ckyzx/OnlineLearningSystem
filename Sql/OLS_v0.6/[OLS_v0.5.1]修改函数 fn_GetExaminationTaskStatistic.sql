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