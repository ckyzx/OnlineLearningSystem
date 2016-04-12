DECLARE @now VARCHAR(100)
DECLARE @fileName VARCHAR(100)
DECLARE @filePath VARCHAR(500)

SET @now = REPLACE(REPLACE(REPLACE(CONVERT(VARCHAR(100), GETDATE(), 20), '-', ''), ' ', ''), ':', '');
SET @fileName = 'OLS_' + @now + '.sqlserver2k8'
-- 下面填入保存数据库备份文件的路径
SET @filePath = 'D:\' + @fileName; -- 例如: 填入 'D:\' + @fileName

BACKUP DATABASE OLS TO DISK = @filePath

GO

IF EXISTS ( SELECT  *
            FROM    dbo.sysobjects
            WHERE   id = OBJECT_ID(N'[dbo].[p_killspid]')
                    AND OBJECTPROPERTY(id, N'IsProcedure') = 1 ) 
    DROP PROCEDURE [dbo].[p_killspid]
GO

CREATE PROC p_killspid @dbname SYSNAME
AS 
    DECLARE @s NVARCHAR(1000)
    DECLARE tb CURSOR LOCAL
    FOR
        SELECT  s = 'kill ' + CAST(SPID AS VARCHAR)
        FROM    master..sysprocesses
        WHERE   dbid = DB_ID(@dbname)
    OPEN tb
    FETCH NEXT FROM tb INTO @s
    WHILE @@FETCH_STATUS = 0 
        BEGIN
            EXEC(@s)
            FETCH NEXT FROM tb INTO @s
        END
    CLOSE tb
    DEALLOCATE tb
GO

EXEC p_killspid 'OLS'

RESTORE DATABASE OLS
-- 下面填入数据库备份文件的路径
FROM DISK = 'D:\OLS_V0.15_Dev.sqlserver2k8'
WITH REPLACE,
     --MOVE 'OLS_Data' TO 'F:\SQLSERVER2008DATA\OLS.mdf', 
     --MOVE 'OLS_log'  TO 'F:\SQLSERVER2008DATA\OLS_log.ldf'
     MOVE 'OLS_Data' TO 'D:\SQL Server 2008 Data\OLS.mdf', 
     MOVE 'OLS_log'  TO 'D:\SQL Server 2008 Data\OLS_log.ldf'