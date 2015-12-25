
-- [1]�������ݿ�
DECLARE @now VARCHAR(100)
DECLARE @fileName VARCHAR(100)
DECLARE @filePath VARCHAR(500)

SET @now = REPLACE(REPLACE(REPLACE(CONVERT(VARCHAR(100), GETDATE(), 20), '-', ''), ' ', ''), ':', '');
SET @fileName = 'OLS_' + @now + '.sqlserver2k8'
-- �������뱣�����ݿⱸ���ļ���·��
-- ����: ���� 'D:\' + @fileName
SET @filePath = 'D:\' + @fileName;

BACKUP DATABASE OLS TO DISK = @filePath

GO

-- [2]�������ݿ�
BEGIN TRAN UpdateOLS_v0415

USE OLS;

GO

-- ����ֶΡ��ɼ�ͳ�Ʒ�ʽ�����������ܷ֡�������������������������ࡱ�������������
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

UPDATE ExaminationTasks 
SET 
ET_StatisticType = 0, 
ET_TotalScore = 100, 
ET_AutoNumber = 10, 
ET_AutoClassifies = '[]', 
ET_AutoRatio = '[]';

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

-- ����ֶΡ����������
ALTER TABLE Questions
ADD Q_Score INT NULL;

GO

UPDATE Questions SET Q_Score = 0;

GO

ALTER TABLE Questions
ALTER COLUMN Q_Score INT NOT NULL;

GO

-- ��ӽ�ɫȨ�ޡ���鿼���������ơ�
SET IDENTITY_INSERT [dbo].[Permissions] ON
INSERT [dbo].[Permissions] ([P_Id], [P_AutoId], [PC_Id], [P_Name], [P_Controller], [P_Action], [P_Remark], [P_AddTime]) VALUES (115, 115, 9, N'��鿼����������', N'ExaminationTask', N'DuplicateName', NULL, CAST(0x079DAEB04D8BAB3A0B AS DateTime2));
SET IDENTITY_INSERT [dbo].[Permissions] OFF
INSERT [dbo].[Role_Permission] ([R_Id], [P_Id]) VALUES (1, 115)
UPDATE Roles SET 
R_Permissions = '[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115]',
R_PermissionCategories = '[1,2,3,4,5,6,7,8,9,10,11]'
WHERE R_Id = 1

GO

COMMIT TRAN UpdateOLS_v0415

GO

BEGIN TRAN UpdateOLS_v0416

USE OLS;

GO

-- ����ֶΡ��Ծ�ģ�����������
ALTER TABLE ExaminationPaperTemplateQuestions
ADD EPTQ_Score INT NULL;

GO

UPDATE ExaminationPaperTemplateQuestions 
SET EPTQ_Score = 0;

GO

ALTER TABLE ExaminationPaperTemplateQuestions
ALTER COLUMN EPTQ_Score INT NOT NULL;

ALTER TABLE ExaminationPaperTemplateQuestions
ALTER COLUMN EPT_Id INT NOT NULL;
ALTER TABLE ExaminationPaperTemplateQuestions
ALTER COLUMN EPTQ_Status TINYINT NOT NULL;

GO

-- ����ֶΡ���������״̬��
ALTER TABLE ExaminationTasks
ADD ET_Enabled TINYINT NULL;

GO

UPDATE ExaminationTasks SET ET_Enabled = 0;

GO

ALTER TABLE ExaminationTasks
ALTER COLUMN ET_Enabled TINYINT NOT NULL;

GO

-- ����ֶΡ��Ծ�ģ�忪ʼ���ڡ�
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

-- ��ӽ�ɫȨ�ޡ����÷�����
SET IDENTITY_INSERT [dbo].[Permissions] ON
INSERT [dbo].[Permissions] ([P_Id], [P_AutoId], [PC_Id], [P_Name], [P_Controller], [P_Action], [P_Remark], [P_AddTime]) VALUES (116, 116, 7, N'���÷���', N'Question', N'SetScore', NULL, CAST(0x079DAEB04D8BAB3A0B AS DateTime2));
SET IDENTITY_INSERT [dbo].[Permissions] OFF
INSERT [dbo].[Role_Permission] ([R_Id], [P_Id]) VALUES (1, 116)
UPDATE Roles SET 
R_Permissions = '[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116]',
R_PermissionCategories = '[1,2,3,4,5,6,7,8,9,10,11]'
WHERE R_Id = 1

