USE [OLS]

GO

SET IDENTITY_INSERT [dbo].[ExaminationTaskTemplates] ON
INSERT [dbo].[ExaminationTaskTemplates] ([ETT_Id], [ETT_AutoId], [ETT_Name], [ETT_Type], [ETT_Mode], [ETT_DifficultyCoefficient], [ETT_ParticipatingDepartment], [ETT_Attendee], [ETT_AutoType], [ETT_AutoOffsetDay], [ETT_StartTime], [ETT_EndTime], [ETT_TimeSpan], [ETT_Remark], [ETT_AddTime], [ETT_Status], [ETT_StatisticType], [ETT_TotalScore], [ETT_TotalNumber], [ETT_AutoClassifies], [ETT_AutoRatio]) VALUES (1, 1, N'手动任务模板1', 0, 0, 0, N'[9]', N'[39,40,41,42,43,44,45]', 0, 0, CAST(0x0700000000003AF90A AS DateTime2), CAST(0x0700000000003AF90A AS DateTime2), 30, NULL, CAST(0x0780E0986280D33A0B AS DateTime2), 1, 1, 100, 10, N'[]', N'[{"type":"单选题","percent":0.2},{"type":"多选题","percent":0.2},{"type":"判断题","percent":0.2},{"type":"公文改错题","percent":0.1},{"type":"计算题","percent":0.1},{"type":"案例分析题","percent":0.1},{"type":"问答题","percent":0.1}]')
INSERT [dbo].[ExaminationTaskTemplates] ([ETT_Id], [ETT_AutoId], [ETT_Name], [ETT_Type], [ETT_Mode], [ETT_DifficultyCoefficient], [ETT_ParticipatingDepartment], [ETT_Attendee], [ETT_AutoType], [ETT_AutoOffsetDay], [ETT_StartTime], [ETT_EndTime], [ETT_TimeSpan], [ETT_Remark], [ETT_AddTime], [ETT_Status], [ETT_StatisticType], [ETT_TotalScore], [ETT_TotalNumber], [ETT_AutoClassifies], [ETT_AutoRatio]) VALUES (2, 2, N'每日自动任务1', 0, 1, 0, N'[9]', N'[39,40,41,42,43,44,45]', 1, 0, CAST(0x070010ACD1533AF90A AS DateTime2), CAST(0x0700000000003AF90A AS DateTime2), 30, NULL, CAST(0x0700AFCD7F80D33A0B AS DateTime2), 1, 1, 100, 10, N'[]', N'[{"type":"单选题","percent":0.2},{"type":"多选题","percent":0.2},{"type":"判断题","percent":0.2},{"type":"公文改错题","percent":0.1},{"type":"计算题","percent":0.1},{"type":"案例分析题","percent":0.1},{"type":"问答题","percent":0.1}]')
INSERT [dbo].[ExaminationTaskTemplates] ([ETT_Id], [ETT_AutoId], [ETT_Name], [ETT_Type], [ETT_Mode], [ETT_DifficultyCoefficient], [ETT_ParticipatingDepartment], [ETT_Attendee], [ETT_AutoType], [ETT_AutoOffsetDay], [ETT_StartTime], [ETT_EndTime], [ETT_TimeSpan], [ETT_Remark], [ETT_AddTime], [ETT_Status], [ETT_StatisticType], [ETT_TotalScore], [ETT_TotalNumber], [ETT_AutoClassifies], [ETT_AutoRatio]) VALUES (3, 3, N'每周自动任务1', 0, 1, 0, N'[9]', N'[39,40,41,42,43,44,45]', 2, 3, CAST(0x070010ACD1533AF90A AS DateTime2), CAST(0x0700000000003AF90A AS DateTime2), 30, NULL, CAST(0x070022C2A480D33A0B AS DateTime2), 1, 1, 100, 10, N'[]', N'[{"type":"单选题","percent":0.2},{"type":"多选题","percent":0.2},{"type":"判断题","percent":0.2},{"type":"公文改错题","percent":0.1},{"type":"计算题","percent":0.1},{"type":"案例分析题","percent":0.1},{"type":"问答题","percent":0.1}]')
INSERT [dbo].[ExaminationTaskTemplates] ([ETT_Id], [ETT_AutoId], [ETT_Name], [ETT_Type], [ETT_Mode], [ETT_DifficultyCoefficient], [ETT_ParticipatingDepartment], [ETT_Attendee], [ETT_AutoType], [ETT_AutoOffsetDay], [ETT_StartTime], [ETT_EndTime], [ETT_TimeSpan], [ETT_Remark], [ETT_AddTime], [ETT_Status], [ETT_StatisticType], [ETT_TotalScore], [ETT_TotalNumber], [ETT_AutoClassifies], [ETT_AutoRatio]) VALUES (4, 4, N'每月自动任务1', 0, 1, 0, N'[9]', N'[39,40,41,42,43,44,45]', 3, 3, CAST(0x070010ACD1533AF90A AS DateTime2), CAST(0x0700000000003AF90A AS DateTime2), 30, NULL, CAST(0x0700D3CABD80D33A0B AS DateTime2), 1, 1, 100, 10, N'[]', N'[{"type":"单选题","percent":0.2},{"type":"多选题","percent":0.2},{"type":"判断题","percent":0.2},{"type":"公文改错题","percent":0.1},{"type":"计算题","percent":0.1},{"type":"案例分析题","percent":0.1},{"type":"问答题","percent":0.1}]')
SET IDENTITY_INSERT [dbo].[ExaminationTaskTemplates] OFF

GO
