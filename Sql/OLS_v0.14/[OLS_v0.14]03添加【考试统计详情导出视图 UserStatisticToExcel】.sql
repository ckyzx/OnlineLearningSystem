USE OLS;

GO

IF OBJECT_ID(N'dbo.UserStatisticToExcel') IS NOT NULL 
    DROP VIEW dbo.UserStatisticToExcel;

GO

CREATE VIEW dbo.UserStatisticToExcel
AS
    SELECT  ETUS_PaperTemplateId ,
            ETUS_DepartmentName 部门 ,
            ETUS_UserName 用户 ,
            ETUS_DutyName 职务 ,
            CASE ETUS_Score
              WHEN -1 THEN ''
              ELSE CAST(ETUS_Score AS VARCHAR(5))
            END 成绩 ,
            CASE ETUS_State
              WHEN 0 THEN '[未设置]'
              WHEN 1 THEN '未考试'
              WHEN 2 THEN '合格'
              WHEN 3 THEN '未合格'
              WHEN 4 THEN '未打分'
            END 状态
    FROM    dbo.fn_GetExaminationTaskUserStatistic()

GO
