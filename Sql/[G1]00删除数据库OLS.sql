USE master

GO

IF EXISTS ( SELECT  *
            FROM    dbo.sysobjects
            WHERE   id = OBJECT_ID(N'[dbo].[p_killspid]')
                    AND OBJECTPROPERTY(id, N'IsProcedure') = 1 ) 
    DROP PROCEDURE [dbo].[p_killspid]
GO

--建立一个存储过程
CREATE PROC p_killspid @dbname SYSNAME --要关闭进程的数据库名
AS 
    DECLARE @s NVARCHAR(1000)
    DECLARE tb CURSOR local
        FOR SELECT  s = 'kill ' + CAST(spid AS VARCHAR)
            FROM    master..sysprocesses
            WHERE   dbid = DB_ID(@dbname)
    OPEN tb
    FETCH NEXT FROM tb INTO @s
    WHILE @@fetch_status = 0
        BEGIN
            EXEC(@s)
            FETCH NEXT FROM tb INTO @s
        END
    CLOSE tb
    DEALLOCATE tb
GO

EXEC p_killspid 'OLS'

GO

DROP DATABASE OLS;