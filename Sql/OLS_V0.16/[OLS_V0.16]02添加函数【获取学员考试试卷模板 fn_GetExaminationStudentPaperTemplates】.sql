USE OLS;

GO

IF OBJECT_ID(N'dbo.fn_GetExaminationStudentPaperTemplate', 'TF') IS NOT NULL 
    DROP FUNCTION dbo.fn_GetExaminationStudentPaperTemplate;

GO

CREATE FUNCTION dbo.fn_GetExaminationStudentPaperTemplate ( )
RETURNS @table TABLE
    (
      ESPT_TaskId INT NOT NULL ,
      ESPT_TaskName NVARCHAR(50) NOT NULL ,
      ESPT_TaskType TINYINT NOT NULL ,
      ESPT_UserId INT NOT NULL ,
      ESPT_PaperTemplateId INT NOT NULL ,
      ESPT_PaperTemplateStatus TINYINT NOT NULL ,
      ESPT_PaperTemplateStartTime DATETIME2 NOT NULL ,
      ESPT_PaperTemplateTimeSpan INT NOT NULL ,
      ESPT_PaperTemplateAddTime DATETIME2 NOT NULL ,
      ESPT_PaperTemplateRemark NVARCHAR(50) NULL ,
      ESPT_PaperId INT NULL ,
      ESPT_PaperStatus TINYINT NULL ,
      ESPT_PaperScore NVARCHAR(10) NULL ,
      ESPT_PageType TINYINT NOT NULL
    )
AS 
    BEGIN
	
        INSERT  INTO @table
                SELECT  et.ET_Id ESPT_TaskId ,
                        et.ET_Name ESPT_TaskName ,
                        et.ET_Type ESPT_TaskType ,
                        u.U_Id ESPT_UserId ,
                        ept.EPT_Id SPT_PaperTemplateId ,
                        ept.EPT_PaperTemplateStatus ESPT_PaperTemplateStatus ,
                        ept.EPT_StartTime ESPT_PaperTemplateStartTime ,
                        ept.EPT_TimeSpan ESPT_PaperTemplateTimeSpan ,
                        ept.EPT_AddTime ESPT_PaperTemplateAddTime ,
                        ept.EPT_Remark ESPT_PaperTemplateRemark ,
                        ep.EP_Id ESPT_PaperId ,
                        ep.EP_PaperStatus ESPT_PaperStatus ,
                        CASE 
                          WHEN ep.EP_Score IS NULL THEN '[δ����]'
                          WHEN ep.EP_Score = -1 THEN '[δ����]'
                          ELSE CASE et.ET_StatisticType
                                 WHEN 1 THEN CAST(ep.EP_Score AS VARCHAR(10)) + '��'
                                 WHEN 2 THEN CAST(ep.EP_Score AS VARCHAR(10)) + '%'
                                 ELSE '[δԤ��]'
                               END
                        END ESPT_PaperScore ,
                        CASE WHEN ep.EP_Id IS NULL
                                  AND ept.EPT_PaperTemplateStatus = 1 THEN 1
                             WHEN ep.EP_PaperStatus = 1 THEN 1
                             ELSE 2
                        END ESPT_PageType -- ��δ���ԡ����ڿ���ʱ������¼��Ϊ��δ���ꡱҳ������
                FROM    dbo.ExaminationTasks et
                        LEFT JOIN dbo.ExaminationPaperTemplates ept ON et.ET_Id = ept.ET_Id
                        LEFT JOIN dbo.ExaminationTaskAttendees eta ON et.ET_Id = eta.ET_Id
                        LEFT JOIN dbo.Users u ON eta.U_Id = u.U_Id
                        LEFT JOIN dbo.ExaminationPapers ep ON ept.EPT_Id = ep.EPT_Id
                                                              AND u.U_Id = ep.EP_UserId
                WHERE   et.ET_Status = 1
                        AND ept.EPT_Id IS NOT NULL
                        AND ept.EPT_PaperTemplateStatus <> 0 -- ��ȡδ��ʼ���Ծ�ģ��
        RETURN;
    END

GO

IF OBJECT_ID(N'dbo.ExaminationStudentPaperTemplates', 'V') IS NOT NULL 
    DROP VIEW dbo.ExaminationStudentPaperTemplates;

GO

CREATE VIEW dbo.ExaminationStudentPaperTemplates
AS
    SELECT  *
    FROM    dbo.fn_GetExaminationStudentPaperTemplate()

GO