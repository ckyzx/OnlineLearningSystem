USE OLS;

GO

BEGIN
DECLARE @pcId INT ,
    @pId INT;

SELECT  @pcId = 6;
SELECT  @pId = MAX(P_Id) + 1
FROM    dbo.[Permissions]

-- ���Ȩ��ֵ
SET IDENTITY_INSERT [dbo].[Permissions] ON

INSERT  [dbo].[Permissions]
        ( P_Id ,
          P_AutoId ,
          PC_Id ,
          P_Name ,
          P_Controller ,
          P_Action ,
          P_Remark ,
          P_AddTime
        )
VALUES  ( @pId ,
          @pId ,
          @pcId ,
          N'���������б�ѧԱ��̨' ,
          N'ExaminationTask' ,
          N'ListStudent' ,
          NULL ,
          CAST(0x079DAEB04D8BAB3A0B AS DATETIME2)
        )

SET @pId = @pId + 1;
INSERT  [dbo].[Permissions]
        ( P_Id ,
          P_AutoId ,
          PC_Id ,
          P_Name ,
          P_Controller ,
          P_Action ,
          P_Remark ,
          P_AddTime
        )
VALUES  ( @pId ,
          @pId ,
          @pcId ,
          N'������ϰ' ,
          N'ExaminationTask' ,
          N'EnterExercise' ,
          NULL ,
          CAST(0x079DAEB04D8BAB3A0B AS DATETIME2)
        )
        
SET @pId = @pId + 1;
INSERT  [dbo].[Permissions]
        ( P_Id ,
          P_AutoId ,
          PC_Id ,
          P_Name ,
          P_Controller ,
          P_Action ,
          P_Remark ,
          P_AddTime
        )
VALUES  ( @pId ,
          @pId ,
          @pcId ,
          N'��ѯ��������' ,
          N'ExaminationTask' ,
          N'ListDataTablesAjaxByType' ,
          NULL ,
          CAST(0x079DAEB04D8BAB3A0B AS DATETIME2)
        )
SET IDENTITY_INSERT [dbo].[Permissions] OFF
END

GO
