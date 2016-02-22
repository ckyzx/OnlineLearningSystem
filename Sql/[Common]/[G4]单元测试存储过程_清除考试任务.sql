USE OLS;

GO

IF OBJECT_ID(N'dbo.UnitTesting_DeleteExaminationTask', N'P') IS NOT NULL 
    DROP PROCEDURE dbo.UnitTesting_DeleteExaminationTask

GO

CREATE PROCEDURE UnitTesting_DeleteExaminationTask @etName VARCHAR(50)
AS 
    BEGIN
    
        --DELETE  FROM dbo.ExaminationTaskTemplates;
        
        DELETE  FROM dbo.ExaminationPaperQuestions
        FROM    dbo.ExaminationTasks et
                LEFT JOIN dbo.ExaminationPapers ep ON et.ET_Id = ep.ET_Id
                LEFT JOIN dbo.ExaminationPaperQuestions epq ON ep.EP_Id = epq.EP_Id
        WHERE   et.ET_Name LIKE '%' + @etName + '%';
        
        DELETE  FROM dbo.ExaminationPapers
        FROM    dbo.ExaminationTasks et
                LEFT JOIN dbo.ExaminationPapers ep ON et.ET_Id = ep.ET_Id
        WHERE   et.ET_Name LIKE '%' + @etName + '%';
        
        DELETE  FROM dbo.ExaminationPaperTemplateQuestions
        FROM    dbo.ExaminationTasks et
                LEFT JOIN dbo.ExaminationPaperTemplates ept ON et.ET_Id = ept.ET_Id
                LEFT JOIN dbo.ExaminationPaperTemplateQuestions eptq ON ept.EPT_Id = eptq.EPT_Id
        WHERE   et.ET_Name LIKE '%' + @etName + '%';
        
        DELETE  FROM dbo.ExaminationPaperTemplates
        FROM    dbo.ExaminationTasks et
                LEFT JOIN dbo.ExaminationPaperTemplates ept ON et.ET_Id = ept.ET_Id
        WHERE   et.ET_Name LIKE '%' + @etName + '%';
        
        DELETE  FROM dbo.ExaminationTaskAttendees
        FROM    dbo.ExaminationTasks et
                LEFT JOIN dbo.ExaminationTaskAttendees eta ON et.ET_Id = eta.ET_Id
        WHERE   et.ET_Name LIKE '%' + @etName + '%';
        
        DELETE  FROM dbo.ExaminationTasks
        WHERE   ET_Name LIKE '%' + @etName + '%';
    END

GO