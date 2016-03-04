USE OLS;

GO

IF OBJECT_ID(N'dbo.TaskStatisticToExcel') IS NOT NULL
	DROP VIEW dbo.TaskStatisticToExcel;

GO

CREATE VIEW dbo.TaskStatisticToExcel
AS
    SELECT  ETS_TaskName ,
			ETS_PaperTemplateId,
            ETS_PaperTemplateId ���Ա��,
            ETS_TaskName ��������,
            ETS_PaperTemplateDate ��������,
            ETS_AttendeeNumber Ӧ��,
            ETS_PaperNumber �ѿ�,
            ETS_PassNumber �ϸ�,
            ETS_FlunkNumber δ�ϸ�
    FROM    dbo.fn_GetExaminationTaskStatistic()