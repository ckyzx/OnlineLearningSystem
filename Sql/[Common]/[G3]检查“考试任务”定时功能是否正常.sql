USE OLS;

DECLARE @etName VARCHAR(50);
DECLARE @etId INT ,
    @eptId INT;

SET @etName = '预定任务032607';

--UPDATE  dbo.ExaminationTasks
--SET     ET_StartTime = '1970-01-01 16:16:00.0000000' ,
--        ET_EndTime = '1970-01-01 16:20:00.0000000' ,
--        ET_Enabled = 1
--WHERE   ET_Name = @etName;

SELECT  @etId = ET_Id
FROM    ExaminationTasks
WHERE   ET_Name = @etName;
SELECT  ET_Name ,
        CASE ET_Enabled
          WHEN 0 THEN '初始'
          WHEN 1 THEN '开启'
          WHEN 2 THEN '关闭'
          ELSE '...'
        END 任务状态 ,
        CONVERT(VARCHAR(100), ET_StartTime, 120) 开始时间 ,
        CONVERT(VARCHAR(100), ET_EndTime, 120) 结束时间 ,
        ET_ContinuedDays ,
        ET_TimeSpan ,
        ET_Attendee
FROM    ExaminationTasks
WHERE   ET_Name = @etName;

SELECT  @eptId = EPT_Id
FROM    dbo.ExaminationPaperTemplates
WHERE   ET_Id = @etId;
SELECT  ept.EPT_Id ,
        CASE ept.EPT_PaperTemplateStatus
          WHEN 0 THEN '未开始'
          WHEN 1 THEN '进行中'
          WHEN 2 THEN '已关闭'
          ELSE '...'
        END 模板状态 ,
        CONVERT(VARCHAR(100), ept.EPT_AddTime, 120) 添加时间 ,
        CONVERT(VARCHAR(100), ept.EPT_StartTime, 120) 开始时间 ,
        CONVERT(VARCHAR(100), ept.EPT_EndTime, 120) 结束时间 ,
        ept.EPT_TimeSpan ,
        CASE ep.EP_PaperStatus
          WHEN 0 THEN '未开始'
          WHEN 1 THEN '进行中'
          WHEN 2 THEN '已关闭'
          ELSE '...'
        END 试卷状态 ,
        ep.EP_Id ,
        ep.EP_Score ,
        CONVERT(VARCHAR(100), ep.EP_AddTime, 120) 添加时间 ,
        CONVERT(VARCHAR(100), ep.EP_EndTime, 120) 结束时间
FROM    dbo.ExaminationPaperTemplates ept
        LEFT JOIN dbo.ExaminationPapers ep ON ept.EPT_Id = ep.EPT_Id
WHERE   ept.ET_Id = @etId;

--SELECT EP_PaperStatus, EP_Id, ET_Id, EP_Score, EP_AddTime FROM dbo.ExaminationPapers WHERE EPT_Id = @eptId;