USE OLS;

GO

IF OBJECT_ID(N'dbo.UserScoreSummaryToExcel') IS NOT NULL 
    DROP VIEW dbo.UserScoreSummaryToExcel

GO

CREATE VIEW dbo.UserScoreSummaryToExcel
AS
    SELECT  USS_UserId ,
            USS_UserName �û� ,
            USS_DepartmentName ���� ,
            USS_DutyName ְ�� ,
            USS_TotalNumber Ӧ�� ,
            USS_DoneNumber �ѿ� ,
            USS_UndoNumber δ�� ,
            USS_PassNumber �ϸ� ,
            CAST(USS_DoneRatio AS varchar(5)) + '%' �ο��� ,
            CAST(USS_PassRatio AS VARCHAR(5)) + '%' �ϸ���
    FROM    dbo.fn_GetUserScoreSummary()

GO
