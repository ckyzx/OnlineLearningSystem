USE OLS;

GO

IF OBJECT_ID ('ExaminationTaskStatistic', 'V') IS NOT NULL
DROP VIEW ExaminationTaskStatistic ;

GO

CREATE VIEW ExaminationTaskStatistic
AS
SELECT * FROM dbo.fn_GetExaminationTaskStatistic()

GO