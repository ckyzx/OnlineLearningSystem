USE OLS;

GO

/* ��ӡ�ϵͳ��־����ɫȨ�� */
/*-- ���Ȩ��Ŀ¼
SET IDENTITY_INSERT dbo.PermissionCategories ON

INSERT  INTO dbo.PermissionCategories
        ( PC_Id ,
          PC_AutoId ,
          PC_Name ,
          PC_Level ,
          PC_Remark ,
          PC_AddTime ,
          PC_Status
        )
VALUES  ( 12 ,
          12 ,
          '��־����' ,
          '0012' ,
          NULL ,
          CAST(0x079DAEB04D8BAB3A0B AS DATETIME2) ,
          1
        )

SET IDENTITY_INSERT dbo.PermissionCategories OFF

GO

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
VALUES  ( 133 ,
          133 ,
          12 ,
          N'ϵͳ��־�б�' ,
          N'SystemLog' ,
          N'List' ,
          NULL ,
          CAST(0x079DAEB04D8BAB3A0B AS DATETIME2)
        )
        
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
VALUES  ( 134 ,
          134 ,
          12 ,
          N'��ѯϵͳ��־' ,
          N'SystemLog' ,
          N'ListDataTablesAjax' ,
          NULL ,
          CAST(0x079DAEB04D8BAB3A0B AS DATETIME2)
        )
                
SET IDENTITY_INSERT [dbo].[Permissions] OFF

-- ��ӹ�����¼
INSERT  [dbo].[Role_Permission]
        SELECT  1 ,
                133
        UNION ALL
        SELECT  1 ,
                134

GO*/

/* ��ӡ���ѯ��������Ȩ�� */
/*-- ���Ȩ��ֵ
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
VALUES  ( 135 ,
          135 ,
          9 ,
          N'��ѯ��������' ,
          N'ExaminationTask' ,
          N'ListDataTablesAjaxByMode' ,
          NULL ,
          CAST(0x079DAEB04D8BAB3A0B AS DATETIME2)
        )
                
SET IDENTITY_INSERT [dbo].[Permissions] OFF

GO

-- ��ӹ�����¼
INSERT  [dbo].[Role_Permission]
        SELECT  1 ,
                135

GO*/

/* ��ӡ�����Ŀ¼��Ȩ�� */
-- ���Ȩ��Ŀ¼
SET IDENTITY_INSERT dbo.PermissionCategories ON

INSERT  INTO PermissionCategories
        ( PC_Id ,
          PC_AutoId ,
          PC_Name ,
          PC_Level ,
          PC_Remark ,
          PC_AddTime ,
          PC_Status
        )
VALUES  ( 13 ,
          13 ,
          '���Ͽ����' ,
          '0013' ,
          NULL ,
          CAST(0x079DAEB04D8BAB3A0B AS DATETIME2) ,
          1
        )

SET IDENTITY_INSERT dbo.PermissionCategories OFF

-- ���Ȩ��ֵ
SET IDENTITY_INSERT [dbo].[Permissions] ON

INSERT  INTO [dbo].[Permissions]
        ( P_Id ,
          P_AutoId ,
          PC_Id ,
          P_Name ,
          P_Controller ,
          P_Action ,
          P_Remark ,
          P_AddTime
        )
VALUES  ( 136 ,
          136 ,
          13 ,
          N'����Ŀ¼�б�' ,
          N'LearningDataCategory' ,
          N'List' ,
          NULL ,
          CAST(0x079DAEB04D8BAB3A0B AS DATETIME2)
        )

INSERT  INTO [dbo].[Permissions]
        ( P_Id ,
          P_AutoId ,
          PC_Id ,
          P_Name ,
          P_Controller ,
          P_Action ,
          P_Remark ,
          P_AddTime
        )
VALUES  ( 137 ,
          137 ,
          13 ,
          N'��ѯ����Ŀ¼' ,
          N'LearningDataCategory' ,
          N'ListDataTablesAjax' ,
          NULL ,
          CAST(0x079DAEB04D8BAB3A0B AS DATETIME2)
        )

