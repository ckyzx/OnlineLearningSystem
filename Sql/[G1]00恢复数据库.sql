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

EXEC p_killspid 'HKH360V1'

RESTORE DATABASE HKH360V1
-- �����������ݿⱸ���ļ���·��
FROM DISK= 'D:\backup\database\20160111\OLS-*.sqlserver2k5'
WITH REPLACE,
     MOVE 'OLS_Data' TO 'D:\SQL Server 2008 Data\OLS.mdf', 
     MOVE 'OLS_log'  TO 'D:\SQL Server 2008 Data\OLS_log.ldf'