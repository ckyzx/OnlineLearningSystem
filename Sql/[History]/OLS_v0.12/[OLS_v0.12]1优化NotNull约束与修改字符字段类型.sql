USE OLS;

GO

/* ����� */
DROP INDEX dbo.Questions.Index_1;

GO

ALTER TABLE dbo.Questions
ALTER COLUMN Q_Type NVARCHAR(20) NOT NULL;

ALTER TABLE dbo.Questions
ALTER COLUMN QC_Id INT NOT NULL;

ALTER TABLE dbo.Questions
ALTER COLUMN Q_Remark NVARCHAR(200) NULL;

GO

CREATE NONCLUSTERED INDEX Index_1 ON dbo.Questions(Q_Type, Q_DifficultyCoefficient);

GO

/* �������� */
DROP INDEX dbo.QuestionClassifies.Index_1;

GO

ALTER TABLE dbo.QuestionClassifies
ALTER COLUMN QC_Name NVARCHAR(100) NOT NULL;

ALTER TABLE dbo.QuestionClassifies
ALTER COLUMN QC_Remark NVARCHAR(200) NULL;

GO

CREATE NONCLUSTERED INDEX Index_1 ON dbo.QuestionClassifies(QC_Name);

GO

/* ����ģ��� */
ALTER TABLE dbo.ExaminationTaskTemplates
ALTER COLUMN ETT_Name NVARCHAR(50) NOT NULL;

ALTER TABLE dbo.ExaminationTaskTemplates
ALTER COLUMN ETT_AutoRatio NVARCHAR(500) NOT NULL;

ALTER TABLE dbo.ExaminationTaskTemplates
ALTER COLUMN ETT_Remark NVARCHAR(200) NULL;

ALTER TABLE dbo.ExaminationTaskTemplates
ALTER COLUMN ETT_ParticipatingDepartment TEXT NOT NULL;

ALTER TABLE dbo.ExaminationTaskTemplates
ALTER COLUMN ETT_Attendee TEXT NOT NULL;

ALTER TABLE dbo.ExaminationTaskTemplates
ALTER COLUMN ETT_AutoOffsetDay TINYINT NOT NULL;

GO

/* ���������Ա�� */
ALTER TABLE dbo.ExaminationTaskAttendees
ALTER COLUMN ET_Id INT NOT NULL;

GO

/* ��������� */
DROP INDEX dbo.ExaminationTasks.Index_1;

GO

ALTER TABLE dbo.ExaminationTasks
ALTER COLUMN ET_Name NVARCHAR(50) NOT NULL;

ALTER TABLE dbo.ExaminationTasks
ALTER COLUMN ET_AutoRatio NVARCHAR(500) NOT NULL;

ALTER TABLE dbo.ExaminationTasks
ALTER COLUMN ET_Remark NVARCHAR(200) NULL;

GO

CREATE NONCLUSTERED INDEX Index_1 ON dbo.ExaminationTasks(ET_Name);

GO

/* �Ծ�ģ��� */
ALTER TABLE dbo.ExaminationPaperTemplates
ALTER COLUMN EPT_Remark NVARCHAR(200) NULL;

GO

/* �Ծ�� */
ALTER TABLE dbo.ExaminationPapers
ALTER COLUMN ET_Id INT NOT NULL;

ALTER TABLE dbo.ExaminationPapers
ALTER COLUMN EPT_Id INT NOT NULL;

ALTER TABLE dbo.ExaminationPapers
ALTER COLUMN EP_UserName NVARCHAR(10) NOT NULL;

ALTER TABLE dbo.ExaminationPapers
ALTER COLUMN EP_Remark NVARCHAR(200) NULL;

GO

/* �Ծ�ģ������� */
ALTER TABLE dbo.ExaminationPaperTemplateQuestions
ALTER COLUMN EPTQ_Type NVARCHAR(20) NOT NULL;

ALTER TABLE dbo.ExaminationPaperTemplateQuestions
ALTER COLUMN EPTQ_Remark NVARCHAR(200) NULL;

GO

/* �Ծ������ */
ALTER TABLE dbo.ExaminationPaperQuestions
ALTER COLUMN EP_Id INT NOT NULL;