INSERT  INTO [dbo].[Permissions]
        ( P_Id ,
          P_AutoId ,
          PC_Id ,
          P_Name ,
          P_Controller ,
          P_Action ,
          P_Remark ,
          P_AddTime
        )
VALUES  ( 138 ,
          138 ,
          13 ,
          '�½�����Ŀ¼' ,
          'LearningDataCategory' ,
          'Create' ,
          NULL ,
          CAST(0x079DAEB04D8BAB3A0B AS DATETIME2)
        )
INSERT  INTO [dbo].[Permissions]
        ( P_Id ,
          P_AutoId ,
          PC_Id ,
          P_Name ,
          P_Controller ,
          P_Action ,
          P_Remark ,
          P_AddTime
        )
VALUES  ( 139 ,
          139 ,
          13 ,
          '�������Ŀ¼' ,
          'LearningDataCategory' ,
          'Create' ,
          NULL ,
          CAST(0x079DAEB04D8BAB3A0B AS DATETIME2)
        )
INSERT  INTO [dbo].[Permissions]
        ( P_Id ,
          P_AutoId ,
          PC_Id ,
          P_Name ,
          P_Controller ,
          P_Action ,
          P_Remark ,
          P_AddTime
        )
VALUES  ( 140 ,
          140 ,
          13 ,
          '�鿴����Ŀ¼' ,
          'LearningDataCategory' ,
          'Edit' ,
          NULL ,
          CAST(0x079DAEB04D8BAB3A0B AS DATETIME2)
        )
INSERT  INTO [dbo].[Permissions]
        ( P_Id ,
          P_AutoId ,
          PC_Id ,
          P_Name ,
          P_Controller ,
          P_Action ,
          P_Remark ,
          P_AddTime
        )
VALUES  ( 141 ,
          141 ,
          13 ,
          '�޸�����Ŀ¼' ,
          'LearningDataCategory' ,
          'Edit' ,
          NULL ,
          CAST(0x079DAEB04D8BAB3A0B AS DATETIME2)
        )
INSERT  INTO [dbo].[Permissions]
        ( P_Id ,
          P_AutoId ,
          PC_Id ,
          P_Name ,
          P_Controller ,
          P_Action ,
          P_Remark ,
          P_AddTime
        )
VALUES  ( 142 ,
          142 ,
          13 ,
          '��������Ŀ¼' ,
          'LearningDataCategory' ,
          'Recycle' ,
          NULL ,
          CAST(0x079DAEB04D8BAB3A0B AS DATETIME2)
        )
INSERT  INTO [dbo].[Permissions]
        ( P_Id ,
          P_AutoId ,
          PC_Id ,
          P_Name ,
          P_Controller ,
          P_Action ,
          P_Remark ,
          P_AddTime
        )
VALUES  ( 143 ,
          143 ,
          13 ,
          '�ָ�����Ŀ¼' ,
          'LearningDataCategory' ,
          'Resume' ,
          NULL ,
          CAST(0x079DAEB04D8BAB3A0B AS DATETIME2)
        )
INSERT  INTO [dbo].[Permissions]
        ( P_Id ,
          P_AutoId ,
          PC_Id ,
          P_Name ,
          P_Controller ,
          P_Action ,
          P_Remark ,
          P_AddTime
        )
VALUES  ( 144 ,
          144 ,
          13 ,
          'ɾ������Ŀ¼' ,
          'LearningDataCategory' ,
          'Delete' ,
          NULL ,
          CAST(0x079DAEB04D8BAB3A0B AS DATETIME2)
        )

INSERT  INTO [dbo].[Permissions]
        ( P_Id ,
          P_AutoId ,
          PC_Id ,
          P_Name ,
          P_Controller ,
          P_Action ,
          P_Remark ,
          P_AddTime
        )
VALUES  ( 145 ,
          145 ,
          13 ,
          '�������Ŀ¼����' ,
          'LearningDataCategory' ,
          'DuplicateName' ,
          NULL ,
          CAST(0x079DAEB04D8BAB3A0B AS DATETIME2)
        )

