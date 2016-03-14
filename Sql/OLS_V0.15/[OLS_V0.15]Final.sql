-- [1]备份数据库
DECLARE @now VARCHAR(100)
DECLARE @fileName VARCHAR(100)
DECLARE @filePath VARCHAR(500)

SET @now = REPLACE(REPLACE(REPLACE(CONVERT(VARCHAR(100), GETDATE(), 20), '-', ''), ' ', ''), ':', '');
SET @fileName = 'OLS_' + @now + '.sqlserver2k8'
-- 下面填入保存数据库备份文件的路径
-- 例如: 填入 'D:\' + @fileName
SET @filePath = 'D:\' + @fileName;

BACKUP DATABASE OLS TO DISK = @filePath

GO

USE OLS;

GO

/***************************************************
** [OLS_V0.15]01批量更新资料数据“Content”改“Contents”.sql
****************************************************/

UPDATE  dbo.LearningDatas
SET     LD_Video = REPLACE(LD_Video, '/Content/', '/Contents/')
WHERE   LD_Video LIKE '%/Content/%';

GO

/***************************************************
** [OLS_V0.15]02修改【获取用户成绩详情函数 fn_GetUserScoreDetail】.sql
****************************************************/

IF OBJECT_ID(N'dbo.fn_GetUserInfo', 'TF') IS NOT NULL 
    DROP FUNCTION dbo.fn_GetUserInfo;

GO

CREATE FUNCTION dbo.fn_GetUserInfo ( )
RETURNS @table TABLE
    (
      U_Id INT NOT NULL ,
      U_Name NVARCHAR(50) NOT NULL ,
      U_Status TINYINT NOT NULL ,
      D_Id INT NULL ,
      D_Name NVARCHAR(50) NULL ,
      D_Status TINYINT NULL ,
      Du_Id INT NULL ,
      Du_Name NVARCHAR(50) NULL ,
      Du_Status TINYINT NULL
    )
AS 
    BEGIN
        INSERT  INTO @table
                SELECT  u.U_Id ,
                        u.U_Name ,
                        u.U_Status ,
                        d.D_Id ,
                        d.D_Name ,
                        d.D_Status ,
                        du.Du_Id ,
                        du.Du_Name ,
                        du.Du_Status
                FROM    dbo.Users u
                        LEFT JOIN dbo.User_Department ud ON u.U_Id = ud.U_Id
                        LEFT JOIN dbo.Departments d ON ud.D_Id = d.D_Id
                        LEFT JOIN dbo.Duties du ON u.Du_Id = du.Du_Id
        RETURN;
    END

GO

IF OBJECT_ID(N'dbo.sfn_UserScoreState', 'FN') IS NOT NULL 
    DROP FUNCTION dbo.sfn_UserScoreState;
GO

CREATE FUNCTION dbo.sfn_UserScoreState
    (
      @epScore INT ,
      @etStatisticType TINYINT ,
      @etTotalScore INT
    )
RETURNS INT
AS 
    BEGIN
		/* 0未设置 1未考试 2未打分 3合格 4未合格 */
        RETURN 
			CASE WHEN @epScore IS NOT NULL THEN 
					CASE WHEN @etStatisticType = 1 THEN 
							CASE WHEN @epScore = -1 THEN 2 
								 WHEN ( @epScore / CAST(@etTotalScore AS FLOAT) * 100 ) > 59 THEN 3
								 ELSE 4
							END
						 WHEN @etStatisticType = 2 THEN 
							CASE WHEN @epScore = -1 THEN 2
								 WHEN @epScore > 59 THEN 3
								 ELSE 4
							END
						 ELSE 0
				   END
				 ELSE 1
		   END
    END
GO

IF OBJECT_ID(N'dbo.fn_UserScoreState', 'FN') IS NOT NULL 
    DROP FUNCTION dbo.fn_UserScoreState;
GO

CREATE FUNCTION dbo.fn_UserScoreState
    (
      @eptId INT ,
      @epScore INT ,
      @etStatisticType TINYINT ,
      @etTotalScore INT
    )
RETURNS INT
AS 
    BEGIN
		/* 0未设置 1未考试 2未打分 3合格 4未合格 */
        RETURN 
			CASE WHEN @eptId IS NOT NULL THEN 
					dbo.sfn_UserScoreState(@epScore,@etStatisticType,@etTotalScore)
                 ELSE 0
            END
    END

GO

