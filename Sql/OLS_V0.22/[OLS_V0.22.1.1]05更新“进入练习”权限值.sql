USE OLS;

GO

UPDATE  dbo.[Permissions]
SET     P_Controller = 'ExaminationPaperTemplate'
WHERE   P_Controller = 'ExaminationTask'
        AND P_Action = 'EnterExercise'

GO

EXEC dbo.UpdateAdminRole;

GO

EXEC dbo.UpdateStudentRole;

GO
