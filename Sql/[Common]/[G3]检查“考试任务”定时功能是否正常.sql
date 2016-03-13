USE OLS;

DECLARE @etName VARCHAR(50);
DECLARE @etId INT ,
    @eptId INT;

--SET @etName = '每日自动任务1';
--SET @etName = '每周自动任务2';
--SET @etName = '每月自动任务1';
--SET @etName = '测试考试任务';
SET @etName = '测试任务031303';

--UPDATE  dbo.ExaminationTasks
--SET     ET_StartTime = '1970-01-01 16:16:00.0000000' ,
--        ET_EndTime = '1970-01-01 16:20:00.0000000' ,
--        ET_Enabled = 1
--WHERE   ET_Name = @etName;

SELECT  @etId = ET_Id
FROM    ExaminationTasks
WHERE   ET_Name = @etName;
SELECT  ET_Name ,
        ET_Enabled ,
        ET_StartTime ,
        ET_EndTime,
        ET_TimeSpan ,
        ET_Attendee
FROM    ExaminationTasks
WHERE   ET_Name = @etName;

SELECT  @eptId = EPT_Id
FROM    dbo.ExaminationPaperTemplates
WHERE   ET_Id = @etId;
SELECT  ept.EPT_Id ,
        ept.EPT_PaperTemplateStatus ,
        ept.EPT_AddTime ,
        ept.EPT_StartTime ,
        ept.EPT_EndTime ,
        ept.EPT_TimeSpan ,
        ep.EP_PaperStatus ,
        ep.EP_Id ,
        ep.EP_Score ,
        ep.EP_AddTime ,
        ep.EP_EndTime
FROM    dbo.ExaminationPaperTemplates ept
        LEFT JOIN dbo.ExaminationPapers ep ON ept.EPT_Id = ep.EPT_Id
WHERE   ept.ET_Id = @etId;

--SELECT EP_PaperStatus, EP_Id, ET_Id, EP_Score, EP_AddTime FROM dbo.ExaminationPapers WHERE EPT_Id = @eptId;