GO

-- ����Ծ��ֶΡ�����ʱ�䡱����ʱ����
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

-- ����û��ֶΡ�����
ALTER TABLE Users
ADD U_Sort FLOAT NULL;

GO

UPDATE Users Set U_Sort = U_Id;

GO

ALTER TABLE Users
ALTER COLUMN U_Sort FLOAT NOT NULL;

GO

-- ��ӽ�ɫȨ�ޡ��û�����
SET IDENTITY_INSERT [dbo].[Permissions] ON
INSERT [dbo].[Permissions] ([P_Id], [P_AutoId], [PC_Id], [P_Name], [P_Controller], [P_Action], [P_Remark], [P_AddTime]) 
VALUES (117, 117, 5, N'�û�����', N'User', N'Sort', NULL, CAST(0x079DAEB04D8BAB3A0B AS DateTime2));
SET IDENTITY_INSERT [dbo].[Permissions] OFF
INSERT [dbo].[Role_Permission] ([R_Id], [P_Id]) VALUES (1, 117)
UPDATE Roles SET 
R_Permissions = '[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,117]',
R_PermissionCategories = '[1,2,3,4,5,6,7,8,9,10,11]'
WHERE R_Id = 1

GO

-- ���ְ���ֶΡ�����
ALTER TABLE Duties
ADD Du_Sort FLOAT NULL;

GO

UPDATE Duties Set Du_Sort = Du_Id;

GO

ALTER TABLE Duties
ALTER COLUMN Du_Sort FLOAT NOT NULL;

GO

-- ��ӽ�ɫȨ�ޡ�ְ������
SET IDENTITY_INSERT [dbo].[Permissions] ON
INSERT [dbo].[Permissions] ([P_Id], [P_AutoId], [PC_Id], [P_Name], [P_Controller], [P_Action], [P_Remark], [P_AddTime]) 
VALUES (118, 118, 4, N'ְ������', N'Duty', N'Sort', NULL, CAST(0x079DAEB04D8BAB3A0B AS DateTime2));
SET IDENTITY_INSERT [dbo].[Permissions] OFF
INSERT [dbo].[Role_Permission] ([R_Id], [P_Id]) VALUES (1, 118)
UPDATE Roles SET 
R_Permissions = '[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,117,118]',
R_PermissionCategories = '[1,2,3,4,5,6,7,8,9,10,11]'
WHERE R_Id = 1

GO

-- ��Ӳ����ֶΡ�����
ALTER TABLE Departments
ADD D_Sort FLOAT NULL;

GO

UPDATE Departments Set D_Sort = D_Id;

GO

ALTER TABLE Departments
ALTER COLUMN D_Sort FLOAT NOT NULL;

GO

-- ��ӽ�ɫȨ�ޡ���������
SET IDENTITY_INSERT [dbo].[Permissions] ON
INSERT [dbo].[Permissions] ([P_Id], [P_AutoId], [PC_Id], [P_Name], [P_Controller], [P_Action], [P_Remark], [P_AddTime]) 
VALUES (119, 119, 3, N'��������', N'Department', N'Sort', NULL, CAST(0x079DAEB04D8BAB3A0B AS DateTime2));
SET IDENTITY_INSERT [dbo].[Permissions] OFF
INSERT [dbo].[Role_Permission] ([R_Id], [P_Id]) VALUES (1, 119)
UPDATE Roles SET 
R_Permissions = '[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,117,119]',
R_PermissionCategories = '[1,2,3,4,5,6,7,8,9,10,11]'
WHERE R_Id = 1

GO

COMMIT TRAN UpdateOLS_v0416

