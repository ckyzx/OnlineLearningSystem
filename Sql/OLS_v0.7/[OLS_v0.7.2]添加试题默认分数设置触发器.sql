USE OLS;

GO

/*ALTER TABLE dbo.Questions
ADD CONSTRAINT DF_SCORE_QUESTIONS DEFAULT(5) FOR Q_Score

GO*/

IF ( OBJECT_ID('tgr_SetQuestionDefaultScoreWhenInsert', 'TR') IS NOT NULL ) 
    DROP TRIGGER tgr_SetQuestionDefaultScoreWhenInsert
GO
CREATE TRIGGER tgr_SetQuestionDefaultScoreWhenInsert ON dbo.Questions
    FOR INSERT
AS
    DECLARE @id INT ,
        @score INT;
	
    SELECT  @id = Q_Id ,
            @score = CASE WHEN Q_Score = 0 THEN CASE WHEN Q_Type = '单选题' THEN 5
                                                     WHEN Q_Type = '多选题' THEN 8
                                                     WHEN Q_Type = '判断题' THEN 5
                                                     WHEN Q_Type = '公文改错题' THEN 10
                                                     WHEN Q_Type = '计算题' THEN 20
                                                     WHEN Q_Type = '案例分析题' THEN 25
                                                     WHEN Q_Type = '问答题' THEN 15
                                                END
                          ELSE Q_Score
                     END
    FROM    INSERTED;
	
    UPDATE  Questions
    SET     Q_Score = @score
    WHERE   Q_Id = @id;
GO

