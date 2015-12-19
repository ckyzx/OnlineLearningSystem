USE OLS;

GO

IF OBJECT_ID('ExaminationTaskUserStatistic', 'V') IS NOT NULL 
    DROP VIEW ExaminationTaskUserStatistic

GO

CREATE VIEW ExaminationTaskUserStatistic
AS
    SELECT  *
    FROM    dbo.fn_GetExaminationTaskUserStatistic()