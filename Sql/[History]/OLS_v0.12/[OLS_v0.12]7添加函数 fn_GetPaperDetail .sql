USE OLS;

GO

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
      PD_QuestionContent TEXT NOT NULL ,
      PD_QuestionAnswer TEXT NULL ,
      PD_QuestionScore INT NOT NULL ,
      PD_QuestionExactness VARCHAR(5) NULL
    )
AS 
    BEGIN
		
        INSERT  INTO @table
                SELECT  et.ET_Id PD_TaskId ,
                        ept.EPT_Id PD_PaperTemplateId ,
                        ep.EP_Id PD_PaperId ,
                        u.U_Id PD_UserId ,
                        eptq.EPTQ_Type PD_QuestionType ,
                        eptq.EPTQ_Content PD_QuestionContent ,
                        ISNULL(epq.EPQ_Answer, '') PD_QuestionAnswer ,
                        eptq.EPTQ_Score PD_QuestionScore ,
                        CASE epq.EPQ_Exactness WHEN 1 THEN '¡Ì' WHEN 2 THEN '¡Á' ELSE '' END PD_QuestionExactness
                FROM    dbo.ExaminationTasks et
                        JOIN dbo.ExaminationTaskAttendees eta ON et.ET_Id = eta.ET_Id
                        JOIN dbo.ExaminationPaperTemplates ept ON et.ET_Id = ept.ET_Id
                        JOIN dbo.ExaminationPapers ep ON et.ET_Id = ep.ET_Id
                        JOIN dbo.Users u ON eta.U_Id = u.U_Id
                        JOIN dbo.ExaminationPaperTemplateQuestions eptq ON eptq.EPT_Id = ept.EPT_Id
                        FULL OUTER JOIN dbo.ExaminationPaperQuestions epq ON epq.EPTQ_Id = eptq.EPTQ_Id
                WHERE   ep.EP_UserId = u.U_Id
        RETURN;
    END

GO
