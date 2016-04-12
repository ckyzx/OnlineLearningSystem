DECLARE @now VARCHAR(100)
DECLARE @fileName VARCHAR(100)
DECLARE @filePath VARCHAR(500)

SET @now = REPLACE(REPLACE(REPLACE(CONVERT(VARCHAR(100), GETDATE(), 20), '-', ''), ' ', ''), ':', '');
SET @fileName = 'OLS_' + @now + '.sqlserver2k8'
-- �������뱣�����ݿⱸ���ļ���·��
SET @filePath = 'D:\' + @fileName; -- ����: ���� 'D:\' + @fileName

BACKUP DATABASE OLS TO DISK = @filePath

GO
