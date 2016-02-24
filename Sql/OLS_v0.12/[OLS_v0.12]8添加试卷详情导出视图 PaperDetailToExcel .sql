USE OLS;

GO

IF OBJECT_ID(N'dbo.PaperDetailToExcel', 'V') IS NOT NULL 
    DROP VIEW dbo.PaperDetailToExcel
GO

CREATE VIEW dbo.PaperDetailToExcel
AS
    SELECT  PD_TaskId ,
            PD_PaperTemplateId ,
            PD_PaperId ,
            PD_UserId ,
            PD_QuestionType ���� ,
            PD_QuestionContent ��Ŀ ,
            PD_QuestionAnswer �ش� ,
            PD_QuestionScore ���� ,
            PD_QuestionExactness ״̬
    FROM    dbo.fn_GetPaperDetail()

GO
