USE OLS;

GO

DECLARE @id INT;

SELECT  @id = MAX(Q_AutoId) + 1
FROM    dbo.Questions;

INSERT  dbo.Questions
        SELECT  @id , -- Q_Id - int
                '单选题' , -- Q_Type - varchar(20)
                1 , -- QC_Id - int
                0 , -- Q_DifficultyCoefficient - tinyint
                '测试试题' + CAST(@id AS VARCHAR(10)) + '。' , -- Q_Content - text
                '{"A":"9种","B":"10种","C":"12种","D":"13种"}' , -- Q_OptionalAnswer - text
                '["D"]' , -- Q_ModelAnswer - text
                '' , -- Q_Remark - varchar(200)
                GETDATE() , -- Q_AddTime - datetime2
                1 , -- Q_Status - tinyint
                0 -- Q_Score - int

SET @id = @id + 1;
INSERT  dbo.Questions
        SELECT  @id , -- Q_Id - int
                '多选题' , -- Q_Type - varchar(20)
                1 , -- QC_Id - int
                0 , -- Q_DifficultyCoefficient - tinyint
                '测试试题' + CAST(@id AS VARCHAR(10)) + '。' , -- Q_Content - text
                '{"A":"9种","B":"10种","C":"12种","D":"13种"}' , -- Q_OptionalAnswer - text
                '["D"]' , -- Q_ModelAnswer - text
                '' , -- Q_Remark - varchar(200)
                GETDATE() , -- Q_AddTime - datetime2
                1 , -- Q_Status - tinyint
                0  -- Q_Score - int
    
SET @id = @id + 1;      
INSERT  dbo.Questions
        SELECT  @id , -- Q_Id - int
                '判断题' , -- Q_Type - varchar(20)
                1 , -- QC_Id - int
                0 , -- Q_DifficultyCoefficient - tinyint
                '测试试题' + CAST(@id AS VARCHAR(10)) + '。' , -- Q_Content - text
                '' , -- Q_OptionalAnswer - text
                '√' , -- Q_ModelAnswer - text
                '' , -- Q_Remark - varchar(200)
                GETDATE() , -- Q_AddTime - datetime2
                1 , -- Q_Status - tinyint
                0 -- Q_Score - int

SET @id = @id + 1;      
INSERT  dbo.Questions
        SELECT  @id , -- Q_Id - int
                '公文改错题' , -- Q_Type - varchar(20)
                1 , -- QC_Id - int
                0 , -- Q_DifficultyCoefficient - tinyint
                '测试试题' + CAST(@id AS VARCHAR(10)) + '。' , -- Q_Content - text
                '' , -- Q_OptionalAnswer - text
                '测试答案。' , -- Q_ModelAnswer - text
                '' , -- Q_Remark - varchar(200)
                GETDATE() , -- Q_AddTime - datetime2
                1 , -- Q_Status - tinyint
                0 -- Q_Score - int

SET @id = @id + 1;      
INSERT  dbo.Questions
        SELECT  @id , -- Q_Id - int
                '计算题' , -- Q_Type - varchar(20)
                1 , -- QC_Id - int
                0 , -- Q_DifficultyCoefficient - tinyint
                '测试试题' + CAST(@id AS VARCHAR(10)) + '。' , -- Q_Content - text
                '' , -- Q_OptionalAnswer - text
                '测试答案。' , -- Q_ModelAnswer - text
                '' , -- Q_Remark - varchar(200)
                GETDATE() , -- Q_AddTime - datetime2
                1 , -- Q_Status - tinyint
                0 -- Q_Score - int

SET @id = @id + 1;      
INSERT  dbo.Questions
        SELECT  @id , -- Q_Id - int
                '案例分析题' , -- Q_Type - varchar(20)
                1 , -- QC_Id - int
                0 , -- Q_DifficultyCoefficient - tinyint
                '测试试题' + CAST(@id AS VARCHAR(10)) + '。' , -- Q_Content - text
                '' , -- Q_OptionalAnswer - text
                '测试答案。' , -- Q_ModelAnswer - text
                '' , -- Q_Remark - varchar(200)
                GETDATE() , -- Q_AddTime - datetime2
                1 , -- Q_Status - tinyint
                0 -- Q_Score - int

SET @id = @id + 1;      
INSERT  dbo.Questions
        SELECT  @id , -- Q_Id - int
                '问答题' , -- Q_Type - varchar(20)
                1 , -- QC_Id - int
                0 , -- Q_DifficultyCoefficient - tinyint
                '测试试题' + CAST(@id AS VARCHAR(10)) + '。' , -- Q_Content - text
                '' , -- Q_OptionalAnswer - text
                '测试答案。' , -- Q_ModelAnswer - text
                '' , -- Q_Remark - varchar(200)
                GETDATE() , -- Q_AddTime - datetime2
                1 , -- Q_Status - tinyint
                0 -- Q_Score - int

SET @id = @id + 1;      
INSERT  dbo.Questions
        SELECT  @id , -- Q_Id - int
                '单选题' , -- Q_Type - varchar(20)
                1 , -- QC_Id - int
                0 , -- Q_DifficultyCoefficient - tinyint
                '测试试题' + CAST(@id AS VARCHAR(10)) + '。' , -- Q_Content - text
                '{"A":"9种","B":"10种","C":"12种","D":"13种"}' , -- Q_OptionalAnswer - text
                '["D"]' , -- Q_ModelAnswer - text
                '' , -- Q_Remark - varchar(200)
                GETDATE() , -- Q_AddTime - datetime2
                1 , -- Q_Status - tinyint
                100 -- Q_Score - int
        
SELECT TOP 8
        *
FROM    dbo.Questions
ORDER BY Q_Id DESC