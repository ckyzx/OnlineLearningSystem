IF OBJECT_ID(N'fn_test_GetExaminationTaskPersonalStatistic', N'TF') IS NOT NULL 
    DROP FUNCTION fn_test_GetExaminationTaskPersonalStatistic;
GO

CREATE FUNCTION fn_test_GetExaminationTaskPersonalStatistic ( @uId INT )
RETURNS @table TABLE
    (
      ETPS_UserId INT ,
      ETPS_UserName VARCHAR(10) ,
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

        DECLARE @uName VARCHAR(10);
        DECLARE @examinationTotalNumber FLOAT ,
            @unexamineNumber FLOAT ,
            @examinedNumber FLOAT ,
            @exerciseTotalNumber FLOAT ,
            @unexerciseNumber FLOAT ,
            @exercisedNumber FLOAT;
	
        SELECT  @uName = U_Name
        FROM    Users
        WHERE   U_Id = @uId;
        
        SELECT  @examinationTotalNumber = COUNT(ETUS_UserId)
        FROM    ExaminationTaskUserStatistic
        WHERE   ETUS_UserId = @uId
                AND ETUS_TaskType = 0;
                
        SELECT  @unexamineNumber = COUNT(ETUS_UserId)
        FROM    ExaminationTaskUserStatistic
        WHERE   ETUS_UserId = @uId
                AND ETUS_TaskType = 0
                AND ETUS_PaperId IS NULL;
                
        SELECT  @examinedNumber = COUNT(ETUS_UserId)
        FROM    ExaminationTaskUserStatistic
        WHERE   ETUS_UserId = @uId
                AND ETUS_TaskType = 0
                AND ETUS_PaperId IS NOT NULL;
	
        SELECT  @exerciseTotalNumber = COUNT(ETUS_UserId)
        FROM    ExaminationTaskUserStatistic
        WHERE   ETUS_UserId = @uId
                AND ETUS_TaskType = 1;
                
        SELECT  @unexerciseNumber = COUNT(ETUS_UserId)
        FROM    ExaminationTaskUserStatistic
        WHERE   ETUS_UserId = @uId
                AND ETUS_TaskType = 1
                AND ETUS_PaperId IS NULL;
                
        SELECT  @exercisedNumber = COUNT(ETUS_UserId)
        FROM    ExaminationTaskUserStatistic
        WHERE   ETUS_UserId = @uId
                AND ETUS_TaskType = 1
                AND ETUS_PaperId IS NOT NULL;
	
        INSERT  INTO @table
                SELECT  @uId ,
                        @uName ,
                        @examinationTotalNumber ,
                        @unexamineNumber ,
                        @examinedNumber ,
                        ( CASE WHEN @examinationTotalNumber = 0 THEN 0
                               ELSE ROUND(@examinedNumber / @examinationTotalNumber, 2)
                          END ) ,
                        @exerciseTotalNumber ,
                        @unexerciseNumber ,
                        @exercisedNumber ,
                        ( CASE WHEN @exerciseTotalNumber = 0 THEN 0
                               ELSE ROUND(@exercisedNumber / @exerciseTotalNumber, 2)
                          END );
        RETURN;
    END