IF OBJECT_ID(N'dbo.sfn_GetUserScoreDetail', 'TF') IS NOT NULL 
    DROP FUNCTION dbo.sfn_GetUserScoreDetail;

GO

CREATE FUNCTION dbo.sfn_GetUserScoreDetail ( )
RETURNS @table TABLE
    (
      USD_UserId INT NOT NULL ,
      USD_UserName NVARCHAR(50) NOT NULL ,
      USD_DepartmentId INT NULL ,
      USD_DepartmentName NVARCHAR(50) NULL ,
      USD_TaskId INT NULL ,
      USD_TaskName NVARCHAR(50) NULL ,
      USD_TaskStatisticType TINYINT NULL ,
      USD_PaperTemplateId INT NULL ,
      USD_StartDate DATETIME2 NULL ,
      USD_StartTime DATETIME2 NULL ,
      USD_PaperId INT NULL ,
      USD_Score INT NULL ,
      USD_State TINYINT NOT NULL
    )
AS 
    BEGIN
        INSERT  INTO @table
                SELECT  u1.U_Id USD_UserId ,
                        u1.U_Name USD_UserName ,
                        u1.D_Id USD_DepartmentId ,
                        u1.D_Name USD_DepartmentName ,
                        et.ET_Id USD_TaskId ,
                        et.ET_Name USD_TaskName ,
                        et.ET_StatisticType USD_TaskStatisticType ,
                        ept.EPT_Id USD_PaperTemplateId ,
                        ept.EPT_StartDate USD_StartDate ,
                        ept.EPT_StartTime USD_StartTime ,
                        ISNULL(ep.EP_Id, 0) USD_PaperId ,
                        ISNULL(ep.EP_Score, -1) USD_Score ,
                        dbo.fn_UserScoreState(ept.EPT_Id, ep.EP_Score, et.ET_StatisticType, et.ET_TotalScore) AS ETUS_State
                FROM    fn_GetUserInfo() u1
                        LEFT JOIN dbo.ExaminationTaskAttendees eta ON eta.U_Id = u1.U_Id
                        LEFT JOIN ( SELECT  *
                                    FROM    dbo.ExaminationTasks
                                    WHERE   ET_Status = 1
                                  ) et ON et.ET_Id = eta.ET_Id
                        LEFT JOIN dbo.ExaminationPaperTemplates ept ON ept.ET_Id = et.ET_Id
                        LEFT JOIN dbo.ExaminationPapers ep ON ep.EPT_Id = ept.EPT_Id
                                                              AND ep.EP_UserId = u1.U_Id
                WHERE   ept.EPT_Id IS NOT NULL
        RETURN;
    END

GO

IF OBJECT_ID(N'dbo.fn_GetUserScoreDetail', 'TF') IS NOT NULL 
    DROP FUNCTION dbo.fn_GetUserScoreDetail;
GO

CREATE FUNCTION dbo.fn_GetUserScoreDetail ( )
RETURNS @table TABLE
    (
      USD_UserId INT NOT NULL ,
      USD_UserName NVARCHAR(50) NOT NULL ,
      USD_DepartmentId INT NULL ,
      USD_DepartmentName NVARCHAR(50) NULL ,
      USD_TaskId INT NULL ,
      USD_TaskName NVARCHAR(50) NULL ,
      USD_TaskStatisticType TINYINT NULL ,
      USD_PaperTemplateId INT NULL ,
      USD_StartDate DATETIME2 NULL ,
      USD_StartTime DATETIME2 NULL ,
      USD_PaperId INT NULL ,
      USD_Score INT NULL ,
      USD_State TINYINT NOT NULL
    )
AS 
    BEGIN
        INSERT  INTO @table
                SELECT  *
                FROM    ( SELECT    *
                          FROM      sfn_GetUserScoreDetail()
                          WHERE     USD_PaperId IS NOT NULL
                                    AND USD_TaskId IS NOT NULL
						  --添加未考试的记录
                          UNION ALL
                          SELECT    *
                          FROM      sfn_GetUserScoreDetail()
                          WHERE     USD_PaperId IS NULL
                                    AND USD_TaskId IS NOT NULL
                        ) tmp
                ORDER BY USD_PaperTemplateId ASC ,
                        USD_TaskId ASC ,
                        USD_PaperId ASC
        RETURN;
    END

GO

IF OBJECT_ID(N'dbo.UserScoreDetails', 'V') IS NOT NULL 
    DROP VIEW dbo.UserScoreDetails;
GO

CREATE VIEW dbo.UserScoreDetails
AS
    SELECT  *
    FROM    dbo.fn_GetUserScoreDetail()