ALTER TABLE dbo.ExaminationPaperQuestions
ALTER COLUMN EPTQ_Id INT NOT NULL;

ALTER TABLE dbo.ExaminationPaperQuestions
ALTER COLUMN EPQ_Critique NVARCHAR(200) NULL;

GO

/* �û��� */
DROP INDEX dbo.Users.Index_1;

GO

ALTER TABLE dbo.Users
ALTER COLUMN U_Name NVARCHAR(10) NOT NULL;

ALTER TABLE dbo.Users
ALTER COLUMN U_Remark NVARCHAR(200) NULL;

GO

CREATE NONCLUSTERED INDEX Index_1 ON Users(U_Name, U_LoginName);

GO

/* ְ��� */
ALTER TABLE dbo.Duties
ALTER COLUMN Du_Name NVARCHAR(50) NOT NULL;

ALTER TABLE dbo.Duties
ALTER COLUMN Du_Remark NVARCHAR(200) NULL;

GO

/* ���ű� */
DROP INDEX dbo.Departments.Index_1;

GO

ALTER TABLE dbo.Departments
ALTER COLUMN D_Roles TEXT NOT NULL;

ALTER TABLE dbo.Departments
ALTER COLUMN D_Name NVARCHAR(50) NOT NULL;

ALTER TABLE dbo.Departments
ALTER COLUMN D_Remark NVARCHAR(200) NULL;

GO

CREATE NONCLUSTERED INDEX Index_1 ON dbo.Departments(D_Name);

GO

/* ����Ȩ�ޱ� */
ALTER TABLE dbo.Department_Role
ALTER COLUMN D_Id INT NOT NULL;

ALTER TABLE dbo.Department_Role
ALTER COLUMN R_Id INT NOT NULL;

GO

/* ��ɫ�� */
DROP INDEX dbo.Roles.Index_1;

GO

ALTER TABLE dbo.Roles
ALTER COLUMN R_Name NVARCHAR(50) NOT NULL;

ALTER TABLE dbo.Roles
ALTER COLUMN R_Permissions TEXT NOT NULL;

ALTER TABLE dbo.Roles
ALTER COLUMN R_PermissionCategories TEXT NOT NULL;

ALTER TABLE dbo.Roles
ALTER COLUMN R_Remark NVARCHAR(200) NULL;

GO

CREATE NONCLUSTERED INDEX Index_1 ON Roles(R_Name);

GO

/* Ȩ�ޱ� */
DROP INDEX dbo.[Permissions].Index_1;

GO

ALTER TABLE dbo.[Permissions]
ALTER COLUMN PC_Id INT NOT NULL;

ALTER TABLE dbo.[Permissions]
ALTER COLUMN P_Name NVARCHAR(50) NOT NULL;

ALTER TABLE dbo.[Permissions]
ALTER COLUMN P_Remark NVARCHAR(200) NULL;

GO

CREATE NONCLUSTERED INDEX Index_1 ON [dbo].[Permissions](P_Name);

GO

/* Ȩ��Ŀ¼�� */
ALTER TABLE dbo.PermissionCategories
ALTER COLUMN PC_Name NVARCHAR(20) NOT NULL;

ALTER TABLE dbo.PermissionCategories
ALTER COLUMN PC_Remark NVARCHAR(200) NULL;

GO

/* ���ϱ� */
ALTER TABLE dbo.LearningDatas
ALTER COLUMN LDC_Id INT NOT NULL;

ALTER TABLE dbo.LearningDatas
ALTER COLUMN LD_Title NVARCHAR(200) NOT NULL;

ALTER TABLE dbo.LearningDatas
ALTER COLUMN LD_Remark NVARCHAR(200) NULL;

GO

/* ����Ŀ¼�� */
ALTER TABLE dbo.LearningDataCategories
ALTER COLUMN LDC_Name NVARCHAR(200) NOT NULL;

ALTER TABLE dbo.LearningDataCategories
ALTER COLUMN LDC_Remark NVARCHAR(200) NULL;

GO

/* ��־�� */
ALTER TABLE dbo.SystemLogs
ALTER COLUMN SL_Name NVARCHAR(500) NOT NULL;

ALTER TABLE dbo.SystemLogs
ALTER COLUMN SL_Remark NVARCHAR(200) NULL;

GO
