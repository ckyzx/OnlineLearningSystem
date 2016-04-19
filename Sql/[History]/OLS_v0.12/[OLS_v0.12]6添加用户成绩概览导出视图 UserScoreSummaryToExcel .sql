USE OLS;

GO

IF OBJECT_ID(N'dbo.UserScoreSummaryToExcel') IS NOT NULL 
    DROP VIEW dbo.UserScoreSummaryToExcel

GO

CREATE VIEW dbo.UserScoreSummaryToExcel
AS
    SELECT  USS_UserId ,
            USS_UserName 用户 ,
            USS_DepartmentName 部门 ,
            USS_DutyName 职务 ,
            USS_TotalNumber 应考 ,
            USS_DoneNumber 已考 ,
            USS_UndoNumber 未考 ,
            USS_PassNumber 合格 ,
            CAST(USS_DoneRatio AS varchar(5)) + '%' 参考率 ,
            CAST(USS_PassRatio AS VARCHAR(5)) + '%' 合格率
    FROM    dbo.fn_GetUserScoreSummary()

GO