INSERT  INTO [dbo].[Permissions]
        ( P_Id ,
          P_AutoId ,
          PC_Id ,
          P_Name ,
          P_Controller ,
          P_Action ,
          P_Remark ,
          P_AddTime
        )
VALUES  ( 146 ,
          146 ,
          13 ,
          '����Ŀ¼����' ,
          'LearningDataCategory' ,
          'Sort' ,
          NULL ,
          CAST(0x079DAEB04D8BAB3A0B AS DATETIME2)
        )

SET IDENTITY_INSERT [dbo].[Permissions] OFF

GO

-- ��ӹ�����¼
DELETE  FROM dbo.Role_Permission
WHERE   R_Id = 1;
INSERT  [dbo].[Role_Permission]
        SELECT  1 ,
                P_Id
        FROM    dbo.[Permissions]

GO

/* ��ӡ����ϡ�Ȩ�� */
-- ���Ȩ��ֵ
SET IDENTITY_INSERT [dbo].[Permissions] ON

INSERT  INTO [dbo].[Permissions]
        ( P_Id ,
          P_AutoId ,
          PC_Id ,
          P_Name ,
          P_Controller ,
          P_Action ,
          P_Remark ,
          P_AddTime
        )
VALUES  ( 147 ,
          147 ,
          13 ,
          N'�����б�' ,
          N'LearningData' ,
          N'List' ,
          NULL ,
          CAST(0x079DAEB04D8BAB3A0B AS DATETIME2)
        )

INSERT  INTO [dbo].[Permissions]
        ( P_Id ,
          P_AutoId ,
          PC_Id ,
          P_Name ,
          P_Controller ,
          P_Action ,
          P_Remark ,
          P_AddTime
        )
VALUES  ( 148 ,
          148 ,
          13 ,
          N'��ѯ����' ,
          N'LearningData' ,
          N'ListDataTablesAjax' ,
          NULL ,
          CAST(0x079DAEB04D8BAB3A0B AS DATETIME2)
        )

INSERT  INTO [dbo].[Permissions]
        ( P_Id ,
          P_AutoId ,
          PC_Id ,
          P_Name ,
          P_Controller ,
          P_Action ,
          P_Remark ,
          P_AddTime
        )
VALUES  ( 149 ,
          149 ,
          13 ,
          '�½�����' ,
          'LearningData' ,
          'Create' ,
          NULL ,
          CAST(0x079DAEB04D8BAB3A0B AS DATETIME2)
        )
INSERT  INTO [dbo].[Permissions]
        ( P_Id ,
          P_AutoId ,
          PC_Id ,
          P_Name ,
          P_Controller ,
          P_Action ,
          P_Remark ,
          P_AddTime
        )
VALUES  ( 150 ,
          150 ,
          13 ,
          '�������' ,
          'LearningData' ,
          'Create' ,
          NULL ,
          CAST(0x079DAEB04D8BAB3A0B AS DATETIME2)
        )
INSERT  INTO [dbo].[Permissions]
        ( P_Id ,
          P_AutoId ,
          PC_Id ,
          P_Name ,
          P_Controller ,
          P_Action ,
          P_Remark ,
          P_AddTime
        )
VALUES  ( 151 ,
          151 ,
          13 ,
          '�鿴����' ,
          'LearningData' ,
          'Edit' ,
          NULL ,
          CAST(0x079DAEB04D8BAB3A0B AS DATETIME2)
        )
INSERT  INTO [dbo].[Permissions]
        ( P_Id ,
          P_AutoId ,
          PC_Id ,
          P_Name ,
          P_Controller ,
          P_Action ,
          P_Remark ,
          P_AddTime
        )
VALUES  ( 152 ,
          152 ,
          13 ,
          '�޸�����' ,
          'LearningData' ,
          'Edit' ,
          NULL ,
          CAST(0x079DAEB04D8BAB3A0B AS DATETIME2)
        )
INSERT  INTO [dbo].[Permissions]
        ( P_Id ,
          P_AutoId ,
          PC_Id ,
          P_Name ,
          P_Controller ,
          P_Action ,
          P_Remark ,
          P_AddTime
        )
