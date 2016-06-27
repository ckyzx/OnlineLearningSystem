USE OLS;

GO

IF OBJECT_ID(N'dbo.ExaminationQuestionDones', 'U') IS NOT NULL 
    DROP TABLE dbo.ExaminationQuestionDones;

GO

CREATE TABLE ExaminationQuestionDones
    (
      EQD_Id INT IDENTITY ,
      ET_Id INT NOT NULL ,
      EPT_Id INT NOT NULL ,
      U_Id INT NOT NULL ,
      Q_Id INT NOT NULL ,
      CONSTRAINT PK_EQD PRIMARY KEY ( EQD_Id )
    );

GO
