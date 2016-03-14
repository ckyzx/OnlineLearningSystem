USE OLS;

GO

IF OBJECT_ID(N'dbo.UserStatisticToExcel') IS NOT NULL 
    DROP VIEW dbo.UserStatisticToExcel;

GO

CREATE VIEW dbo.UserStatisticToExcel
AS
    SELECT  ETUS_PaperTemplateId ,
            ETUS_DepartmentName ���� ,
            ETUS_UserName �û� ,
            ETUS_DutyName ְ�� ,
            CASE ETUS_Score
              WHEN -1 THEN ''
              ELSE CAST(ETUS_Score AS VARCHAR(5))
            END �ɼ� ,
            CASE ETUS_State
              WHEN 0 THEN '[δ����]'
              WHEN 1 THEN 'δ����'
              WHEN 2 THEN '�ϸ�'
              WHEN 3 THEN 'δ�ϸ�'
              WHEN 4 THEN 'δ���'
            END ״̬
    FROM    dbo.fn_GetExaminationTaskUserStatistic()

GO
