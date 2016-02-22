USE OLS;

GO

/* 试题表 */
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

/* 试题分类表 */
DROP INDEX dbo.QuestionClassifies.Index_1;

GO

ALTER TABLE dbo.QuestionClassifies
ALTER COLUMN QC_Name NVARCHAR(100) NOT NULL;

ALTER TABLE dbo.QuestionClassifies
ALTER COLUMN QC_Remark NVARCHAR(200) NULL;

GO

CREATE NONCLUSTERED INDEX Index_1 ON dbo.QuestionClassifies(QC_Name);

GO

/* 任务模板表 */
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

/* 任务参与人员表 */
ALTER TABLE dbo.ExaminationTaskAttendees
ALTER COLUMN ET_Id INT NOT NULL;

GO

/* 考试任务表 */
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

/* 试卷模板表 */
ALTER TABLE dbo.ExaminationPaperTemplates
ALTER COLUMN EPT_Remark NVARCHAR(200) NULL;

GO

/* 试卷表 */
ALTER TABLE dbo.ExaminationPapers
ALTER COLUMN ET_Id INT NOT NULL;

ALTER TABLE dbo.ExaminationPapers
ALTER COLUMN EPT_Id INT NOT NULL;

ALTER TABLE dbo.ExaminationPapers
ALTER COLUMN EP_UserName NVARCHAR(10) NOT NULL;

ALTER TABLE dbo.ExaminationPapers
ALTER COLUMN EP_Remark NVARCHAR(200) NULL;

GO

/* 试卷模板试题表 */
ALTER TABLE dbo.ExaminationPaperTemplateQuestions
ALTER COLUMN EPTQ_Type NVARCHAR(20) NOT NULL;

ALTER TABLE dbo.ExaminationPaperTemplateQuestions
ALTER COLUMN EPTQ_Remark NVARCHAR(200) NULL;

GO

/* 试卷试题表 */
ALTER TABLE dbo.ExaminationPaperQuestions
ALTER COLUMN EP_Id INT NOT NULL;

ALTER TABLE dbo.ExaminationPaperQuestions
ALTER COLUMN EPTQ_Id INT NOT NULL;

ALTER TABLE dbo.ExaminationPaperQuestions
ALTER COLUMN EPQ_Critique NVARCHAR(200) NULL;

GO

/* 用户表 */
DROP INDEX dbo.Users.Index_1;

GO

ALTER TABLE dbo.Users
ALTER COLUMN U_Name NVARCHAR(10) NOT NULL;

ALTER TABLE dbo.Users
ALTER COLUMN U_Remark NVARCHAR(200) NULL;

GO

CREATE NONCLUSTERED INDEX Index_1 ON Users(U_Name, U_LoginName);

GO

/* 职务表 */
ALTER TABLE dbo.Duties
ALTER COLUMN Du_Name NVARCHAR(50) NOT NULL;

ALTER TABLE dbo.Duties
ALTER COLUMN Du_Remark NVARCHAR(200) NULL;

GO

/* 部门表 */
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

/* 部门权限表 */
ALTER TABLE dbo.Department_Role
ALTER COLUMN D_Id INT NOT NULL;

ALTER TABLE dbo.Department_Role
ALTER COLUMN R_Id INT NOT NULL;

GO

/* 角色表 */
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

/* 权限表 */
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

/* 权限目录表 */
ALTER TABLE dbo.PermissionCategories
ALTER COLUMN PC_Name NVARCHAR(20) NOT NULL;

ALTER TABLE dbo.PermissionCategories
ALTER COLUMN PC_Remark NVARCHAR(200) NULL;

GO

/* 资料表 */
ALTER TABLE dbo.LearningDatas
ALTER COLUMN LDC_Id INT NOT NULL;

ALTER TABLE dbo.LearningDatas
ALTER COLUMN LD_Title NVARCHAR(200) NOT NULL;

ALTER TABLE dbo.LearningDatas
ALTER COLUMN LD_Remark NVARCHAR(200) NULL;

GO

/* 资料目录表 */
ALTER TABLE dbo.LearningDataCategories
ALTER COLUMN LDC_Name NVARCHAR(200) NOT NULL;

ALTER TABLE dbo.LearningDataCategories
ALTER COLUMN LDC_Remark NVARCHAR(200) NULL;

GO

/* 日志表 */
ALTER TABLE dbo.SystemLogs
ALTER COLUMN SL_Name NVARCHAR(500) NOT NULL;

ALTER TABLE dbo.SystemLogs
ALTER COLUMN SL_Remark NVARCHAR(200) NULL;

GO
