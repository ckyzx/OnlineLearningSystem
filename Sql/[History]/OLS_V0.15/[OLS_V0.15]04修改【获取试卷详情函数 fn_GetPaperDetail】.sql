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
                          WHEN '��ѡ��' THEN 1
                          WHEN '��ѡ��' THEN 2
                          WHEN '�ж���' THEN 3
                          WHEN '���ĸĴ���' THEN 4
                          WHEN '������' THEN 5
                          WHEN '����������' THEN 6
                          WHEN '�ʴ���' THEN 7
                        END PD_QuestionTypeNumber ,
                        eptq.EPTQ_Content PD_QuestionContent ,
                        ISNULL(epq.EPQ_Answer, '') PD_QuestionAnswer ,
                        eptq.EPTQ_Score PD_QuestionScore ,
                        CASE epq.EPQ_Exactness
                          WHEN 1 THEN '��'
                          WHEN 2 THEN '��'
                          ELSE CASE WHEN epq.EPQ_Answer IS NULL THEN '[δ����]'
                                    ELSE '[δ����]'
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
            PD_QuestionType ���� ,
            PD_QuestionTypeNumber ,
            PD_QuestionContent ��Ŀ ,
            PD_QuestionAnswer �ش� ,
            PD_QuestionScore ���� ,
            PD_QuestionExactness ״̬
    FROM    dbo.fn_GetPaperDetail()

GO
