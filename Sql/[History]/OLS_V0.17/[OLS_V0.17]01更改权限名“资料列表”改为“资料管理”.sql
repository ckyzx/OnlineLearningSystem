USE OLS;

GO

UPDATE  dbo.[Permissions]
SET     P_Name = '���Ϲ���'
WHERE   P_Controller = 'LearningData'
        AND P_Action = 'List'

GO
