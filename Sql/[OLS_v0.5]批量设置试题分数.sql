USE OLS;

GO

UPDATE Questions SET Q_Score = 5 WHERE Q_Type = '��ѡ��' AND Q_Score = 0;
UPDATE Questions SET Q_Score = 8 WHERE Q_Type = '��ѡ��' AND Q_Score = 0;
UPDATE Questions SET Q_Score = 5 WHERE Q_Type = '�ж���' AND Q_Score = 0;
UPDATE Questions SET Q_Score = 10 WHERE Q_Type = '���ĸĴ���' AND Q_Score = 0;
UPDATE Questions SET Q_Score = 20 WHERE Q_Type = '������' AND Q_Score = 0;
UPDATE Questions SET Q_Score = 25 WHERE Q_Type = '����������' AND Q_Score = 0;
UPDATE Questions SET Q_Score = 15 WHERE Q_Type = '�ʴ���' AND Q_Score = 0;

GO