USE OLS;

DECLARE @status TINYINT;
DECLARE @qcName NVARCHAR(100);

SET @qcName = '综合、公文、绩效知识（90题）';
SET @status = 3;

SELECT  COUNT(Q_Id) 试题总数 ,
        CASE QC_Status
          WHEN 0 THEN '[未设置]'
          WHEN 1 THEN '正常'
          WHEN 2 THEN '回收'
          WHEN 3 THEN '删除'
          WHEN 4 THEN '缓存'
          ELSE '...'
        END 分类状态 ,
        QC_Name 分类名称
FROM    dbo.Questions q
        LEFT JOIN dbo.QuestionClassifies qc ON q.QC_Id = qc.QC_Id
WHERE   qc.QC_Name = @qcName
        AND q.Q_Status = @status
GROUP BY QC_Status ,
        QC_Name

SELECT  CASE Q_Status
          WHEN 0 THEN '[未设置]'
          WHEN 1 THEN '正常'
          WHEN 2 THEN '回收'
          WHEN 3 THEN '删除'
          WHEN 4 THEN '缓存'
          ELSE '...'
        END 试题状态 ,
        Q_Type 类型 ,
        Q_Content 内容 ,
        Q_OptionalAnswer 备选答案 ,
        Q_ModelAnswer 标准答案
FROM    dbo.Questions q
        LEFT JOIN dbo.QuestionClassifies qc ON q.QC_Id = qc.QC_Id
WHERE   qc.QC_Name = @qcName
        AND q.Q_Status = @status