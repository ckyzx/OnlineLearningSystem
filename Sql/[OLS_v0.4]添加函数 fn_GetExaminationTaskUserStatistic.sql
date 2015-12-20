USE OLS;

GO

IF OBJECT_ID(N'fn_GetExaminationTaskUserStatistic', N'TF') IS NOT NULL 
    DROP FUNCTION fn_GetExaminationTaskUserStatistic;
GO

CREATE FUNCTION fn_GetExaminationTaskUserStatistic ( )
RETURNS @table TABLE
    (
      ETUS_TaskId INT ,
      ETUS_TaskName VARCHAR(50) ,
      ETUS_TaskAutoType TINYINT ,
      ETUS_TaskStatisticType TINYINT ,
      ETUS_PaperTemplateId INT ,
      ETUS_PaperTemplateDate DATETIME2 ,
      ETUS_DepartmentId INT ,
      ETUS_DepartmentName VARCHAR(50) ,
      ETUS_UserId INT ,
      ETUS_UserName VARCHAR(10) ,
      ETUS_DutyId INT ,
      ETUS_DutyName VARCHAR(50) ,
      ETUS_PaperId INT,
      ETUS_PaperAddTime DATETIME2,
      ETUS_Score INT ,
      ETUS_State TINYINT
    )
AS 
    BEGIN
    
        INSERT  INTO @table
                SELECT  et_ept.ET_Id AS ETUS_TaskId ,
                        et_ept.ET_Name AS ETUS_TaskName ,
                        et_ept.ET_AutoType AS ETUS_TaskAutoType ,
                        et_ept.ET_StatisticType AS ETUS_TaskStatisticType ,
                        et_ept.EPT_Id AS ETUS_PaperTemplateId ,
                        et_ept.EPT_StartDate AS ETUS_Date ,
                        d.D_Id AS ETUS_DepartmentId ,
                        d.D_Name AS ETUS_DepartmentName ,
                        u_du.U_Id AS ETUS_UserId ,
                        u_du.U_Name AS ETUS_UserName ,
                        u_du.Du_Id AS ETUS_DutyId ,
                        u_du.Du_Name AS ETUS_DutyName ,
                        ep.EP_Id AS ETUS_PaperId,
                        ep.EP_AddTime AS ETUS_PaperAddTime,
                        ep.EP_Score AS ETUS_Score ,
                        ( CASE WHEN ep.EP_Score IS NULL THEN 1
                               ELSE CASE WHEN et_ept.ET_StatisticType = 1 THEN CASE WHEN ep.EP_Score >= et_ept.ET_TotalScore * 0.6 THEN 2
                                                                                    ELSE 3
                                                                               END
                                         WHEN et_ept.ET_StatisticType = 2 THEN CASE WHEN ep.EP_Score >= 60 THEN 2
                                                                                    ELSE 3
                                                                               END
                                         ELSE 0
                                    END
                          END ) AS ETUS_State /* 0未设置 1未考试 2合格 3未合格 */
                FROM    ( SELECT    *
                          FROM      ExaminationTasks et
                                    LEFT JOIN ( SELECT  EPT_Id ,
                                                        ET_Id AS ET_Id1 ,
                                                        EPT_StartDate
                                                FROM    ExaminationPaperTemplates
                                              ) ept ON et.ET_Id = ept.ET_Id1
                        ) et_ept
                        LEFT JOIN ExaminationTaskAttendees eta ON et_ept.ET_Id = eta.ET_Id
                        LEFT JOIN ( SELECT  *
                                    FROM    ( SELECT    U_Id ,
                                                        U_Name ,
                                                        Du_Id AS Du_Id1
                                              FROM      Users
                                            ) u
                                            LEFT JOIN Duties du ON u.Du_Id1 = du.Du_Id
                                  ) u_du ON eta.U_Id = u_du.U_Id
                        LEFT JOIN ExaminationPapers ep ON et_ept.EPT_Id = ep.EPT_Id
                                                          AND u_du.U_Id = ep.EP_UserId ,
                        User_Department ud ,
                        Departments d
                WHERE   et_ept.ET_Status = 1
                        AND u_du.U_Id IS NOT NULL
                        AND u_du.U_Id = ud.U_Id
                        AND ud.D_Id = d.D_Id
                
        RETURN;
    END