GO

/***************************************************
** [OLS_V0.15]03修改【用户成绩详情导出视图 UserScoreDetailToExcel】.sql
****************************************************/

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

/***************************************************
** [OLS_V0.15]04修改【获取试卷详情函数 fn_GetPaperDetail】.sql
****************************************************/

IF OBJECT_ID(N'dbo.fn_GetPaperDetail', 'TF') IS NOT NULL 
    DROP FUNCTION dbo.fn_GetPaperDetail
GO

CREATE FUNCTION dbo.fn_GetPaperDetail ( )
RETURNS @table TABLE
    (
      PD_TaskId INT NOT NULL ,
      PD_PaperTemplateId INT NOT NULL ,
      PD_PaperId INT NOT NULL ,
      PD_UserId INT NOT NULL ,
      PD_QuestionType NVARCHAR(20) NOT NULL ,
      PD_QuestionTypeNumber TINYINT NOT NULL ,
      PD_QuestionContent TEXT NOT NULL ,
      PD_QuestionAnswer TEXT NULL ,
      PD_QuestionScore INT NOT NULL ,
      PD_QuestionExactness VARCHAR(10) NULL
    )
AS 
    BEGIN
		
        INSERT  INTO @table
                SELECT  et.ET_Id PD_TaskId ,
                        ept.EPT_Id PD_PaperTemplateId ,
                        ep.EP_Id PD_PaperId ,
                        u.U_Id PD_UserId ,
                        eptq.EPTQ_Type PD_QuestionType ,
                        CASE eptq.EPTQ_Type
                          WHEN '单选题' THEN 1
                          WHEN '多选题' THEN 2
                          WHEN '判断题' THEN 3
                          WHEN '公文改错题' THEN 4
                          WHEN '计算题' THEN 5
                          WHEN '案例分析题' THEN 6
                          WHEN '问答题' THEN 7
                        END PD_QuestionTypeNumber ,
                        eptq.EPTQ_Content PD_QuestionContent ,
                        ISNULL(epq.EPQ_Answer, '') PD_QuestionAnswer ,
                        eptq.EPTQ_Score PD_QuestionScore ,
                        CASE epq.EPQ_Exactness
                          WHEN 1 THEN '√'
                          WHEN 2 THEN '×'
                          ELSE CASE WHEN epq.EPQ_Answer IS NULL THEN '[未答题]'
                                    ELSE '[未批改]'
                               END
                        END PD_QuestionExactness
                FROM    dbo.ExaminationTasks et
                        JOIN dbo.ExaminationTaskAttendees eta ON et.ET_Id = eta.ET_Id
                        JOIN dbo.ExaminationPaperTemplates ept ON et.ET_Id = ept.ET_Id
                        JOIN dbo.ExaminationPapers ep ON et.ET_Id = ep.ET_Id
                        JOIN dbo.Users u ON eta.U_Id = u.U_Id
                        JOIN dbo.ExaminationPaperTemplateQuestions eptq ON eptq.EPT_Id = ept.EPT_Id
                        FULL OUTER JOIN dbo.ExaminationPaperQuestions epq ON epq.EPTQ_Id = eptq.EPTQ_Id
                WHERE   ep.EP_UserId = u.U_Id
                        AND ept.EPT_Id = ep.EPT_Id
                ORDER BY PD_QuestionTypeNumber ASC ,
                        eptq.EPTQ_Id ASC
        RETURN;
    END

GO

IF OBJECT_ID(N'dbo.PaperDetailToExcel', 'V') IS NOT NULL 
    DROP VIEW dbo.PaperDetailToExcel
GO

CREATE VIEW dbo.PaperDetailToExcel
AS
    SELECT  PD_TaskId ,
            PD_PaperId ,
            PD_UserId ,
            PD_QuestionType 类型 ,
            PD_QuestionTypeNumber ,
            PD_QuestionContent 题目 ,
            PD_QuestionAnswer 回答 ,
            PD_QuestionScore 分数 ,
            PD_QuestionExactness 状态
    FROM    dbo.fn_GetPaperDetail()

GO

/***************************************************
** [OLS_V0.15]05修改【考试统计导出视图 TaskStatisticToExcel】.sql
****************************************************/

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

GO

/***************************************************
** [OLS_V0.15]06修改【获取用户成绩概览函数 fn_GetUserScoreSummary】.sql
****************************************************/

