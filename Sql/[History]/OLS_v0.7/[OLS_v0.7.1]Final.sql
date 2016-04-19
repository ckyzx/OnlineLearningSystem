-- [1]备份数据库
DECLARE @now VARCHAR(100)
DECLARE @fileName VARCHAR(100)
DECLARE @filePath VARCHAR(500)

SET @now = REPLACE(REPLACE(REPLACE(CONVERT(VARCHAR(100), GETDATE(), 20), '-', ''), ' ', ''), ':', '');
SET @fileName = 'OLS_' + @now + '.sqlserver2k8'
-- 下面填入保存数据库备份文件的路径
-- 例如: 填入 'D:\' + @fileName
SET @filePath = 'D:\' + @fileName;

BACKUP DATABASE OLS TO DISK = @filePath

GO

USE OLS;

GO

if object_id(N'SystemLogs',N'U') is not NULL
	DROP TABLE SystemLogs

GO

CREATE TABLE SystemLogs
    (
      SL_Id INT identity ,
      SL_Name VARCHAR(500) NOT NULL ,
      SL_Type TINYINT NOT NULL ,
      SL_Content TEXT NOT NULL ,
      SL_Remark VARCHAR(500) NULL ,
      SL_Status TINYINT NOT NULL ,
      SL_AddTime DATETIME2 NOT NULL ,
      CONSTRAINT PK_SYSTEMLOGS PRIMARY KEY ( SL_Id )
    )

GO
