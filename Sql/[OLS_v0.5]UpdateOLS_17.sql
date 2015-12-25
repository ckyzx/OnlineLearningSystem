BEGIN TRAN UpdateOLS_v0517

USE OLS;

GO

UPDATE Departments SET D_Name = '新陂分局（大税源管理分局）' WHERE D_Name = '新陂分局（大税源管理分局） '

GO

-- 添加角色权限“改卷列表”
SET IDENTITY_INSERT [dbo].[Permissions] ON
INSERT [dbo].[Permissions] ([P_Id], [P_AutoId], [PC_Id], [P_Name], [P_Controller], [P_Action], [P_Remark], [P_AddTime]) 
VALUES (120, 120, 10, N'改卷列表', N'ExaminationPaperTemplate', N'ListGrade', NULL, CAST(0x079DAEB04D8BAB3A0B AS DateTime2));
SET IDENTITY_INSERT [dbo].[Permissions] OFF
INSERT [dbo].[Role_Permission] ([R_Id], [P_Id]) VALUES (1, 120)
UPDATE Roles SET 
R_Permissions = '[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,117,119,120]',
R_PermissionCategories = '[1,2,3,4,5,6,7,8,9,10,11]'
WHERE R_Id = 1

-- 添加角色权限“获取改卷用户数据”
SET IDENTITY_INSERT [dbo].[Permissions] ON
INSERT [dbo].[Permissions] ([P_Id], [P_AutoId], [PC_Id], [P_Name], [P_Controller], [P_Action], [P_Remark], [P_AddTime]) 
VALUES (121, 121, 10, N'获取改卷用户数据', N'ExaminationPaperTemplate', N'GetUsers', NULL, CAST(0x079DAEB04D8BAB3A0B AS DateTime2));
SET IDENTITY_INSERT [dbo].[Permissions] OFF
INSERT [dbo].[Role_Permission] ([R_Id], [P_Id]) VALUES (1, 121)
UPDATE Roles SET 
R_Permissions = '[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,117,119,120,121]',
R_PermissionCategories = '[1,2,3,4,5,6,7,8,9,10,11]'
WHERE R_Id = 1

GO

-- 添加角色权限“获取改卷试题数据”
SET IDENTITY_INSERT [dbo].[Permissions] ON
INSERT [dbo].[Permissions] ([P_Id], [P_AutoId], [PC_Id], [P_Name], [P_Controller], [P_Action], [P_Remark], [P_AddTime]) 
VALUES (122, 122, 10, N'获取改卷试题数据', N'ExaminationPaperTemplate', N'GetQuestions', NULL, CAST(0x079DAEB04D8BAB3A0B AS DateTime2));
SET IDENTITY_INSERT [dbo].[Permissions] OFF
INSERT [dbo].[Role_Permission] ([R_Id], [P_Id]) VALUES (1, 122)
UPDATE Roles SET 
R_Permissions = '[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,117,119,120,121,122]',
R_PermissionCategories = '[1,2,3,4,5,6,7,8,9,10,11]'
WHERE R_Id = 1

GO

-- 添加角色权限“终止考试”
SET IDENTITY_INSERT [dbo].[Permissions] ON
INSERT [dbo].[Permissions] ([P_Id], [P_AutoId], [PC_Id], [P_Name], [P_Controller], [P_Action], [P_Remark], [P_AddTime]) 
VALUES (123, 123, 10, N'终止考试', N'ExaminationPaperTemplate', N'Terminate', NULL, CAST(0x079DAEB04D8BAB3A0B AS DateTime2));
SET IDENTITY_INSERT [dbo].[Permissions] OFF
INSERT [dbo].[Role_Permission] ([R_Id], [P_Id]) VALUES (1, 123)
UPDATE Roles SET 
R_Permissions = '[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,117,119,120,121,122,123]',
R_PermissionCategories = '[1,2,3,4,5,6,7,8,9,10,11]'
WHERE R_Id = 1

GO

-- 添加角色权限“提交改卷数据”
SET IDENTITY_INSERT [dbo].[Permissions] ON
INSERT [dbo].[Permissions] ([P_Id], [P_AutoId], [PC_Id], [P_Name], [P_Controller], [P_Action], [P_Remark], [P_AddTime]) 
VALUES (124, 124, 10, N'提交改卷数据', N'ExaminationPaperTemplate', N'Grade', NULL, CAST(0x079DAEB04D8BAB3A0B AS DateTime2));
SET IDENTITY_INSERT [dbo].[Permissions] OFF
INSERT [dbo].[Role_Permission] ([R_Id], [P_Id]) VALUES (1, 124)
UPDATE Roles SET 
R_Permissions = '[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,117,119,120,121,122,124]',
R_PermissionCategories = '[1,2,3,4,5,6,7,8,9,10,11]'
WHERE R_Id = 1

GO

-- 添加任务参与人员表
CREATE TABLE ExaminationTaskAttendees
    (
      ET_Id INT NULL ,
      U_Id INT NOT NULL ,
      D_Id INT NOT NULL
    )

GO

ALTER TABLE ExaminationTaskAttendees
ADD CONSTRAINT FK_EXAMINAT_ETA_ET_EXAMINAT FOREIGN KEY (ET_Id)
REFERENCES ExaminationTasks (ET_Id)

GO

