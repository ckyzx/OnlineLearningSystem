USE OLS;

GO

IF OBJECT_ID(N'dbo.UserScoreDetailToExcel', 'V') IS NOT NULL 
    DROP VIEW dbo.UserScoreDetailToExcel;
GO

CREATE VIEW dbo.UserScoreDetailToExcel
AS
    SELECT  USD_UserId,
			USD_UserName,
			USD_DepartmentId,
			USD_DepartmentName,
			USD_TaskName,
			USD_StartTime,
			USD_PaperId,
			CASE WHEN USD_PaperId = 0 THEN '' ELSE CAST(USD_PaperId AS NVARCHAR(20)) END �Ծ���,
			USD_TaskName �������� ,
            CONVERT(VARCHAR(20), USD_StartTime, 20) ����ʱ�� ,
            CASE USD_TaskStatisticType
              WHEN 1 THEN '�÷�'
              WHEN 2 THEN '��ȷ��'
              ELSE '[δ����]'
            END �ɼ����� ,
            CASE USD_Score
              WHEN -1 THEN ''
              ELSE CASE USD_TaskStatisticType
                     WHEN 1 THEN CAST(USD_Score AS VARCHAR(10)) + '��'
                     WHEN 2 THEN CAST(USD_Score AS VARCHAR(10)) + '%'
                     ELSE ''
                   END
            END �ɼ� ,
            CASE USD_State
              WHEN 1 THEN 'δ����'
              WHEN 2 THEN 'δ���'
              WHEN 3 THEN '�ϸ�'
              WHEN 4 THEN 'δ�ϸ�'
              ELSE 'δ����'--'[δ����]'
            END ״̬
    FROM    dbo.fn_GetUserScoreDetail()

GO
