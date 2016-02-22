USE OLS;

GO

ALTER TABLE dbo.ExaminationPaperQuestions
ADD CONSTRAINT FK_EPQ_EPTQ FOREIGN KEY (EPQ_Id)
REFERENCES dbo.ExaminationPaperTemplateQuestions (EPTQ_Id)

GO