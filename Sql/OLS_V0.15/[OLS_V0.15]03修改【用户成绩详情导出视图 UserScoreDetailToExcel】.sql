USE OLS;

GO

IF OBJECT_ID(N'dbo.UserScoreDetailToExcel', 'V') IS NOT NULL 
    DROP VIEW dbo.UserScoreDetailToExcel;
GO

CREATE VIEW dbo.UserScoreDetailToExcel
AS
    SELECT  USD_UserId,
			USD_UserName,
			USD_DepartmentId,
			USD_DepartmentName,
			USD_TaskName,
			USD_StartTime,
			USD_PaperId,
			CASE WHEN USD_PaperId = 0 THEN '' ELSE CAST(USD_PaperId AS NVARCHAR(20)) END 试卷编号,
			USD_TaskName 考试任务 ,
            CONVERT(VARCHAR(20), USD_StartTime, 20) 考试时间 ,
            CASE USD_TaskStatisticType
              WHEN 1 THEN '得分'
              WHEN 2 THEN '正确率'
              ELSE '[未设置]'
            END 成绩类型 ,
            CASE USD_Score
              WHEN -1 THEN ''
              ELSE CASE USD_TaskStatisticType
                     WHEN 1 THEN CAST(USD_Score AS VARCHAR(10)) + '分'
                     WHEN 2 THEN CAST(USD_Score AS VARCHAR(10)) + '%'
                     ELSE ''
                   END
            END 成绩 ,
            CASE USD_State
              WHEN 1 THEN '未考试'
              WHEN 2 THEN '未打分'
              WHEN 3 THEN '合格'
              WHEN 4 THEN '未合格'
              ELSE '未考试'--'[未设置]'
            END 状态
    FROM    dbo.fn_GetUserScoreDetail()

GO
