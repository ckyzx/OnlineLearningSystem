USE OLS;

GO

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
                                            AND ET_Type = 0 /* 只统计"考试"类型 */
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