IF OBJECT_ID(N'dbo.fn_GetUserScoreDoneNumber', 'FN') IS NOT NULL 
    DROP FUNCTION dbo.fn_GetUserScoreDoneNumber;
GO

CREATE FUNCTION fn_GetUserScoreDoneNumber
    (
      @etId INT ,
      @eptId INT ,
      @uId INT 
    )
RETURNS INT
AS 
    BEGIN
    
        DECLARE @doneNumber INT;
    
        SELECT  @doneNumber = COUNT(ep1.EP_Id)
        FROM    ( SELECT    *
                  FROM      dbo.ExaminationTasks
                  WHERE     ET_Status = 1
                ) et1
                LEFT JOIN dbo.ExaminationTaskAttendees eta1 ON et1.ET_Id = eta1.ET_Id
                LEFT JOIN dbo.Users u1 ON eta1.U_Id = u1.U_Id
                LEFT JOIN dbo.ExaminationPaperTemplates ept1 ON et1.ET_Id = ept1.ET_Id
                LEFT JOIN dbo.ExaminationPapers ep1 ON et1.ET_Id = ep1.ET_Id
        WHERE   ep1.EP_UserId = u1.U_Id
                AND ept1.EPT_Id = ep1.EPT_Id
                AND ep1.EP_Id IS NOT NULL
                AND et1.ET_Id = @etId
                AND ept1.EPT_Id = @eptId
                AND ep1.EP_UserId = @uId
                
        RETURN @doneNumber;
    END

GO

IF OBJECT_ID(N'dbo.fn_GetUserScorePassNumber', 'FN') IS NOT NULL 
    DROP FUNCTION dbo.fn_GetUserScorePassNumber;
GO

CREATE FUNCTION dbo.fn_GetUserScorePassNumber
    (
      @etId INT ,
      @eptId INT ,
      @uId INT 
    )
RETURNS INT
AS 
    BEGIN

        DECLARE @passNumber INT;

        SELECT  @passNumber = SUM(CASE et2.ET_StatisticType
                                    WHEN 1 THEN ( CASE WHEN ( ep2.EP_Score / CAST(et2.ET_TotalScore AS FLOAT) * 100 ) > 59 THEN 1
                                                       ELSE 0
                                                  END )
                                    WHEN 2 THEN ( CASE WHEN ep2.EP_Score > 59 THEN 1
                                                       ELSE 0
                                                  END )
                                    ELSE 0
                                  END)
        FROM    ( SELECT    *
                  FROM      dbo.ExaminationTasks
                  WHERE     ET_Status = 1
                ) et2
                LEFT JOIN dbo.ExaminationTaskAttendees eta2 ON et2.ET_Id = eta2.ET_Id
                LEFT JOIN dbo.Users u2 ON eta2.U_Id = u2.U_Id
                LEFT JOIN dbo.ExaminationPaperTemplates ept2 ON et2.ET_Id = ept2.ET_Id
                LEFT JOIN dbo.ExaminationPapers ep2 ON et2.ET_Id = ep2.ET_Id
        WHERE   ep2.EP_UserId = u2.U_Id
                AND ept2.EPT_Id = ep2.EPT_Id
                AND ep2.EP_Id IS NOT NULL
                AND et2.ET_Id = @etId
                AND ept2.EPT_Id = @eptId
                AND ep2.EP_UserId = @uId
                                                            
        RETURN @passNumber;
    END

GO

IF OBJECT_ID(N'dbo.sfn_GetUserScoreSummary', 'TF') IS NOT NULL 
    DROP FUNCTION dbo.sfn_GetUserScoreSummary;
GO

CREATE FUNCTION dbo.sfn_GetUserScoreSummary ( )
RETURNS @table TABLE
    (
      USS_UserId INT NOT NULL ,
      USS_UserName NVARCHAR(50) NOT NULL ,
      USS_DepartmentId INT NULL ,
      USS_DepartmentName NVARCHAR(50) NULL ,
      USS_DutyName NVARCHAR(50) NULL ,
      USS_TaskId INT NULL ,
      USS_TaskName NVARCHAR(50) NULL ,
      USS_PaperTemplateId INT NULL ,
      USS_StartTime DATETIME2 NULL ,
      USS_DoneNumber INT NULL ,
      USS_PassNumber INT NULL
    )
