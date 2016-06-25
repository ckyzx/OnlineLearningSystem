USE OLS;

GO

ALTER TABLE dbo.ExaminationTasks
ADD ET_ContinuedDays TINYINT NULL;

GO

UPDATE  dbo.ExaminationTasks
SET     ET_ContinuedDays = 0
WHERE   ET_Mode = 0;
UPDATE  dbo.ExaminationTasks
SET     ET_ContinuedDays = 1
WHERE   ET_Mode <> 0;

GO

ALTER TABLE dbo.ExaminationTasks
ALTER COLUMN ET_ContinuedDays TINYINT NOT NULL;

GO

ALTER TABLE dbo.ExaminationTaskTemplates
ADD ETT_ContinuedDays TINYINT NULL;

GO

UPDATE  dbo.ExaminationTaskTemplates
SET     ETT_ContinuedDays = 0
WHERE   ETT_Mode = 0;
UPDATE  dbo.ExaminationTaskTemplates
SET     ETT_ContinuedDays = 1
WHERE   ETT_Mode <> 0;

GO

ALTER TABLE dbo.ExaminationTaskTemplates
ALTER COLUMN ETT_ContinuedDays TINYINT NOT NULL;

GO
