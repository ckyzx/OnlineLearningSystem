USE OLS;

GO

DECLARE @id INT;

SELECT  @id = MAX(Q_AutoId) + 1
FROM    dbo.Questions;

INSERT  dbo.Questions
        SELECT  @id , -- Q_Id - int
                '��ѡ��' , -- Q_Type - varchar(20)
                1 , -- QC_Id - int
                0 , -- Q_DifficultyCoefficient - tinyint
                '��������' + CAST(@id AS VARCHAR(10)) + '��' , -- Q_Content - text
                '{"A":"9��","B":"10��","C":"12��","D":"13��"}' , -- Q_OptionalAnswer - text
                '["D"]' , -- Q_ModelAnswer - text
                '' , -- Q_Remark - varchar(200)
                GETDATE() , -- Q_AddTime - datetime2
                1 , -- Q_Status - tinyint
                0 -- Q_Score - int

SET @id = @id + 1;
INSERT  dbo.Questions
        SELECT  @id , -- Q_Id - int
                '��ѡ��' , -- Q_Type - varchar(20)
                1 , -- QC_Id - int
                0 , -- Q_DifficultyCoefficient - tinyint
                '��������' + CAST(@id AS VARCHAR(10)) + '��' , -- Q_Content - text
                '{"A":"9��","B":"10��","C":"12��","D":"13��"}' , -- Q_OptionalAnswer - text
                '["D"]' , -- Q_ModelAnswer - text
                '' , -- Q_Remark - varchar(200)
                GETDATE() , -- Q_AddTime - datetime2
                1 , -- Q_Status - tinyint
                0  -- Q_Score - int
    
SET @id = @id + 1;      
INSERT  dbo.Questions
        SELECT  @id , -- Q_Id - int
                '�ж���' , -- Q_Type - varchar(20)
                1 , -- QC_Id - int
                0 , -- Q_DifficultyCoefficient - tinyint
                '��������' + CAST(@id AS VARCHAR(10)) + '��' , -- Q_Content - text
                '' , -- Q_OptionalAnswer - text
                '��' , -- Q_ModelAnswer - text
                '' , -- Q_Remark - varchar(200)
                GETDATE() , -- Q_AddTime - datetime2
                1 , -- Q_Status - tinyint
                0 -- Q_Score - int

SET @id = @id + 1;      
INSERT  dbo.Questions
        SELECT  @id , -- Q_Id - int
                '���ĸĴ���' , -- Q_Type - varchar(20)
                1 , -- QC_Id - int
                0 , -- Q_DifficultyCoefficient - tinyint
                '��������' + CAST(@id AS VARCHAR(10)) + '��' , -- Q_Content - text
                '' , -- Q_OptionalAnswer - text
                '���Դ𰸡�' , -- Q_ModelAnswer - text
                '' , -- Q_Remark - varchar(200)
                GETDATE() , -- Q_AddTime - datetime2
                1 , -- Q_Status - tinyint
                0 -- Q_Score - int

SET @id = @id + 1;      
INSERT  dbo.Questions
        SELECT  @id , -- Q_Id - int
                '������' , -- Q_Type - varchar(20)
                1 , -- QC_Id - int
                0 , -- Q_DifficultyCoefficient - tinyint
                '��������' + CAST(@id AS VARCHAR(10)) + '��' , -- Q_Content - text
                '' , -- Q_OptionalAnswer - text
                '���Դ𰸡�' , -- Q_ModelAnswer - text
                '' , -- Q_Remark - varchar(200)
                GETDATE() , -- Q_AddTime - datetime2
                1 , -- Q_Status - tinyint
                0 -- Q_Score - int

SET @id = @id + 1;      
INSERT  dbo.Questions
        SELECT  @id , -- Q_Id - int
                '����������' , -- Q_Type - varchar(20)
                1 , -- QC_Id - int
                0 , -- Q_DifficultyCoefficient - tinyint
                '��������' + CAST(@id AS VARCHAR(10)) + '��' , -- Q_Content - text
                '' , -- Q_OptionalAnswer - text
                '���Դ𰸡�' , -- Q_ModelAnswer - text
                '' , -- Q_Remark - varchar(200)
                GETDATE() , -- Q_AddTime - datetime2
                1 , -- Q_Status - tinyint
                0 -- Q_Score - int

SET @id = @id + 1;      
INSERT  dbo.Questions
        SELECT  @id , -- Q_Id - int
                '�ʴ���' , -- Q_Type - varchar(20)
                1 , -- QC_Id - int
                0 , -- Q_DifficultyCoefficient - tinyint
                '��������' + CAST(@id AS VARCHAR(10)) + '��' , -- Q_Content - text
                '' , -- Q_OptionalAnswer - text
                '���Դ𰸡�' , -- Q_ModelAnswer - text
                '' , -- Q_Remark - varchar(200)
                GETDATE() , -- Q_AddTime - datetime2
                1 , -- Q_Status - tinyint
                0 -- Q_Score - int

SET @id = @id + 1;      
INSERT  dbo.Questions
        SELECT  @id , -- Q_Id - int
                '��ѡ��' , -- Q_Type - varchar(20)
                1 , -- QC_Id - int
                0 , -- Q_DifficultyCoefficient - tinyint
                '��������' + CAST(@id AS VARCHAR(10)) + '��' , -- Q_Content - text
                '{"A":"9��","B":"10��","C":"12��","D":"13��"}' , -- Q_OptionalAnswer - text
                '["D"]' , -- Q_ModelAnswer - text
                '' , -- Q_Remark - varchar(200)
                GETDATE() , -- Q_AddTime - datetime2
                1 , -- Q_Status - tinyint
                100 -- Q_Score - int
        
SELECT TOP 8
        *
FROM    dbo.Questions
ORDER BY Q_Id DESC