VALUES  ( 153 ,
          153 ,
          13 ,
          '��������' ,
          'LearningData' ,
          'Recycle' ,
          NULL ,
          CAST(0x079DAEB04D8BAB3A0B AS DATETIME2)
        )
INSERT  INTO [dbo].[Permissions]
        ( P_Id ,
          P_AutoId ,
          PC_Id ,
          P_Name ,
          P_Controller ,
          P_Action ,
          P_Remark ,
          P_AddTime
        )
VALUES  ( 154 ,
          154 ,
          13 ,
          '�ָ�����' ,
          'LearningData' ,
          'Resume' ,
          NULL ,
          CAST(0x079DAEB04D8BAB3A0B AS DATETIME2)
        )
INSERT  INTO [dbo].[Permissions]
        ( P_Id ,
          P_AutoId ,
          PC_Id ,
          P_Name ,
          P_Controller ,
          P_Action ,
          P_Remark ,
          P_AddTime
        )
VALUES  ( 155 ,
          155 ,
          13 ,
          'ɾ������' ,
          'LearningData' ,
          'Delete' ,
          NULL ,
          CAST(0x079DAEB04D8BAB3A0B AS DATETIME2)
        )

INSERT  INTO [dbo].[Permissions]
        ( P_Id ,
          P_AutoId ,
          PC_Id ,
          P_Name ,
          P_Controller ,
          P_Action ,
          P_Remark ,
          P_AddTime
        )
VALUES  ( 156 ,
          156 ,
          13 ,
          '������ϱ���' ,
          'LearningData' ,
          'DuplicateName' ,
          NULL ,
          CAST(0x079DAEB04D8BAB3A0B AS DATETIME2)
        )

INSERT  INTO [dbo].[Permissions]
        ( P_Id ,
          P_AutoId ,
          PC_Id ,
          P_Name ,
          P_Controller ,
          P_Action ,
          P_Remark ,
          P_AddTime
        )
VALUES  ( 157 ,
          157 ,
          13 ,
          '��������' ,
          'LearningData' ,
          'Sort' ,
          NULL ,
          CAST(0x079DAEB04D8BAB3A0B AS DATETIME2)
        )

SET IDENTITY_INSERT [dbo].[Permissions] OFF

GO

-- ��ӹ�����¼
DELETE  FROM dbo.Role_Permission
WHERE   R_Id = 1;
INSERT  [dbo].[Role_Permission]
        SELECT  1 ,
                P_Id
        FROM    dbo.[Permissions]

GO

-- ���½�ɫ��¼
DECLARE @table TABLE ( PC_Id INT );
DECLARE @table1 TABLE ( P_Id INT );
DECLARE @pcs VARCHAR(500) ,
    @ps VARCHAR(2000);
DECLARE @id INT;

SET @pcs = '';
SET @ps = '';

INSERT  INTO @table
        SELECT  PC_Id
        FROM    dbo.PermissionCategories
        ORDER BY PC_Id ASC;

WHILE ( SELECT  COUNT(PC_Id)
        FROM    @table
      ) > 0 
    BEGIN
        SELECT TOP 1
                @id = PC_Id
        FROM    @table
        ORDER BY PC_Id ASC;
        DELETE  FROM @table
        WHERE   PC_Id = @id;
        SET @pcs = @pcs + CAST(@id AS VARCHAR(5)) + ',';
    END

SET @pcs = '[' + STUFF(@pcs, LEN(@pcs), 1, ']');

INSERT  INTO @table1
        SELECT  P_Id
        FROM    dbo.[Permissions]
        ORDER BY P_Id ASC

WHILE ( SELECT  COUNT(P_Id)
        FROM    @table1
      ) > 0 
    BEGIN
        SELECT TOP 1
                @id = P_Id
        FROM    @table1
        ORDER BY P_Id ASC;
        DELETE  FROM @table1
        WHERE   P_Id = @id;
        SET @ps = @ps + CAST(@id AS VARCHAR(5)) + ',';
    END

SET @ps = '[' + STUFF(@ps, LEN(@ps), 1, ']');

UPDATE  Roles
SET     R_Permissions = @ps ,
        R_PermissionCategories = @pcs
WHERE   R_Id = 1

GO
