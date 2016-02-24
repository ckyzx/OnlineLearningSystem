USE OLS;

DECLARE @etName VARCHAR(50);
DECLARE @etId INT ,
    @eptId INT;

--SET @etName = 'ÿ���Զ�����1';
--SET @etName = 'ÿ���Զ�����2';
--SET @etName = 'ÿ���Զ�����1';
SET @etName = '���Կ�������3';

SELECT  @etId = ET_Id
FROM    ExaminationTasks
WHERE   ET_Name = @etName;
SELECT  ET_Name ,
        ET_Enabled ,
        ET_StartTime ,
        ET_TimeSpan
FROM    ExaminationTasks
WHERE   ET_Name = @etName;

SELECT  @eptId = EPT_Id
FROM    dbo.ExaminationPaperTemplates
WHERE   ET_Id = @etId;
SELECT  ept.EPT_PaperTemplateStatus ,
        ept.EPT_Id ,
        ept.EPT_AddTime ,
        ep.EP_PaperStatus ,
        ep.EP_Id ,
        ep.EP_Score ,
        ep.EP_AddTime
FROM    dbo.ExaminationPaperTemplates ept
        LEFT JOIN dbo.ExaminationPapers ep ON ept.EPT_Id = ep.EPT_Id
WHERE   ept.ET_Id = @etId;

--SELECT EP_PaperStatus, EP_Id, ET_Id, EP_Score, EP_AddTime FROM dbo.ExaminationPapers WHERE EPT_Id = @eptId;