GO

BEGIN TRAN UpdateOLS_v0417

USE OLS;

GO

UPDATE Departments 
SET D_Name = '����־֣���˰Դ����־֣�' 
WHERE D_Name = '����־֣���˰Դ����־֣� '

GO

-- ��ӽ�ɫȨ�ޡ��ľ��б�
SET IDENTITY_INSERT [dbo].[Permissions] ON
INSERT [dbo].[Permissions] ([P_Id], [P_AutoId], [PC_Id], [P_Name], [P_Controller], [P_Action], [P_Remark], [P_AddTime]) 
VALUES (120, 120, 10, N'�ľ��б�', N'ExaminationPaperTemplate', N'ListGrade', NULL, CAST(0x079DAEB04D8BAB3A0B AS DateTime2));
SET IDENTITY_INSERT [dbo].[Permissions] OFF
INSERT [dbo].[Role_Permission] ([R_Id], [P_Id]) VALUES (1, 120)
UPDATE Roles SET 
R_Permissions = '[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,117,119,120]',
R_PermissionCategories = '[1,2,3,4,5,6,7,8,9,10,11]'
WHERE R_Id = 1

-- ��ӽ�ɫȨ�ޡ���ȡ�ľ��û����ݡ�
SET IDENTITY_INSERT [dbo].[Permissions] ON
INSERT [dbo].[Permissions] ([P_Id], [P_AutoId], [PC_Id], [P_Name], [P_Controller], [P_Action], [P_Remark], [P_AddTime]) 
VALUES (121, 121, 10, N'��ȡ�ľ��û�����', N'ExaminationPaperTemplate', N'GetUsers', NULL, CAST(0x079DAEB04D8BAB3A0B AS DateTime2));
SET IDENTITY_INSERT [dbo].[Permissions] OFF
INSERT [dbo].[Role_Permission] ([R_Id], [P_Id]) VALUES (1, 121)
UPDATE Roles SET 
R_Permissions = '[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,117,119,120,121]',
R_PermissionCategories = '[1,2,3,4,5,6,7,8,9,10,11]'
WHERE R_Id = 1

GO

-- ��ӽ�ɫȨ�ޡ���ȡ�ľ��������ݡ�
SET IDENTITY_INSERT [dbo].[Permissions] ON
INSERT [dbo].[Permissions] ([P_Id], [P_AutoId], [PC_Id], [P_Name], [P_Controller], [P_Action], [P_Remark], [P_AddTime]) 
VALUES (122, 122, 10, N'��ȡ�ľ���������', N'ExaminationPaperTemplate', N'GetQuestions', NULL, CAST(0x079DAEB04D8BAB3A0B AS DateTime2));
SET IDENTITY_INSERT [dbo].[Permissions] OFF
INSERT [dbo].[Role_Permission] ([R_Id], [P_Id]) VALUES (1, 122)
UPDATE Roles SET 
R_Permissions = '[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,117,119,120,121,122]',
R_PermissionCategories = '[1,2,3,4,5,6,7,8,9,10,11]'
WHERE R_Id = 1

GO

-- ��ӽ�ɫȨ�ޡ���ֹ���ԡ�
SET IDENTITY_INSERT [dbo].[Permissions] ON
INSERT [dbo].[Permissions] ([P_Id], [P_AutoId], [PC_Id], [P_Name], [P_Controller], [P_Action], [P_Remark], [P_AddTime]) 
VALUES (123, 123, 10, N'��ֹ����', N'ExaminationPaperTemplate', N'Terminate', NULL, CAST(0x079DAEB04D8BAB3A0B AS DateTime2));
SET IDENTITY_INSERT [dbo].[Permissions] OFF
INSERT [dbo].[Role_Permission] ([R_Id], [P_Id]) VALUES (1, 123)
UPDATE Roles SET 
R_Permissions = '[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,117,119,120,121,122,123]',
R_PermissionCategories = '[1,2,3,4,5,6,7,8,9,10,11]'
WHERE R_Id = 1

GO

