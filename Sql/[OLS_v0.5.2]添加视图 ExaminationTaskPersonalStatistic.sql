USE OLS;

GO

IF OBJECT_ID(N'ExaminationTaskPersonalStatistic', N'V') IS NOT NULL
	DROP VIEW ExaminationTaskPersonalStatistic

GO

CREATE VIEW ExaminationTaskPersonalStatistic
AS
    SELECT  *
    FROM    dbo.fn_GetExaminationTaskPersonalStatistic()