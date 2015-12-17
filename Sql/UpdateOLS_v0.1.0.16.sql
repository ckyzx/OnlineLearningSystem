BEGIN TRAN UpdateOLS_v010116

USE OLS;

GO

-- 添加字段“试卷模板试题分数”
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

GO

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

-- 添加角色权限“设置分数”
SET IDENTITY_INSERT [dbo].[Permissions] ON
INSERT [dbo].[Permissions] ([P_Id], [P_AutoId], [PC_Id], [P_Name], [P_Controller], [P_Action], [P_Remark], [P_AddTime]) VALUES (116, 116, 7, N'设置分数', N'Question', N'SetScore', NULL, CAST(0x079DAEB04D8BAB3A0B AS DateTime2));
SET IDENTITY_INSERT [dbo].[Permissions] OFF
INSERT [dbo].[Role_Permission] ([R_Id], [P_Id]) VALUES (1, 116)
UPDATE Roles SET 
R_Permissions = '[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116]',
R_PermissionCategories = '[1,2,3,4,5,6,7,8,9,10,11]'
WHERE R_Id = 1

GO

-- 添加试卷字段“结束时间”、“时长”
ALTER TABLE ExaminationPapers
ADD EP_EndTime DATETIME2 NULL;
ALTER TABLE ExaminationPapers
ADD EP_TimeSpan INT NULL;

GO

UPDATE ExaminationPapers 
SET EP_EndTime = ept.EPT_EndTime, 
	EP_TimeSpan = ept.EPT_TimeSpan
FROM 
	ExaminationPapers ep LEFT JOIN
	ExaminationPaperTemplates ept
	ON ept.EPT_Id = ep.EPT_Id	

GO

ALTER TABLE ExaminationPapers
ALTER COLUMN EP_EndTime DATETIME2 NOT NULL;
ALTER TABLE ExaminationPapers
ALTER COLUMN EP_TimeSpan INT NOT NULL;

ALTER TABLE ExaminationPapers
ALTER COLUMN EP_PaperStatus TINYINT NOT NULL;

GO

-- 添加用户字段“排序”
ALTER TABLE Users
ADD U_Sort FLOAT NULL;

GO

UPDATE Users Set U_Sort = U_Id;

GO

ALTER TABLE Users
ALTER COLUMN U_Sort FLOAT NOT NULL;

GO

-- 添加角色权限“用户排序”
SET IDENTITY_INSERT [dbo].[Permissions] ON
INSERT [dbo].[Permissions] ([P_Id], [P_AutoId], [PC_Id], [P_Name], [P_Controller], [P_Action], [P_Remark], [P_AddTime]) 
VALUES (117, 117, 5, N'用户排序', N'User', N'Sort', NULL, CAST(0x079DAEB04D8BAB3A0B AS DateTime2));
SET IDENTITY_INSERT [dbo].[Permissions] OFF
INSERT [dbo].[Role_Permission] ([R_Id], [P_Id]) VALUES (1, 117)
UPDATE Roles SET 
R_Permissions = '[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,117]',
R_PermissionCategories = '[1,2,3,4,5,6,7,8,9,10,11]'
WHERE R_Id = 1

GO

-- 添加职务字段“排序”
ALTER TABLE Duties
ADD Du_Sort FLOAT NULL;

GO

UPDATE Duties Set Du_Sort = Du_Id;

GO

ALTER TABLE Duties
ALTER COLUMN Du_Sort FLOAT NOT NULL;

GO

-- 添加角色权限“职务排序”
SET IDENTITY_INSERT [dbo].[Permissions] ON
INSERT [dbo].[Permissions] ([P_Id], [P_AutoId], [PC_Id], [P_Name], [P_Controller], [P_Action], [P_Remark], [P_AddTime]) 
VALUES (118, 118, 4, N'职务排序', N'Duty', N'Sort', NULL, CAST(0x079DAEB04D8BAB3A0B AS DateTime2));
SET IDENTITY_INSERT [dbo].[Permissions] OFF
INSERT [dbo].[Role_Permission] ([R_Id], [P_Id]) VALUES (1, 118)
UPDATE Roles SET 
R_Permissions = '[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,117,118]',
R_PermissionCategories = '[1,2,3,4,5,6,7,8,9,10,11]'
WHERE R_Id = 1

GO

-- 添加部门字段“排序”
ALTER TABLE Departments
ADD D_Sort FLOAT NULL;

GO

UPDATE Departments Set D_Sort = D_Id;

GO

ALTER TABLE Departments
ALTER COLUMN D_Sort FLOAT NOT NULL;

GO

-- 添加角色权限“部门排序”
SET IDENTITY_INSERT [dbo].[Permissions] ON
INSERT [dbo].[Permissions] ([P_Id], [P_AutoId], [PC_Id], [P_Name], [P_Controller], [P_Action], [P_Remark], [P_AddTime]) 
VALUES (119, 119, 3, N'部门排序', N'Department', N'Sort', NULL, CAST(0x079DAEB04D8BAB3A0B AS DateTime2));
SET IDENTITY_INSERT [dbo].[Permissions] OFF
INSERT [dbo].[Role_Permission] ([R_Id], [P_Id]) VALUES (1, 119)
UPDATE Roles SET 
R_Permissions = '[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,117,119]',
R_PermissionCategories = '[1,2,3,4,5,6,7,8,9,10,11]'
WHERE R_Id = 1

GO

COMMIT TRAN UpdateOLS_v010116