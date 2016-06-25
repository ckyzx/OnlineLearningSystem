DECLARE @now VARCHAR(100)
DECLARE @fileName VARCHAR(100)
DECLARE @filePath VARCHAR(500)

SET @now = REPLACE(REPLACE(REPLACE(CONVERT(VARCHAR(100), GETDATE(), 20), '-', ''), ' ', ''), ':', '');
SET @fileName = 'OLS_V0.15_' + @now + '.sqlserver2k8'
-- 下面填入保存数据库备份文件的路径
SET @filePath = 'D:\' + @fileName; -- 例如: 填入 'D:\' + @fileName

BACKUP DATABASE OLS TO DISK = @filePath

GO

USE OLS;

GO

/***************************************************
** [OLS_V0.16]01修改角色数据，只留“系统管理员”与“学员”.sql
****************************************************/

-- 添加存储过程“更新系统管理员角色数据”
IF OBJECT_ID(N'dbo.UpdateAdminRole', 'P') IS NOT NULL 
    DROP PROCEDURE dbo.UpdateAdminRole;

GO

CREATE PROCEDURE UpdateAdminRole
AS -- 更新“系统管理员”角色记录
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

	-- 更新关联记录
        DELETE  FROM dbo.Role_Permission
        WHERE   R_Id = 1;
        INSERT  [dbo].[Role_Permission]
                SELECT  1 ,
                        P_Id
                FROM    dbo.[Permissions]

    END
GO

-- 删除“非系统管理员”角色权限关联
DELETE  FROM dbo.Role_Permission
WHERE   R_Id <> 1;

GO

DELETE  FROM dbo.User_Role;
DELETE  FROM dbo.Department_Role

-- 删除“非系统管理员”角色
DELETE  FROM dbo.Roles
WHERE   R_Id <> 1;

GO

-- 清除部门角色值
UPDATE  dbo.Departments
SET     D_Roles = '[]'

GO

-- 添加新角色
BEGIN
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
              N'学员' , -- R_Name - nvarchar(50)
              '[46,47,79,81,89,90,93,94,95,96,168]' , -- R_Permissions - text
              '[6,11]' , -- R_PermissionCategories - text
              N'' , -- R_Remark - nvarchar(200)
              '2016-01-11 11:57:05 ' , -- R_AddTime - datetime2
              1  -- R_Status - tinyint
            )

-- 将所有角色为“非系统管理员”的用户的角色设置为“学员”
    UPDATE  Users
    SET     U_Roles = '[' + CAST(@rId AS VARCHAR(5)) + ']'
    WHERE   CAST(U_Roles AS VARCHAR(1000)) <> '[1]';

END
GO

BEGIN

EXEC dbo.UpdateAdminRole;

END
GO

-- 添加用户角色关联
BEGIN
    INSERT  INTO dbo.User_Role
            ( U_Id, R_Id )
    VALUES  ( 1, -- U_Id - int
              1  -- R_Id - int
              );
    INSERT  INTO dbo.User_Role
            SELECT  U_Id ,
                    2
            FROM    Users
            WHERE   U_Id <> 1;
END
GO

-- 添加“非系统管理员”角色权限关联
INSERT  INTO dbo.Role_Permission
        SELECT  2 ,
                P_Id
        FROM    dbo.[Permissions]
        WHERE   PC_Id = 6
                OR PC_Id = 11

GO

/***************************************************
** [OLS_V0.16]02添加函数【获取学员考试试卷模板 fn_GetExaminationStudentPaperTemplates】.sql
****************************************************/

IF OBJECT_ID(N'dbo.fn_GetExaminationStudentPaperTemplate', 'TF') IS NOT NULL 
    DROP FUNCTION dbo.fn_GetExaminationStudentPaperTemplate;

GO

