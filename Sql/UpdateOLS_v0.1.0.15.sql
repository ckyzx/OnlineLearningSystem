BEGIN TRAN UpdateOLS_v01015

USE OLS;

GO

-- 添加字段“成绩统计方式”、“出题总分”、“出题总数”、“出题分类”、“出题比例”
ALTER TABLE ExaminationTasks
ADD ET_StatisticType TINYINT NULL;
ALTER TABLE ExaminationTasks
ADD ET_TotalScore INT NULL;
ALTER TABLE ExaminationTasks
ADD ET_AutoNumber INT NULL;
ALTER TABLE ExaminationTasks
ADD ET_AutoClassifies TEXT NULL;
ALTER TABLE ExaminationTasks
ADD ET_AutoRatio VARCHAR(500) NULL;

GO

UPDATE ExaminationTasks SET ET_StatisticType = 0, ET_TotalScore = 100, ET_AutoNumber = 10, ET_AutoClassifies = '[]', ET_AutoRatio = '[]';

GO

ALTER TABLE ExaminationTasks
ALTER COLUMN ET_StatisticType TINYINT NOT NULL;
ALTER TABLE ExaminationTasks
ALTER COLUMN ET_TotalScore INT NOT NULL;
ALTER TABLE ExaminationTasks
ALTER COLUMN ET_AutoNumber INT NOT NULL;
ALTER TABLE ExaminationTasks
ALTER COLUMN ET_AutoClassifies TEXT NOT NULL;
ALTER TABLE ExaminationTasks
ALTER COLUMN ET_AutoRatio VARCHAR(500) NOT NULL;

ALTER TABLE ExaminationTasks
ALTER COLUMN ET_ParticipatingDepartment TEXT NOT NULL;
ALTER TABLE ExaminationTasks
ALTER COLUMN ET_Attendee TEXT NOT NULL;
ALTER TABLE ExaminationTasks
ALTER COLUMN ET_AutoOffsetDay TINYINT NOT NULL;
ALTER TABLE ExaminationTasks
ALTER COLUMN ET_PaperTemplates TEXT NOT NULL;
ALTER TABLE ExaminationTasks
ALTER COLUMN ET_Questions TEXT NOT NULL;

GO

-- 添加字段“试题分数”
ALTER TABLE Questions
ADD Q_Score INT NULL;

GO

UPDATE Questions SET Q_Score = 0;

GO

ALTER TABLE Questions
ALTER COLUMN Q_Score INT NOT NULL;

GO

-- 添加角色权限“检查考试任务名称”
SET IDENTITY_INSERT [dbo].[Permissions] ON
INSERT [dbo].[Permissions] ([P_Id], [P_AutoId], [PC_Id], [P_Name], [P_Controller], [P_Action], [P_Remark], [P_AddTime]) VALUES (115, 115, 9, N'检查考试任务名称', N'ExaminationTask', N'DuplicateName', NULL, CAST(0x079DAEB04D8BAB3A0B AS DateTime2));
SET IDENTITY_INSERT [dbo].[Permissions] OFF
INSERT [dbo].[Role_Permission] ([R_Id], [P_Id]) VALUES (1, 115)
UPDATE Roles SET 
R_Permissions = '[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115]',
R_PermissionCategories = '[1,2,3,4,5,6,7,8,9,10,11]'
WHERE R_Id = 1

GO

COMMIT TRAN UpdateOLS_v01015