-- ��ӽ�ɫȨ�ޡ��ύ�ľ����ݡ�
SET IDENTITY_INSERT [dbo].[Permissions] ON
INSERT [dbo].[Permissions] ([P_Id], [P_AutoId], [PC_Id], [P_Name], [P_Controller], [P_Action], [P_Remark], [P_AddTime]) 
VALUES (124, 124, 10, N'�ύ�ľ�����', N'ExaminationPaperTemplate', N'Grade', NULL, CAST(0x079DAEB04D8BAB3A0B AS DateTime2));
SET IDENTITY_INSERT [dbo].[Permissions] OFF
INSERT [dbo].[Role_Permission] ([R_Id], [P_Id]) VALUES (1, 124)
UPDATE Roles SET 
R_Permissions = '[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,117,119,120,121,122,124]',
R_PermissionCategories = '[1,2,3,4,5,6,7,8,9,10,11]'
WHERE R_Id = 1

GO

-- ������������Ա��
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

-- ��ӽ�ɫȨ�ޡ�����ͳ���б�
SET IDENTITY_INSERT [dbo].[Permissions] ON
INSERT [dbo].[Permissions] ([P_Id], [P_AutoId], [PC_Id], [P_Name], [P_Controller], [P_Action], [P_Remark], [P_AddTime]) 
VALUES (125, 125, 9, N'����ͳ���б�', N'ExaminationTaskStatistic', N'List', NULL, CAST(0x079DAEB04D8BAB3A0B AS DateTime2));
SET IDENTITY_INSERT [dbo].[Permissions] OFF
INSERT [dbo].[Role_Permission] ([R_Id], [P_Id]) VALUES (1, 125)
UPDATE Roles SET 
R_Permissions = '[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,117,119,120,121,122,124,125]',
R_PermissionCategories = '[1,2,3,4,5,6,7,8,9,10,11]'
WHERE R_Id = 1

-- ��ӽ�ɫȨ�ޡ���ѯ����ͳ�ơ�
SET IDENTITY_INSERT [dbo].[Permissions] ON
INSERT [dbo].[Permissions] ([P_Id], [P_AutoId], [PC_Id], [P_Name], [P_Controller], [P_Action], [P_Remark], [P_AddTime]) 
VALUES (126, 126, 9, N'��ѯ����ͳ��', N'ExaminationTaskStatistic', N'ListDataTablesAjax', NULL, CAST(0x079DAEB04D8BAB3A0B AS DateTime2));
SET IDENTITY_INSERT [dbo].[Permissions] OFF
INSERT [dbo].[Role_Permission] ([R_Id], [P_Id]) VALUES (1, 126)
UPDATE Roles SET 
R_Permissions = '[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,117,119,120,121,122,124,125,126]',
R_PermissionCategories = '[1,2,3,4,5,6,7,8,9,10,11]'
WHERE R_Id = 1

GO

-- ��ӽ�ɫȨ�ޡ��û�����ͳ���б�������ѯ�û�����ͳ�ơ�
SET IDENTITY_INSERT [dbo].[Permissions] ON
INSERT [dbo].[Permissions] ([P_Id], [P_AutoId], [PC_Id], [P_Name], [P_Controller], [P_Action], [P_Remark], [P_AddTime]) 
VALUES (127, 127, 9, N'�û�����ͳ���б�', N'ExaminationTaskStatistic', N'ListUser', NULL, CAST(0x079DAEB04D8BAB3A0B AS DateTime2));
INSERT [dbo].[Permissions] ([P_Id], [P_AutoId], [PC_Id], [P_Name], [P_Controller], [P_Action], [P_Remark], [P_AddTime]) 
VALUES (128, 128, 9, N'��ѯ�û�����ͳ��', N'ExaminationTaskStatistic', N'ListUserDataTablesAjax', NULL, CAST(0x079DAEB04D8BAB3A0B AS DateTime2));
SET IDENTITY_INSERT [dbo].[Permissions] OFF
INSERT [dbo].[Role_Permission] ([R_Id], [P_Id]) VALUES (1, 127)
INSERT [dbo].[Role_Permission] ([R_Id], [P_Id]) VALUES (1, 128)
UPDATE Roles SET 
R_Permissions = '[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,117,119,120,121,122,124,125,126,127,128]',
R_PermissionCategories = '[1,2,3,4,5,6,7,8,9,10,11]'
WHERE R_Id = 1

