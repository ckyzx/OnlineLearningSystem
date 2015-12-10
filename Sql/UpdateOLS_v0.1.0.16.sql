BEGIN TRAN UpdateOLS_v010116

USE OLS;

GO

/*-- 添加字段“试卷模板试题分数”
ALTER TABLE ExaminationPaperTemplateQuestions
ADD EPTQ_Score INT NULL;

GO

UPDATE ExaminationPaperTemplateQuestions SET EPTQ_Score = 0;

GO

ALTER TABLE ExaminationPaperTemplateQuestions
ALTER COLUMN EPTQ_Score INT NOT NULL;

ALTER TABLE ExaminationPaperTemplateQuestions
ALTER COLUMN EPT_Id INT NOT NULL;
ALTER TABLE ExaminationPaperTemplateQuestions
ALTER COLUMN EPTQ_Status TINYINT NOT NULL;

GO

-- 添加字段“考试任务状态”
ALTER TABLE ExaminationTasks
ADD ET_Enabled TINYINT NULL;

GO

UPDATE ExaminationTasks SET ET_Enabled = 0;

GO

ALTER TABLE ExaminationTasks
ALTER COLUMN ET_Enabled TINYINT NOT NULL;

GO*/

-- 添加字段“试卷模板开始日期”
ALTER TABLE ExaminationPaperTemplates
ADD EPT_StartDate DATETIME2 NULL;

GO

UPDATE ExaminationPaperTemplates SET EPT_StartDate = CONVERT(VARCHAR(10), EPT_AddTime, 120)

GO

ALTER TABLE ExaminationPaperTemplates
ALTER COLUMN EPT_StartDate DATETIME2 NOT NULL;

ALTER TABLE ExaminationPaperTemplates
ALTER COLUMN ET_Id INT NOT NULL;
ALTER TABLE ExaminationPaperTemplates
ALTER COLUMN ET_Type TINYINT NOT NULL;
ALTER TABLE ExaminationPaperTemplates
ALTER COLUMN EPT_PaperTemplateStatus TINYINT NOT NULL;
ALTER TABLE ExaminationPaperTemplates
ALTER COLUMN EPT_EndTime DATETIME2 NOT NULL;
ALTER TABLE ExaminationPaperTemplates
ALTER COLUMN EPT_Questions TEXT NOT NULL;

GO

COMMIT TRAN UpdateOLS_v010116