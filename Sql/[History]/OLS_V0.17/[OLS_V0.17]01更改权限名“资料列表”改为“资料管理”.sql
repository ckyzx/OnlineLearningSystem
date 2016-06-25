USE OLS;

GO

UPDATE  dbo.[Permissions]
SET     P_Name = '资料管理'
WHERE   P_Controller = 'LearningData'
        AND P_Action = 'List'

GO
