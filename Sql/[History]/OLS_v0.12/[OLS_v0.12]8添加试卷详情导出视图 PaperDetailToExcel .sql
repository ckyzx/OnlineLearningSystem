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
            PD_QuestionType 类型 ,
            PD_QuestionContent 题目 ,
            PD_QuestionAnswer 回答 ,
            PD_QuestionScore 分数 ,
            PD_QuestionExactness 状态
    FROM    dbo.fn_GetPaperDetail()

GO