CREATE FUNCTION dbo.fn_GetExaminationStudentPaperTemplate ( )
RETURNS @table TABLE
    (
      ESPT_TaskId INT NOT NULL ,
      ESPT_TaskName NVARCHAR(50) NOT NULL ,
      ESPT_TaskType TINYINT NOT NULL ,
      ESPT_UserId INT NOT NULL ,
      ESPT_PaperTemplateId INT NOT NULL ,
      ESPT_PaperTemplateStatus TINYINT NOT NULL ,
      ESPT_PaperTemplateStartTime DATETIME2 NOT NULL ,
      ESPT_PaperTemplateTimeSpan INT NOT NULL ,
      ESPT_PaperTemplateAddTime DATETIME2 NOT NULL ,
      ESPT_PaperTemplateRemark NVARCHAR(50) NULL ,
      ESPT_PaperId INT NULL ,
      ESPT_PaperStatus TINYINT NULL ,
      ESPT_PaperScore NVARCHAR(10) NULL ,
      ESPT_PageType TINYINT NOT NULL
    )
AS 
    BEGIN
	
        INSERT  INTO @table
                SELECT  et.ET_Id ESPT_TaskId ,
                        et.ET_Name ESPT_TaskName ,
                        et.ET_Type ESPT_TaskType ,
                        u.U_Id ESPT_UserId ,
                        ept.EPT_Id SPT_PaperTemplateId ,
                        ept.EPT_PaperTemplateStatus ESPT_PaperTemplateStatus ,
                        ept.EPT_StartTime ESPT_PaperTemplateStartTime ,
                        ept.EPT_TimeSpan ESPT_PaperTemplateTimeSpan ,
                        ept.EPT_AddTime ESPT_PaperTemplateAddTime ,
                        ept.EPT_Remark ESPT_PaperTemplateRemark ,
                        ep.EP_Id ESPT_PaperId ,
                        ep.EP_PaperStatus ESPT_PaperStatus ,
                        CASE WHEN ep.EP_Score IS NULL THEN '[未参与]'
                             WHEN ep.EP_Score = -1 THEN '[未评分]'
                             ELSE CASE et.ET_StatisticType
                                    WHEN 1 THEN CAST(ep.EP_Score AS VARCHAR(10)) + '分'
                                    WHEN 2 THEN CAST(ep.EP_Score AS VARCHAR(10)) + '%'
                                    ELSE '[未预期]'
                                  END
                        END ESPT_PaperScore ,
                        CASE WHEN ep.EP_Id IS NULL
                                  AND ept.EPT_PaperTemplateStatus = 1 THEN 1
                             WHEN ep.EP_PaperStatus = 1 THEN 1
                             ELSE 2
                        END ESPT_PageType -- 当未考试、正在考试时，将记录归为“未考完”页面类型
                FROM    dbo.ExaminationTasks et
                        LEFT JOIN dbo.ExaminationPaperTemplates ept ON et.ET_Id = ept.ET_Id
                        LEFT JOIN dbo.ExaminationTaskAttendees eta ON et.ET_Id = eta.ET_Id
                        LEFT JOIN dbo.Users u ON eta.U_Id = u.U_Id
                        LEFT JOIN dbo.ExaminationPapers ep ON ept.EPT_Id = ep.EPT_Id
                                                              AND u.U_Id = ep.EP_UserId
                WHERE   et.ET_Status = 1
                        AND ept.EPT_Id IS NOT NULL
                        AND ept.EPT_PaperTemplateStatus <> 0 -- 不取未开始的试卷模板
        RETURN;
    END

GO

IF OBJECT_ID(N'dbo.ExaminationStudentPaperTemplates', 'V') IS NOT NULL 
    DROP VIEW dbo.ExaminationStudentPaperTemplates;

GO

CREATE VIEW dbo.ExaminationStudentPaperTemplates
AS
    SELECT  *
    FROM    dbo.fn_GetExaminationStudentPaperTemplate()

GO

/***************************************************
** [OLS_V0.16]03清除部门名称中的空格.sql
****************************************************/
UPDATE  dbo.Departments
SET     D_Name = REPLACE(D_Name, ' ', '')
WHERE   D_Name LIKE '% %'

GO

/***************************************************
** [OLS_V0.16.0.4]01更改系统管理员登录账号为 admin.sql
****************************************************/
UPDATE  dbo.Users
SET     U_IdCardNumber = 'admin'
WHERE   U_Id = 1;

GO
