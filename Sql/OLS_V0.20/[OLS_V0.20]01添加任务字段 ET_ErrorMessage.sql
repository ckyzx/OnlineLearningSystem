USE OLS;

GO

ALTER TABLE dbo.ExaminationTasks
ADD ET_ErrorMessage NVARCHAR(1000) NULL;

GO