GO

-- ��ӡ���������ģ�塱�ֶ�
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
ALTER COLUMN ETT_AutoRatio VARCHAR(500) NOT NULL

GO

-- �޸ġ����������ֶ�
EXEC sp_rename 'ExaminationTasks.ET_AutoNumber', 'ET_TotalNumber', 'COLUMN';

GO

-- ��ӽ�ɫȨ�ޡ���鿼������ģ�����ơ�
SET IDENTITY_INSERT [dbo].[Permissions] ON
INSERT [dbo].[Permissions] ([P_Id], [P_AutoId], [PC_Id], [P_Name], [P_Controller], [P_Action], [P_Remark], [P_AddTime]) 
VALUES (129, 129, 8, N'��鿼������ģ������', N'ExaminationTaskTemplate', N'DuplicateName', NULL, CAST(0x079DAEB04D8BAB3A0B AS DateTime2));
SET IDENTITY_INSERT [dbo].[Permissions] OFF
INSERT [dbo].[Role_Permission] ([R_Id], [P_Id]) VALUES (1, 129)
UPDATE Roles SET 
R_Permissions = '[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,117,119,120,121,122,124,125,126,127,128,129]',
R_PermissionCategories = '[1,2,3,4,5,6,7,8,9,10,11]'
WHERE R_Id = 1

GO

COMMIT TRAN UpdateOLS_v0417

GO

-- [3]���������������
USE OLS;

GO

UPDATE Questions SET Q_Score = 5 WHERE Q_Type = '��ѡ��' AND Q_Score = 0;
UPDATE Questions SET Q_Score = 8 WHERE Q_Type = '��ѡ��' AND Q_Score = 0;
UPDATE Questions SET Q_Score = 5 WHERE Q_Type = '�ж���' AND Q_Score = 0;
UPDATE Questions SET Q_Score = 10 WHERE Q_Type = '���ĸĴ���' AND Q_Score = 0;
UPDATE Questions SET Q_Score = 20 WHERE Q_Type = '������' AND Q_Score = 0;
UPDATE Questions SET Q_Score = 25 WHERE Q_Type = '����������' AND Q_Score = 0;
UPDATE Questions SET Q_Score = 15 WHERE Q_Type = '�ʴ���' AND Q_Score = 0;

GO

-- [3]��Ӻ���
-- ��Ӻ��� fn_GetExaminationTaskStatistic
USE OLS;

GO

IF OBJECT_ID(N'dbo.fn_GetExaminationTaskStatistic', N'TF') IS NOT NULL 
    DROP FUNCTION dbo.fn_GetExaminationTaskStatistic;
GO

CREATE FUNCTION fn_GetExaminationTaskStatistic ( )
RETURNS @table TABLE
    (
      ETS_TaskId INT ,
      ETS_TaskName VARCHAR(50) ,
      ETS_PaperTemplateId INT,
      ETS_PaperTemplateDate DATETIME2 ,
      ETS_AttendeeNumber INT ,
      ETS_PaperNumber INT ,
      ETS_PassNumber INT ,
      ETS_FlunkNumber INT
    )
