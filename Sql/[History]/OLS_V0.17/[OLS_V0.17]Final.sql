DECLARE @now VARCHAR(100)
DECLARE @fileName VARCHAR(100)
DECLARE @filePath VARCHAR(500)

SET @now = REPLACE(REPLACE(REPLACE(CONVERT(VARCHAR(100), GETDATE(), 20), '-', ''), ' ', ''), ':', '');
SET @fileName = 'OLS_V0.16_' + @now + '.sqlserver2k8'
-- �������뱣�����ݿⱸ���ļ���·��
SET @filePath = 'D:\' + @fileName; -- ����: ���� 'D:\' + @fileName

BACKUP DATABASE OLS TO DISK = @filePath

GO

USE OLS;

GO

/***************************************************
** [OLS_V0.17]01����Ȩ�����������б���Ϊ�����Ϲ���.sql
****************************************************/
UPDATE  dbo.[Permissions]
SET     P_Name = '���Ϲ���'
WHERE   P_Controller = 'LearningData'
        AND P_Action = 'List'

GO

/***************************************************
** [OLS_V0.17]02���Ȩ�ޡ���ȡδ����������.sql
****************************************************/
-- ��Ӵ洢���̡�����ϵͳ����Ա��ɫ���ݡ�
IF OBJECT_ID(N'dbo.UpdateAdminRole', 'P') IS NOT NULL 
    DROP PROCEDURE dbo.UpdateAdminRole;

GO

CREATE PROCEDURE UpdateAdminRole
AS -- ���¡�ϵͳ����Ա����ɫ��¼
BEGIN
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
            WHERE   P_Name <> '�����б�'
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

	-- ���¹�����¼
    DELETE  FROM dbo.Role_Permission
    WHERE   R_Id = 1;
    INSERT  [dbo].[Role_Permission]
            SELECT  1 ,
                    P_Id
            FROM    dbo.[Permissions];
END
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
          N'��ȡδ��������' ,
          N'ExaminationPaper' ,
          N'GetUndoNumber' ,
          NULL ,
          CAST(0x079DAEB04D8BAB3A0B AS DATETIME2)
        )

SET IDENTITY_INSERT [dbo].[Permissions] OFF
END
GO

BEGIN

EXEC dbo.UpdateAdminRole;

END
GO

-- ���¡�ѧԱ����ɫȨ��
UPDATE  dbo.Roles
SET     R_Permissions = '[46,47,89,90,130,168,170,79,81,93,94,95,96,131,132,148,158,159]' ,
        R_PermissionCategories = '[6,11,13]'
WHERE   R_Name = 'ѧԱ'

GO

DELETE FROM dbo.Role_Permission WHERE R_Id = 2;

GO

-- ��ӡ���ϵͳ����Ա����ɫȨ�޹���
INSERT  INTO dbo.Role_Permission
        SELECT  2 ,
                P_Id
        FROM    dbo.[Permissions]
        WHERE   PC_Id = 6
                OR PC_Id = 11
                OR P_Id IN (148,158,159)

GO

/***************************************************
** [OLS_V0.17]03��ӡ������û���UserOnlines����.sql
****************************************************/
IF EXISTS ( SELECT  1
            FROM    sysobjects
            WHERE   id = OBJECT_ID('UserOnlines')
                    AND type = 'U' ) 
    DROP TABLE UserOnlines
   
go

CREATE TABLE UserOnlines
    (
      UO_Id INT NOT NULL
                PRIMARY KEY
                IDENTITY(1, 1) ,
      U_Id INT NOT NULL ,
      UO_Name NVARCHAR(50) NOT NULL ,
      UO_IdCardNumber VARCHAR(20) NOT NULL ,
      UO_RefreshTime DATETIME2 NOT NULL
    )

GO

/***************************************************
** [OLS_V0.17]04��ӿ��������ֶΡ�����������ET_ContinuedDays����.sql
****************************************************/
ALTER TABLE dbo.ExaminationTasks
ADD ET_ContinuedDays TINYINT NULL;

GO

UPDATE  dbo.ExaminationTasks
SET     ET_ContinuedDays = 0
WHERE   ET_Mode = 0;
UPDATE  dbo.ExaminationTasks
SET     ET_ContinuedDays = 1
WHERE   ET_Mode <> 0;

GO

ALTER TABLE dbo.ExaminationTasks
ALTER COLUMN ET_ContinuedDays TINYINT NOT NULL;

GO

ALTER TABLE dbo.ExaminationTaskTemplates
ADD ETT_ContinuedDays TINYINT NULL;

GO

UPDATE  dbo.ExaminationTaskTemplates
SET     ETT_ContinuedDays = 0
WHERE   ETT_Mode = 0;
UPDATE  dbo.ExaminationTaskTemplates
SET     ETT_ContinuedDays = 1
WHERE   ETT_Mode <> 0;

GO

ALTER TABLE dbo.ExaminationTaskTemplates
ALTER COLUMN ETT_ContinuedDays TINYINT NOT NULL;

GO

/***************************************************
** [OLS_V0.17]05���Ȩ�ޡ�ˢ������ʱ�䡱�͡������û��б�.sql
****************************************************/
BEGIN
DELETE FROM dbo.Role_Permission;
DELETE FROM [dbo].[Permissions] WHERE P_Id IN (171, 172);
END
GO

BEGIN
DECLARE @pcId INT ,
    @pId INT;

SET  @pcId = 6;
SET  @pId = 171;

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
          N'ˢ������ʱ��' ,
          N'User' ,
          N'RefreshTime' ,
          NULL ,
          CAST(0x079DAEB04D8BAB3A0B AS DATETIME2)
        )
        
SET  @pcId = 5;
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
          N'�����û��б�' ,
          N'User' ,
          N'ListOnline' ,
          NULL ,
          CAST(0x079DAEB04D8BAB3A0B AS DATETIME2)
        )

SET IDENTITY_INSERT [dbo].[Permissions] OFF
END
GO

BEGIN

EXEC dbo.UpdateAdminRole;

END
GO

-- ���¡�ѧԱ����ɫȨ��
UPDATE  dbo.Roles
SET     R_Permissions = '[46,47,89,90,130,168,170,171,79,81,93,94,95,96,131,132,148,158,159]' ,
        R_PermissionCategories = '[6,11,13]'
WHERE   R_Name = 'ѧԱ'

GO

DELETE FROM dbo.Role_Permission WHERE R_Id = 2;

GO

-- ��ӡ���ϵͳ����Ա����ɫȨ�޹���
INSERT  INTO dbo.Role_Permission
        SELECT  2 ,
                P_Id
        FROM    dbo.[Permissions]
        WHERE   PC_Id = 6
                OR PC_Id = 11
                OR P_Id IN (148,158,159)

GO