-- 添加角色权限“考试统计列表”
SET IDENTITY_INSERT [dbo].[Permissions] ON
INSERT [dbo].[Permissions] ([P_Id], [P_AutoId], [PC_Id], [P_Name], [P_Controller], [P_Action], [P_Remark], [P_AddTime]) 
VALUES (125, 125, 9, N'考试统计列表', N'ExaminationTaskStatistic', N'List', NULL, CAST(0x079DAEB04D8BAB3A0B AS DateTime2));
SET IDENTITY_INSERT [dbo].[Permissions] OFF
INSERT [dbo].[Role_Permission] ([R_Id], [P_Id]) VALUES (1, 125)
UPDATE Roles SET 
R_Permissions = '[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,117,119,120,121,122,124,125]',
R_PermissionCategories = '[1,2,3,4,5,6,7,8,9,10,11]'
WHERE R_Id = 1

-- 添加角色权限“查询考试统计”
SET IDENTITY_INSERT [dbo].[Permissions] ON
INSERT [dbo].[Permissions] ([P_Id], [P_AutoId], [PC_Id], [P_Name], [P_Controller], [P_Action], [P_Remark], [P_AddTime]) 
VALUES (126, 126, 9, N'查询考试统计', N'ExaminationTaskStatistic', N'ListDataTablesAjax', NULL, CAST(0x079DAEB04D8BAB3A0B AS DateTime2));
SET IDENTITY_INSERT [dbo].[Permissions] OFF
INSERT [dbo].[Role_Permission] ([R_Id], [P_Id]) VALUES (1, 126)
UPDATE Roles SET 
R_Permissions = '[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,117,119,120,121,122,124,125,126]',
R_PermissionCategories = '[1,2,3,4,5,6,7,8,9,10,11]'
WHERE R_Id = 1

GO

-- 添加角色权限“用户考试统计列表”、“查询用户考试统计”
SET IDENTITY_INSERT [dbo].[Permissions] ON
INSERT [dbo].[Permissions] ([P_Id], [P_AutoId], [PC_Id], [P_Name], [P_Controller], [P_Action], [P_Remark], [P_AddTime]) 
VALUES (127, 127, 9, N'用户考试统计列表', N'ExaminationTaskStatistic', N'ListUser', NULL, CAST(0x079DAEB04D8BAB3A0B AS DateTime2));
INSERT [dbo].[Permissions] ([P_Id], [P_AutoId], [PC_Id], [P_Name], [P_Controller], [P_Action], [P_Remark], [P_AddTime]) 
VALUES (128, 128, 9, N'查询用户考试统计', N'ExaminationTaskStatistic', N'ListUserDataTablesAjax', NULL, CAST(0x079DAEB04D8BAB3A0B AS DateTime2));
SET IDENTITY_INSERT [dbo].[Permissions] OFF
INSERT [dbo].[Role_Permission] ([R_Id], [P_Id]) VALUES (1, 127)
INSERT [dbo].[Role_Permission] ([R_Id], [P_Id]) VALUES (1, 128)
UPDATE Roles SET 
R_Permissions = '[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,117,119,120,121,122,124,125,126,127,128]',
R_PermissionCategories = '[1,2,3,4,5,6,7,8,9,10,11]'
WHERE R_Id = 1

GO

-- 添加“考试任务模板”字段
ALTER TABLE ExaminationTaskTemplates
ADD ETT_StatisticType TINYINT NULL
ALTER TABLE ExaminationTaskTemplates
ADD ETT_TotalScore INT NULL
ALTER TABLE ExaminationTaskTemplates
ADD ETT_TotalNumber INT NULL
ALTER TABLE ExaminationTaskTemplates
ADD ETT_AutoClassifies TEXT NULL
ALTER TABLE ExaminationTaskTemplates
ADD ETT_AutoRatio VARCHAR(500) NULL

GO

UPDATE ExaminationTaskTemplates SET ETT_StatisticType = 0
UPDATE ExaminationTaskTemplates SET ETT_TotalScore = 0
UPDATE ExaminationTaskTemplates SET ETT_TotalNumber = 0
UPDATE ExaminationTaskTemplates SET ETT_AutoClassifies = '[]'
UPDATE ExaminationTaskTemplates SET ETT_AutoRatio = '[]'

GO

ALTER TABLE ExaminationTaskTemplates
ALTER COLUMN ETT_StatisticType TINYINT NOT NULL
ALTER TABLE ExaminationTaskTemplates
ALTER COLUMN ETT_TotalScore INT NOT NULL
ALTER TABLE ExaminationTaskTemplates
ALTER COLUMN ETT_TotalNumber INT NOT NULL
ALTER TABLE ExaminationTaskTemplates
ALTER COLUMN ETT_AutoClassifies TEXT NOT NULL
ALTER TABLE ExaminationTaskTemplates
ALTER COLUMN ETT_AutoRatios VARCHAR(500) NOT NULL

GO

-- 修改“考试任务”字段
EXEC sp_rename 'ExaminationTasks.ET_AutoNumber', 'ET_TotalNumber', 'COLUMN';

GO

-- 添加角色权限“检查考试任务模板名称”
SET IDENTITY_INSERT [dbo].[Permissions] ON
INSERT [dbo].[Permissions] ([P_Id], [P_AutoId], [PC_Id], [P_Name], [P_Controller], [P_Action], [P_Remark], [P_AddTime]) 
VALUES (129, 129, 8, N'检查考试任务模板名称', N'ExaminationTaskTemplate', N'DuplicateName', NULL, CAST(0x079DAEB04D8BAB3A0B AS DateTime2));
SET IDENTITY_INSERT [dbo].[Permissions] OFF
INSERT [dbo].[Role_Permission] ([R_Id], [P_Id]) VALUES (1, 129)
UPDATE Roles SET 
R_Permissions = '[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,117,119,120,121,122,124,125,126,127,128,129]',
R_PermissionCategories = '[1,2,3,4,5,6,7,8,9,10,11]'
WHERE R_Id = 1

GO

COMMIT TRAN UpdateOLS_v0517