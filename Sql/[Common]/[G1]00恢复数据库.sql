USE master

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
FROM DISK= 'F:\工作目录\OLS\OnlineLearningSystem_V0.13.0.2_20160226\Db\OLSV0.8_Database\ols.sqlserver2k8'
--FROM DISK= 'D:\Cheng\Workspace\OnlineLearningSystem\Db\OLSV0.8_Database\ols.sqlserver2k8'
--FROM DISK = 'D:\OLS_20160226093446_v0.12.2_Dev.sqlserver2k8'
WITH REPLACE,
     MOVE 'OLS_Data' TO 'F:\SQLSERVER2008DATA\OLS.mdf', 
     MOVE 'OLS_log'  TO 'F:\SQLSERVER2008DATA\OLS_log.ldf'
     --MOVE 'OLS_Data' TO 'D:\SQL Server 2008 Data\OLS.mdf', 
     --MOVE 'OLS_log'  TO 'D:\SQL Server 2008 Data\OLS_log.ldf'