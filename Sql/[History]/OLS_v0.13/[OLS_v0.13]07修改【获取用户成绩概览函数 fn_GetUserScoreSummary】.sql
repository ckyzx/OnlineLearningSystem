USE OLS;

GO

IF OBJECT_ID(N'dbo.fn_GetUserScoreSummary', 'TF') IS NOT NULL 
    DROP FUNCTION dbo.fn_GetUserScoreSummary;
GO

CREATE FUNCTION dbo.fn_GetUserScoreSummary ( )
RETURNS @table TABLE
    (
      USS_UserId INT NOT NULL ,
      USS_UserName NVARCHAR(50) NOT NULL ,
      USS_DepartmentId INT NOT NULL,
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
                        USS_DepartmentId,
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
                                    USS_DepartmentId,
                                    USS_DepartmentName ,
                                    USS_DutyName ,
                                    COUNT(USS_TaskName) USS_TotalNumber ,
                                    SUM(USS_DoneNumber) USS_DoneNumber ,
                                    SUM(ISNULL(USS_PassNumber, 0)) USS_PassNumber
                          FROM      ( SELECT    u.U_Id USS_UserId ,
                                                u.U_Name USS_UserName ,
                                                d.D_Id USS_DepartmentId,
                                                d.D_Name USS_DepartmentName ,
                                                du.Du_Name USS_DutyName ,
                                                et.ET_Id USS_TaskId ,
                                                et.ET_Name USS_TaskName ,
                                                ept.EPT_Id USS_PaperTemplateId ,
                                                ept.EPT_StartDate USS_StartTime ,
                                                ( SELECT    COUNT(ep1.EP_Id)
                                                  FROM      dbo.ExaminationTasks et1
                                                            LEFT JOIN dbo.ExaminationTaskAttendees eta1 ON et1.ET_Id = eta1.ET_Id
                                                            LEFT JOIN dbo.Users u1 ON eta1.U_Id = u1.U_Id
                                                            LEFT JOIN dbo.ExaminationPaperTemplates ept1 ON et1.ET_Id = ept1.ET_Id
                                                            LEFT JOIN dbo.ExaminationPapers ep1 ON et1.ET_Id = ep1.ET_Id
                                                  WHERE     et1.ET_Id = et.ET_Id
                                                            AND ept1.EPT_Id = ept.EPT_Id
                                                            AND ep1.EP_UserId = u.U_Id
                                                            AND ep1.EP_UserId = u1.U_Id
                                                            AND ept1.EPT_Id = ep1.EPT_Id
                                                            AND ep1.EP_Id IS NOT NULL
                                                ) USS_DoneNumber ,
                                                ( SELECT    SUM(CASE et2.ET_StatisticType
                                                                  WHEN 1 THEN ( CASE WHEN ( ep2.EP_Score / CAST(et2.ET_TotalScore AS FLOAT) * 100 ) > 59 THEN 1
                                                                                     ELSE 0
                                                                                END )
                                                                  WHEN 2 THEN ( CASE WHEN ep2.EP_Score > 59 THEN 1
                                                                                     ELSE 0
                                                                                END )
                                                                  ELSE 0
                                                                END)
                                                  FROM      dbo.ExaminationTasks et2
                                                            LEFT JOIN dbo.ExaminationTaskAttendees eta2 ON et2.ET_Id = eta2.ET_Id
                                                            LEFT JOIN dbo.Users u2 ON eta2.U_Id = u2.U_Id
                                                            LEFT JOIN dbo.ExaminationPaperTemplates ept2 ON et2.ET_Id = ept2.ET_Id
                                                            LEFT JOIN dbo.ExaminationPapers ep2 ON et2.ET_Id = ep2.ET_Id
                                                  WHERE     et2.ET_Id = et.ET_Id
                                                            AND ept2.EPT_Id = ept.EPT_Id
                                                            AND ep2.EP_UserId = u.U_Id
                                                            AND ep2.EP_UserId = u2.U_Id
                                                            AND ept2.EPT_Id = ep2.EPT_Id
                                                            AND ep2.EP_Id IS NOT NULL
                                                ) USS_PassNumber
                                      FROM      dbo.Users u
                                                LEFT JOIN dbo.User_Department ud ON u.U_Id = ud.U_Id
                                                LEFT JOIN dbo.Departments d ON ud.D_Id = d.D_Id
                                                LEFT JOIN dbo.Duties du ON u.Du_Id = du.Du_Id
                                                LEFT JOIN dbo.ExaminationTaskAttendees eta ON u.U_Id = eta.U_Id
                                                LEFT JOIN dbo.ExaminationTasks et ON eta.ET_Id = et.ET_Id
                                                LEFT JOIN dbo.ExaminationPaperTemplates ept ON et.ET_Id = ept.ET_Id
                                      WHERE     ( et.ET_Status = 1
                                                  OR et.ET_Status IS NULL
                                                )
                                                AND u.U_Status = 1
                                                AND d.D_Status = 1
                                                AND ( du.Du_Status = 1
                                                      OR du.Du_Status IS NULL
                                                    )
                                    ) TmpTable
                          GROUP BY  USS_UserId ,
                                    USS_UserName ,
                                    USS_DepartmentId,
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
SELECT * FROM dbo.fn_GetUserScoreSummary()

GO
