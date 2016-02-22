USE OLS;

GO

if object_id(N'SystemLogs',N'U') is not NULL
	DROP TABLE SystemLogs

GO

CREATE TABLE SystemLogs
    (
      SL_Id INT identity ,
      SL_Name VARCHAR(500) NOT NULL ,
      SL_Type TINYINT NOT NULL ,
      SL_Content TEXT NOT NULL ,
      SL_Remark VARCHAR(500) NULL ,
      SL_Status TINYINT NOT NULL ,
      SL_AddTime DATETIME2 NOT NULL ,
      CONSTRAINT PK_SYSTEMLOGS PRIMARY KEY ( SL_Id )
    )

GO

IF ( OBJECT_ID('tgr_SetQuestionDefaultScoreWhenInsert', 'TR') IS NOT NULL ) 
    DROP TRIGGER tgr_SetQuestionDefaultScoreWhenInsert
GO
CREATE TRIGGER tgr_SetQuestionDefaultScoreWhenInsert ON dbo.Questions
    FOR INSERT
AS
    DECLARE @id INT ,
        @score INT;
	
    SELECT  @id = Q_Id ,
            @score = CASE WHEN Q_Score = 0 THEN CASE WHEN Q_Type = '��ѡ��' THEN 5
                                                     WHEN Q_Type = '��ѡ��' THEN 8
                                                     WHEN Q_Type = '�ж���' THEN 5
                                                     WHEN Q_Type = '���ĸĴ���' THEN 10
                                                     WHEN Q_Type = '������' THEN 20
                                                     WHEN Q_Type = '����������' THEN 25
                                                     WHEN Q_Type = '�ʴ���' THEN 15
                                                END
                          ELSE Q_Score
                     END
    FROM    INSERTED;
	
    UPDATE  Questions
    SET     Q_Score = @score
    WHERE   Q_Id = @id;
GO
