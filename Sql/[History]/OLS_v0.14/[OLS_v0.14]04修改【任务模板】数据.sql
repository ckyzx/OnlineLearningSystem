USE OLS;

GO

UPDATE  dbo.ExaminationTaskTemplates
SET     ETT_EndTime = '1970-01-01 12:00:00.0000000'
WHERE   ETT_Mode = 1;

GO