AS 
    BEGIN
        INSERT  INTO @table
                SELECT  u.U_Id USS_UserId ,
                        u.U_Name USS_UserName ,
                        d.D_Id USS_DepartmentId ,
                        d.D_Name USS_DepartmentName ,
                        du.Du_Name USS_DutyName ,
                        et.ET_Id USS_TaskId ,
                        et.ET_Name USS_TaskName ,
                        ept.EPT_Id USS_PaperTemplateId ,
                        ept.EPT_StartDate USS_StartTime ,
                        dbo.fn_GetUserScoreDoneNumber(et.ET_Id, ept.EPT_Id, u.U_Id) USS_DoneNumber ,
                        dbo.fn_GetUserScorePassNumber(et.ET_Id, ept.EPT_Id, u.U_Id) USS_PassNumber
                FROM    dbo.Users u
                        LEFT JOIN dbo.User_Department ud ON u.U_Id = ud.U_Id
                        LEFT JOIN dbo.Departments d ON ud.D_Id = d.D_Id
                        LEFT JOIN dbo.Duties du ON u.Du_Id = du.Du_Id
                        LEFT JOIN dbo.ExaminationTaskAttendees eta ON u.U_Id = eta.U_Id
                        LEFT JOIN ( SELECT  *
                                    FROM    dbo.ExaminationTasks
                                    WHERE   ET_Status = 1
                                  ) et ON eta.ET_Id = et.ET_Id
                        LEFT JOIN dbo.ExaminationPaperTemplates ept ON et.ET_Id = ept.ET_Id
                WHERE   u.U_Status = 1
                        AND d.D_Status = 1
                        AND ( du.Du_Status = 1
                              OR du.Du_Status IS NULL
                            )
                        AND ept.EPT_Status IS NOT NULL
        RETURN;
    END

GO

IF OBJECT_ID(N'dbo.fn_GetUserScoreSummary', 'TF') IS NOT NULL 
    DROP FUNCTION dbo.fn_GetUserScoreSummary;
GO

CREATE FUNCTION dbo.fn_GetUserScoreSummary ( )
RETURNS @table TABLE
    (
      USS_UserId INT NOT NULL ,
      USS_UserName NVARCHAR(50) NOT NULL ,
      USS_DepartmentId INT NOT NULL ,
      USS_DepartmentName NVARCHAR(50) NOT NULL ,
      USS_DutyName NVARCHAR(50) NULL ,
      USS_TotalNumber INT NOT NULL ,
      USS_DoneNumber INT NOT NULL ,
      USS_UndoNumber INT NOT NULL ,
      USS_PassNumber INT NOT NULL ,
      USS_DoneRatio DECIMAL NOT NULL ,
      USS_PassRatio DECIMAL NOT NULL
    )
AS 
    BEGIN
		
        INSERT  INTO @table
                SELECT  USS_UserId ,
                        USS_UserName ,
                        USS_DepartmentId ,
                        USS_DepartmentName ,
                        ISNULL(USS_DutyName, '') ,
                        USS_TotalNumber ,
                        USS_DoneNumber ,
                        ( USS_TotalNumber - USS_DoneNumber ) USS_UndoNumber ,
                        USS_PassNumber ,
                        ( CASE USS_TotalNumber
                            WHEN 0 THEN 0
                            ELSE ROUND(( USS_DoneNumber / CAST(USS_TotalNumber AS FLOAT) ), 2) * 100
                          END ) USS_DoneRatio ,
                        ( CASE USS_TotalNumber
                            WHEN 0 THEN 0
                            ELSE ROUND(( USS_PassNumber / CAST(USS_TotalNumber AS FLOAT) ), 2) * 100
                          END ) USS_PassRatio
                FROM    ( SELECT    USS_UserId ,
                                    USS_UserName ,
                                    USS_DepartmentId ,
                                    USS_DepartmentName ,
                                    USS_DutyName ,
                                    COUNT(USS_TaskName) USS_TotalNumber ,
                                    SUM(USS_DoneNumber) USS_DoneNumber ,
                                    SUM(ISNULL(USS_PassNumber, 0)) USS_PassNumber
                          FROM      dbo.sfn_GetUserScoreSummary( )
                          GROUP BY  USS_UserId ,
                                    USS_UserName ,
                                    USS_DepartmentId ,
                                    USS_DepartmentName ,
                                    USS_DutyName
                        ) TmpTable1
		
        RETURN;
    END

GO

IF OBJECT_ID(N'dbo.UserScoreSummaries', 'V') IS NOT NULL 
    DROP VIEW dbo.UserScoreSummaries;
GO

CREATE VIEW dbo.UserScoreSummaries
AS
    SELECT  *
    FROM    dbo.fn_GetUserScoreSummary()

GO
