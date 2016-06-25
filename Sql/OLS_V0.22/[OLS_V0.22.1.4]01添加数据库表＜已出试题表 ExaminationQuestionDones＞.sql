USE OLS;

GO

IF OBJECT_ID(N'dbo.ExaminationQuestionDones', 'U') IS NOT NULL
	DROP TABLE dbo.ExaminationQuestionDones;

GO

CREATE TABLE ExaminationQuestionDones (
	ET_Id INT NOT NULL,
	EPT_Id INT NOT NULL,
	Q_Id INT NOT NULL
);

GO
