USE OLS;

GO

-- ÃÌº” ‘æÌ◊÷∂Œ°∞øº ‘»ŒŒÒ°±
ALTER TABLE dbo.ExaminationPapers
ADD ET_Id INT NULL

GO

ALTER TABLE ExaminationPapers
ADD CONSTRAINT FK_EXAMINAT_EP_ET_EXAMINAT FOREIGN KEY (ET_Id)
REFERENCES ExaminationTasks (ET_Id)

GO