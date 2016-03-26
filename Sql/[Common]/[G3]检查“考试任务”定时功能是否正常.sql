USE OLS;

DECLARE @etName VARCHAR(50);
DECLARE @etId INT ,
    @eptId INT;

SET @etName = 'Ԥ������032607';

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
          WHEN 0 THEN '��ʼ'
          WHEN 1 THEN '����'
          WHEN 2 THEN '�ر�'
          ELSE '...'
        END ����״̬ ,
        CONVERT(VARCHAR(100), ET_StartTime, 120) ��ʼʱ�� ,
        CONVERT(VARCHAR(100), ET_EndTime, 120) ����ʱ�� ,
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
          WHEN 0 THEN 'δ��ʼ'
          WHEN 1 THEN '������'
          WHEN 2 THEN '�ѹر�'
          ELSE '...'
        END ģ��״̬ ,
        CONVERT(VARCHAR(100), ept.EPT_AddTime, 120) ���ʱ�� ,
        CONVERT(VARCHAR(100), ept.EPT_StartTime, 120) ��ʼʱ�� ,
        CONVERT(VARCHAR(100), ept.EPT_EndTime, 120) ����ʱ�� ,
        ept.EPT_TimeSpan ,
        CASE ep.EP_PaperStatus
          WHEN 0 THEN 'δ��ʼ'
          WHEN 1 THEN '������'
          WHEN 2 THEN '�ѹر�'
          ELSE '...'
        END �Ծ�״̬ ,
        ep.EP_Id ,
        ep.EP_Score ,
        CONVERT(VARCHAR(100), ep.EP_AddTime, 120) ���ʱ�� ,
        CONVERT(VARCHAR(100), ep.EP_EndTime, 120) ����ʱ��
FROM    dbo.ExaminationPaperTemplates ept
        LEFT JOIN dbo.ExaminationPapers ep ON ept.EPT_Id = ep.EPT_Id
WHERE   ept.ET_Id = @etId;

--SELECT EP_PaperStatus, EP_Id, ET_Id, EP_Score, EP_AddTime FROM dbo.ExaminationPapers WHERE EPT_Id = @eptId;