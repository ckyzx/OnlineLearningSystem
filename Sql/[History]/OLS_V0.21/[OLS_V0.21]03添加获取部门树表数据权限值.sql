USE OLS;

GO

BEGIN
DECLARE @pcId INT ,
    @pId INT;

SELECT  @pcId = 3;
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
          N'获取部门树表数据' ,
          N'Department' ,
          N'GetZTreeResJson' ,
          NULL ,
          CAST(0x079DAEB04D8BAB3A0B AS DATETIME2)
        )
        
SET IDENTITY_INSERT [dbo].[Permissions] OFF
END

EXEC dbo.UpdateAdminRole;

GO
