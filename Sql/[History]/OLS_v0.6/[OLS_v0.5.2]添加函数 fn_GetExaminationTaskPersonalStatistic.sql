USE OLS;

GO

IF OBJECT_ID(N'fn_GetExaminationTaskPersonalStatistic', N'TF') IS NOT NULL 
    DROP FUNCTION fn_GetExaminationTaskPersonalStatistic;
GO

CREATE FUNCTION fn_GetExaminationTaskPersonalStatistic ( )
RETURNS @table TABLE
    (
      ETPS_UserId INT ,
      ETPS_UserName VARCHAR(10) ,
      ETPS_DepartmentId INT,
      ETPS_DepartmentName VARCHAR(50),
      ETPS_DutyId INT,
      ETPS_DutyName VARCHAR(50),
      ETPS_ExaminationTotalNumber FLOAT ,
      ETPS_UnexamineNumber FLOAT ,
      ETPS_ExaminedNumber FLOAT ,
      ETPS_ExaminationPassRatio FLOAT ,
      ETPS_ExerciseTotalNumber FLOAT ,
      ETPS_UnexerciseNumber FLOAT ,
      ETPS_ExercisedNumber FLOAT ,
      ETPS_ExercisePassRatio FLOAT
    )
AS 
    BEGIN
	
        INSERT  INTO @table
                SELECT  ETPS_UserId ,
                        ETPS_UserName ,
                        ETPS_DepartmentId,
                        ETPS_DepartmentName,
                        ETPS_DutyId,
                        ETPS_DutyName,
                        ETPS_ExaminationTotalNumber ,
                        ETPS_UnexamineNumber ,
                        ETPS_ExaminedNumber ,
                        ( CASE WHEN ETPS_ExaminationTotalNumber = 0 THEN 0
                               ELSE ROUND(( ETPS_ExaminedNumber + 0.0 ) / ETPS_ExaminationTotalNumber, 2)
                          END ) AS ETPS_ExaminationPassRatio ,
                        ETPS_ExerciseTotalNumber ,
                        ETPS_UnexerciseNumber ,
                        ETPS_ExercisedNumber ,
                        ( CASE WHEN ETPS_ExerciseTotalNumber = 0 THEN 0
                               ELSE ROUND(( ETPS_ExercisedNumber + 0.0 ) / ETPS_ExerciseTotalNumber, 2)
                          END ) AS ETPS_ExercisePassRatio
                FROM    ( SELECT    u.U_Id AS ETPS_UserId ,
                                    u.U_Name AS ETPS_UserName ,
                                    d.D_Id AS ETPS_DepartmentId,
                                    d.D_Name AS ETPS_DepartmentName,
                                    du.Du_Id AS ETPS_DutyId,
                                    du.Du_Name AS ETPS_DutyName,
                                    ( SELECT    COUNT(ETUS_UserId)
                                      FROM      ExaminationTaskUserStatistic
                                      WHERE     ETUS_UserId = u.U_Id
                                                AND ETUS_TaskType = 0
                                    ) AS ETPS_ExaminationTotalNumber ,
                                    ( SELECT    COUNT(ETUS_UserId)
                                      FROM      ExaminationTaskUserStatistic
                                      WHERE     ETUS_UserId = u.U_Id
                                                AND ETUS_TaskType = 0
                                                AND ETUS_PaperId IS NULL
                                    ) AS ETPS_UnexamineNumber ,
                                    ( SELECT    COUNT(ETUS_UserId)
                                      FROM      ExaminationTaskUserStatistic
                                      WHERE     ETUS_UserId = u.U_Id
                                                AND ETUS_TaskType = 0
                                                AND ETUS_PaperId IS NOT NULL
                                    ) AS ETPS_ExaminedNumber ,
                                    ( SELECT    COUNT(ETUS_UserId)
                                      FROM      ExaminationTaskUserStatistic
                                      WHERE     ETUS_UserId = u.U_Id
                                                AND ETUS_TaskType = 1
                                    ) AS ETPS_ExerciseTotalNumber ,
                                    ( SELECT    COUNT(ETUS_UserId)
                                      FROM      ExaminationTaskUserStatistic
                                      WHERE     ETUS_UserId = u.U_Id
                                                AND ETUS_TaskType = 1
                                                AND ETUS_PaperId IS NULL
                                    ) AS ETPS_UnexerciseNumber ,
                                    ( SELECT    COUNT(ETUS_UserId)
                                      FROM      ExaminationTaskUserStatistic
                                      WHERE     ETUS_UserId = u.U_Id
                                                AND ETUS_TaskType = 1
                                                AND ETUS_PaperId IS NOT NULL
                                    ) AS ETPS_ExercisedNumber
                          FROM      Users u LEFT JOIN Duties du ON u.Du_Id = du.Du_Id
									LEFT JOIN dbo.User_Department ud ON u.U_Id = ud.U_Id
									LEFT JOIN dbo.Departments d ON ud.D_Id = d.D_Id
                          WHERE     U_Status = 1
                        ) tmp;
	
        RETURN;
    END

GO
