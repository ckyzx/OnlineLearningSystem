USE OLS;

GO

-- 添加角色权限“个人考试统计”
/*SET IDENTITY_INSERT [dbo].[Permissions] ON
INSERT [dbo].[Permissions] ([P_Id], [P_AutoId], [PC_Id], [P_Name], [P_Controller], [P_Action], [P_Remark], [P_AddTime]) 
VALUES (130, 130, 6, N'个人考试统计', N'ExaminationTaskStatistic', N'Personal', NULL, CAST(0x079DAEB04D8BAB3A0B AS DateTime2));
SET IDENTITY_INSERT [dbo].[Permissions] OFF
INSERT [dbo].[Role_Permission] ([R_Id], [P_Id]) VALUES (1, 130)
UPDATE Roles SET 
R_Permissions = '[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130]',
R_PermissionCategories = '[1,2,3,4,5,6,7,8,9,10,11]'
WHERE R_Id = 1

GO

-- 设置用户公共权限
INSERT [dbo].[Role_Permission]
SELECT R_Id, 130 FROM dbo.Roles WHERE R_Id <> 1;

UPDATE Roles SET 
R_Permissions = '[46,47,79,81,89,90,93,94,95,96,130]',
R_PermissionCategories = '[6,11]'
WHERE R_Id <> 1;

GO

-- 添加角色权限“获取用户试题数据”
SET IDENTITY_INSERT [dbo].[Permissions] ON
INSERT [dbo].[Permissions] ([P_Id], [P_AutoId], [PC_Id], [P_Name], [P_Controller], [P_Action], [P_Remark], [P_AddTime]) 
VALUES (131, 131, 11, N'获取用户试题数据', N'ExaminationPaperTemplate', N'GetQuestionsForUser', NULL, CAST(0x079DAEB04D8BAB3A0B AS DateTime2));
SET IDENTITY_INSERT [dbo].[Permissions] OFF
INSERT [dbo].[Role_Permission] ([R_Id], [P_Id]) VALUES (1, 131)
UPDATE Roles SET 
R_Permissions = '[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131]',
R_PermissionCategories = '[1,2,3,4,5,6,7,8,9,10,11]'
WHERE R_Id = 1

GO

-- 设置用户公共权限
INSERT [dbo].[Role_Permission]
SELECT R_Id, 131 FROM dbo.Roles WHERE R_Id <> 1;

UPDATE Roles SET 
R_Permissions = '[46,47,79,81,89,90,93,94,95,96,130,131]',
R_PermissionCategories = '[6,11]'
WHERE R_Id <> 1;*/

-- 添加角色权限“查看试卷”
SET IDENTITY_INSERT [dbo].[Permissions] ON
INSERT [dbo].[Permissions] ([P_Id], [P_AutoId], [PC_Id], [P_Name], [P_Controller], [P_Action], [P_Remark], [P_AddTime]) 
VALUES (132, 132, 11, N'查看试卷', N'ExaminationPaperTemplate', N'PaperView', NULL, CAST(0x079DAEB04D8BAB3A0B AS DateTime2));
SET IDENTITY_INSERT [dbo].[Permissions] OFF
INSERT [dbo].[Role_Permission] ([R_Id], [P_Id]) VALUES (1, 132)
UPDATE Roles SET 
R_Permissions = '[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132]',
R_PermissionCategories = '[1,2,3,4,5,6,7,8,9,10,11]'
WHERE R_Id = 1

GO

-- 设置用户公共权限
INSERT [dbo].[Role_Permission]
SELECT R_Id, 132 FROM dbo.Roles WHERE R_Id <> 1;

UPDATE Roles SET 
R_Permissions = '[46,47,79,81,89,90,93,94,95,96,130,131,132]',
R_PermissionCategories = '[6,11]'
WHERE R_Id <> 1;

GO
