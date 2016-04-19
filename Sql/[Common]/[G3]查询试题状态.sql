USE OLS;

DECLARE @status TINYINT;
DECLARE @qcName NVARCHAR(100);

SET @qcName = '�ۺϡ����ġ���Ч֪ʶ��90�⣩';
SET @status = 3;

SELECT  COUNT(Q_Id) �������� ,
        CASE QC_Status
          WHEN 0 THEN '[δ����]'
          WHEN 1 THEN '����'
          WHEN 2 THEN '����'
          WHEN 3 THEN 'ɾ��'
          WHEN 4 THEN '����'
          ELSE '...'
        END ����״̬ ,
        QC_Name ��������
FROM    dbo.Questions q
        LEFT JOIN dbo.QuestionClassifies qc ON q.QC_Id = qc.QC_Id
WHERE   qc.QC_Name = @qcName
        AND q.Q_Status = @status
GROUP BY QC_Status ,
        QC_Name

SELECT  CASE Q_Status
          WHEN 0 THEN '[δ����]'
          WHEN 1 THEN '����'
          WHEN 2 THEN '����'
          WHEN 3 THEN 'ɾ��'
          WHEN 4 THEN '����'
          ELSE '...'
        END ����״̬ ,
        Q_Type ���� ,
        Q_Content ���� ,
        Q_OptionalAnswer ��ѡ�� ,
        Q_ModelAnswer ��׼��
FROM    dbo.Questions q
        LEFT JOIN dbo.QuestionClassifies qc ON q.QC_Id = qc.QC_Id
WHERE   qc.QC_Name = @qcName
        AND q.Q_Status = @status