AS 
    BEGIN
        
        INSERT  INTO @table
                SELECT  et1.ET_Id AS ETS_TaskId ,
                        ET_Name AS ETS_TaskName ,
                        EPT_Id AS ETS_PaperTemplateId,
                        EPT_StartDate AS ETS_PaperTemplateDate ,
                        ( CASE WHEN LEN(ET_Attendee1) = 2 THEN 0
                               WHEN LEN(ET_Attendee1) > 2 THEN CASE WHEN LEN(ET_Attendee1) = 3 THEN 1
                                                                    ELSE LEN(REPLACE(ET_Attendee1, ',', '||')) - LEN(ET_Attendee1) + 1
                                                               END
                          END ) AS ETS_AttendeeNumber ,
                        ( SELECT    COUNT(EP_Id)
                          FROM      ExaminationPapers ep
                                    LEFT JOIN ExaminationPaperTemplates ept ON ep.EPT_Id = ept.EPT_Id
                          WHERE     ept.ET_Id = et1.ET_Id
                        ) AS ETS_PaperNumber ,
                        ( SELECT    COUNT(EP_Id)
                          FROM      ExaminationPapers ep
                                    LEFT JOIN ExaminationPaperTemplates ept ON ep.EPT_Id = ept.EPT_Id
                          WHERE     ept.ET_Id = et1.ET_Id
                                    AND ( CASE WHEN ET_StatisticType = 1 THEN CASE WHEN EP_Score >= et1.ET_TotalScore * 0.6 THEN 1
                                                                                   ELSE 0
                                                                              END
                                               WHEN ET_StatisticType = 2 THEN CASE WHEN EP_Score >= 60 THEN 1
                                                                                   ELSE 0
                                                                              END
                                          END ) = 1
                        ) AS ETS_PassNumber ,
                        ( SELECT    COUNT(EP_Id)
                          FROM      ExaminationPapers ep
                                    LEFT JOIN ExaminationPaperTemplates ept ON ep.EPT_Id = ept.EPT_Id
                          WHERE     ept.ET_Id = et1.ET_Id
                                    AND ( CASE WHEN ET_StatisticType = 1 THEN CASE WHEN EP_Score < et1.ET_TotalScore * 0.6 THEN 1
                                                                                   ELSE 0
                                                                              END
                                               WHEN ET_StatisticType = 2 THEN CASE WHEN EP_Score < 60 THEN 1
                                                                                   ELSE 0
                                                                              END
                                          END ) = 1
                        ) AS ETS_FlunkNumber
                FROM    ( SELECT    CAST(ET_Attendee AS VARCHAR(MAX)) AS ET_Attendee1 ,
                                    *
                          FROM      dbo.ExaminationTasks et
                        ) et1 ,
                        dbo.ExaminationPaperTemplates AS ept1
                WHERE   et1.ET_Status = 1
                        AND ept1.EPT_Status = 1
                        AND et1.ET_Id = ept1.ET_Id
        RETURN
    END
    
    GO
    
-- ��Ӻ��� fn_GetExaminationTaskUserStatistic
USE OLS;

GO

IF OBJECT_ID(N'fn_GetExaminationTaskUserStatistic', N'TF') IS NOT NULL 
    DROP FUNCTION fn_GetExaminationTaskUserStatistic;
GO

CREATE FUNCTION fn_GetExaminationTaskUserStatistic ( )
RETURNS @table TABLE
    (
      ETUS_TaskId INT ,
      ETUS_TaskName VARCHAR(50) ,
      ETUS_TaskAutoType TINYINT ,
      ETUS_TaskStatisticType TINYINT ,
      ETUS_PaperTemplateId INT ,
      ETUS_PaperTemplateDate DATETIME2 ,
      ETUS_DepartmentId INT ,
      ETUS_DepartmentName VARCHAR(50) ,
      ETUS_UserId INT ,
      ETUS_UserName VARCHAR(10) ,
      ETUS_DutyId INT ,
      ETUS_DutyName VARCHAR(50) ,
      ETUS_PaperId INT,
      ETUS_PaperAddTime DATETIME2,
      ETUS_Score INT ,
      ETUS_State TINYINT
    )
