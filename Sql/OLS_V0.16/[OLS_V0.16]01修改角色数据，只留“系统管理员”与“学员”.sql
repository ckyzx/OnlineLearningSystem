USE OLS;

GO

-- ��Ӵ洢���̡�����ϵͳ����Ա��ɫ���ݡ�
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

-- ɾ������ϵͳ����Ա����ɫȨ�޹���
DELETE  FROM dbo.Role_Permission
WHERE   R_Id <> 1;

GO

DELETE  FROM dbo.User_Role;
DELETE  FROM dbo.Department_Role

-- ɾ������ϵͳ����Ա����ɫ
DELETE  FROM dbo.Roles
WHERE   R_Id <> 1;

GO

-- ������Ž�ɫֵ
UPDATE  dbo.Departments
SET     D_Roles = '[]'

GO

-- ����½�ɫ
DECLARE @rId INT;

SELECT  @rId = MAX(R_Id) + 1
FROM    Roles;
INSERT  INTO dbo.Roles
        ( R_Id ,
          R_Name ,
          R_Permissions ,
          R_PermissionCategories ,
          R_Remark ,
          R_AddTime ,
          R_Status
        )
VALUES  ( @rId , -- R_Id - int
          N'ѧԱ' , -- R_Name - nvarchar(50)
          '[46,47,79,81,89,90,93,94,95,96,168]' , -- R_Permissions - text
          '[6,11]' , -- R_PermissionCategories - text
          N'' , -- R_Remark - nvarchar(200)
          '2016-01-11 11:57:05 ' , -- R_AddTime - datetime2
          1  -- R_Status - tinyint
        )

-- �����н�ɫΪ����ϵͳ����Ա�����û��Ľ�ɫ����Ϊ��ѧԱ��
UPDATE  Users
SET     U_Roles = '[' + CAST(@rId AS VARCHAR(5)) + ']'
WHERE   CAST(U_Roles AS VARCHAR(1000)) <> '[1]';

GO

EXEC dbo.UpdateAdminRole;

GO

-- ����û���ɫ����
INSERT  INTO dbo.User_Role
        ( U_Id, R_Id )
VALUES  ( 1, -- U_Id - int
          1  -- R_Id - int
          )
INSERT  INTO dbo.User_Role
        SELECT  U_Id ,
                2
        FROM    Users
        WHERE   U_Id <> 1

GO

-- ��ӡ���ϵͳ����Ա����ɫȨ�޹���
INSERT  INTO dbo.Role_Permission
        SELECT  2 ,
                P_Id
        FROM    dbo.[Permissions]
        WHERE   PC_Id = 6
                OR PC_Id = 11

GO
