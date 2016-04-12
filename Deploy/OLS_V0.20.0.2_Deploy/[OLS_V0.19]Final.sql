DECLARE @now VARCHAR(100)
DECLARE @fileName VARCHAR(100)
DECLARE @filePath VARCHAR(500)

SET @now = REPLACE(REPLACE(REPLACE(CONVERT(VARCHAR(100), GETDATE(), 20), '-', ''), ' ', ''), ':', '');
SET @fileName = 'OLS_V0.17_' + @now + '.sqlserver2k8'
-- 下面填入保存数据库备份文件的路径
SET @filePath = 'D:\' + @fileName; -- 例如: 填入 'D:\' + @fileName

BACKUP DATABASE OLS TO DISK = @filePath

GO

USE OLS;

GO

/***************************************************
** [OLS_V0.19]1添加批量操作试题的权限.sql
****************************************************/
BEGIN
DECLARE @pcId INT ,
    @pId INT;

SELECT  @pcId = 7;
SELECT  @pId = MAX(P_Id) + 1
FROM    dbo.[Permissions]

-- 添加权限值
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
          N'批量回收试题' ,
          N'Question' ,
          N'Recycles' ,
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
          N'批量恢复试题' ,
          N'Question' ,
          N'Resumes' ,
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
          N'批量删除试题' ,
          N'Question' ,
          N'Deletes' ,
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

/***************************************************
** [OLS_V0.19]2修改用户密码为 123456.sql
****************************************************/
UPDATE Users SET U_Password = 'E10ADC3949BA59ABBE56E057F20F883E' WHERE LOWER(U_LoginName) <> 'admin'

GO
