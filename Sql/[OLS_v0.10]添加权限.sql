USE OLS;

GO

/* 添加“系统日志”角色权限 */

/*-- 添加权限目录
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
          '日志管理' ,
          '0012' ,
          NULL ,
          CAST(0x079DAEB04D8BAB3A0B AS DATETIME2) ,
          1
        )

SET IDENTITY_INSERT dbo.PermissionCategories OFF

GO

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
VALUES  ( 133 ,
          133 ,
          12 ,
          N'系统日志列表' ,
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
          N'查询系统日志' ,
          N'SystemLog' ,
          N'ListDataTablesAjax' ,
          NULL ,
          CAST(0x079DAEB04D8BAB3A0B AS DATETIME2)
        )
                
SET IDENTITY_INSERT [dbo].[Permissions] OFF

-- 添加关联记录
INSERT  [dbo].[Role_Permission]
        SELECT  1 ,
                133
        UNION ALL
        SELECT  1 ,
                134

GO*/

/* 添加“查询考试任务”权限 */
--SET IDENTITY_INSERT [dbo].[Permissions] ON

--INSERT  [dbo].[Permissions]
--        ( P_Id ,
--          P_AutoId ,
--          PC_Id ,
--          P_Name ,
--          P_Controller ,
--          P_Action ,
--          P_Remark ,
--          P_AddTime
--        )
--VALUES  ( 135 ,
--          135 ,
--          9 ,
--          N'查询考试任务' ,
--          N'ExaminationTask' ,
--          N'ListDataTablesAjaxByMode' ,
--          NULL ,
--          CAST(0x079DAEB04D8BAB3A0B AS DATETIME2)
--        )
                
--SET IDENTITY_INSERT [dbo].[Permissions] OFF

--GO

-- 添加关联记录
INSERT  [dbo].[Role_Permission]
        SELECT  1 ,
                135

GO

-- 更新角色记录
--UPDATE  Roles
--SET     R_Permissions = '[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135]' ,
--        R_PermissionCategories = '[1,2,3,4,5,6,7,8,9,10,11,12]'
--WHERE   R_Id = 1

--GO