AS 
    BEGIN
    
        INSERT  INTO @table
                SELECT  et_ept.ET_Id AS ETUS_TaskId ,
                        et_ept.ET_Name AS ETUS_TaskName ,
                        et_ept.ET_AutoType AS ETUS_TaskAutoType ,
                        et_ept.ET_StatisticType AS ETUS_TaskStatisticType ,
                        et_ept.EPT_Id AS ETUS_PaperTemplateId ,
                        et_ept.EPT_StartDate AS ETUS_Date ,
                        d.D_Id AS ETUS_DepartmentId ,
                        d.D_Name AS ETUS_DepartmentName ,
                        u_du.U_Id AS ETUS_UserId ,
                        u_du.U_Name AS ETUS_UserName ,
                        u_du.Du_Id AS ETUS_DutyId ,
                        u_du.Du_Name AS ETUS_DutyName ,
                        ep.EP_Id AS ETUS_PaperId,
                        ep.EP_AddTime AS ETUS_PaperAddTime,
                        ep.EP_Score AS ETUS_Score ,
                        ( CASE WHEN ep.EP_Score IS NULL THEN 1
                               ELSE CASE WHEN et_ept.ET_StatisticType = 1 THEN CASE WHEN ep.EP_Score >= et_ept.ET_TotalScore * 0.6 THEN 2
                                                                                    ELSE 3
                                                                               END
                                         WHEN et_ept.ET_StatisticType = 2 THEN CASE WHEN ep.EP_Score >= 60 THEN 2
                                                                                    ELSE 3
                                                                               END
                                         ELSE 0
                                    END
                          END ) AS ETUS_State /* 0δ���� 1δ���� 2�ϸ� 3δ�ϸ� */
                FROM    ( SELECT    *
                          FROM      ExaminationTasks et
                                    LEFT JOIN ( SELECT  EPT_Id ,
                                                        ET_Id AS ET_Id1 ,
                                                        EPT_StartDate
                                                FROM    ExaminationPaperTemplates
                                              ) ept ON et.ET_Id = ept.ET_Id1
                        ) et_ept
                        LEFT JOIN ExaminationTaskAttendees eta ON et_ept.ET_Id = eta.ET_Id
                        LEFT JOIN ( SELECT  *
                                    FROM    ( SELECT    U_Id ,
                                                        U_Name ,
                                                        Du_Id AS Du_Id1
                                              FROM      Users
                                            ) u
                                            LEFT JOIN Duties du ON u.Du_Id1 = du.Du_Id
                                  ) u_du ON eta.U_Id = u_du.U_Id
                        LEFT JOIN ExaminationPapers ep ON et_ept.EPT_Id = ep.EPT_Id
                                                          AND u_du.U_Id = ep.EP_UserId ,
                        User_Department ud ,
                        Departments d
                WHERE   et_ept.ET_Status = 1
                        AND u_du.U_Id IS NOT NULL
                        AND u_du.U_Id = ud.U_Id
                        AND ud.D_Id = d.D_Id
                
        RETURN;
    END
    
	GO

-- [4]�����ͼ
-- �����ͼ ExaminationTaskStatistic
USE OLS;

GO

IF OBJECT_ID ('ExaminationTaskStatistic', 'V') IS NOT NULL
DROP VIEW ExaminationTaskStatistic ;

GO

CREATE VIEW ExaminationTaskStatistic
AS
SELECT * FROM dbo.fn_GetExaminationTaskStatistic()

GO

-- �����ͼ ExaminationTaskUserStatistic
USE OLS;

GO

IF OBJECT_ID('ExaminationTaskUserStatistic', 'V') IS NOT NULL 
    DROP VIEW ExaminationTaskUserStatistic

GO

CREATE VIEW ExaminationTaskUserStatistic
AS
    SELECT  *
    FROM    dbo.fn_GetExaminationTaskUserStatistic()

GO

-- [5]�������
/*USE OLS;

GO

DELETE FROM dbo.ExaminationTaskTemplates;
DELETE FROM dbo.ExaminationPaperQuestions;
DELETE FROM dbo.ExaminationPapers;
DELETE FROM dbo.ExaminationPaperTemplateQuestions;
DELETE FROM dbo.ExaminationPaperTemplates;
DELETE FROM dbo.ExaminationTaskAttendees;
DELETE FROM dbo.ExaminationTasks;

GO*/