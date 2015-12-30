USE OLS;

GO

UPDATE Questions SET Q_Score = 5 WHERE Q_Type = '单选题' AND Q_Score = 0;
UPDATE Questions SET Q_Score = 8 WHERE Q_Type = '多选题' AND Q_Score = 0;
UPDATE Questions SET Q_Score = 5 WHERE Q_Type = '判断题' AND Q_Score = 0;
UPDATE Questions SET Q_Score = 10 WHERE Q_Type = '公文改错题' AND Q_Score = 0;
UPDATE Questions SET Q_Score = 20 WHERE Q_Type = '计算题' AND Q_Score = 0;
UPDATE Questions SET Q_Score = 25 WHERE Q_Type = '案例分析题' AND Q_Score = 0;
UPDATE Questions SET Q_Score = 15 WHERE Q_Type = '问答题' AND Q_Score = 0;

GO