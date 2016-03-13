USE OLS;

GO

IF OBJECT_ID(N'dbo.TaskStatisticToExcel') IS NOT NULL 
    DROP VIEW dbo.TaskStatisticToExcel;

GO

CREATE VIEW dbo.TaskStatisticToExcel
AS
    SELECT  ETS_TaskName ,
            ETS_PaperTemplateId ,
            ETS_PaperTemplateId 考试编号 ,
            ETS_TaskName 考试任务 ,
            ETS_PaperTemplateDate ,
            DATENAME(year, ETS_PaperTemplateDate) + '-' + DATENAME(month, ETS_PaperTemplateDate) + '-' + DATENAME(day, ETS_PaperTemplateDate) 考试日期 ,
            ETS_AttendeeNumber 应考 ,
            ETS_PaperNumber 已考 ,
            ETS_PassNumber 合格 ,
            ETS_FlunkNumber 未合格
    FROM    dbo.fn_GetExaminationTaskStatistic()