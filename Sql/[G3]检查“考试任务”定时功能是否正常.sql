USE OLS;

DECLARE @etName VARCHAR(50);
DECLARE @etId INT, @eptId INT;

SET @etName = 'ÿ���Զ�����7';
--SET @etName = 'ÿ���Զ�����2';
--SET @etName = 'ÿ���Զ�����1';

SELECT @etId = ET_Id FROM ExaminationTasks WHERE ET_Name = @etName;
SELECT ET_Name, ET_Enabled, ET_StartTime, ET_TimeSpan FROM ExaminationTasks WHERE ET_Name = @etName;

SELECT @eptId = EPT_Id FROM dbo.ExaminationPaperTemplates WHERE ET_Id = @etId;
SELECT EPT_PaperTemplateStatus, EPT_Id FROM dbo.ExaminationPaperTemplates WHERE ET_Id = @etId;

SELECT EP_PaperStatus, ET_Id, EP_Score FROM dbo.ExaminationPapers WHERE EPT_Id = @eptId;