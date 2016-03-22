USE OLS;

GO

/*-- ��Ӵ洢���̡�����ϵͳ����Ա��ɫ���ݡ�
IF OBJECT_ID(N'dbo.UpdateAdminRole', 'P') IS NOT NULL 
    DROP PROCEDURE dbo.UpdateAdminRole;

GO

CREATE PROCEDURE UpdateAdminRole
AS -- ���¡�ϵͳ����Ա����ɫ��¼
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
            FROM    dbo.[Permissions]

GO

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

GO

EXEC dbo.UpdateAdminRole;

GO*/

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
