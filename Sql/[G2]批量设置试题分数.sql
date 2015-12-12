USE OLS;

GO

UPDATE Questions SET Q_Score = 4 WHERE Q_Type = '单选题';
UPDATE Questions SET Q_Score = 5 WHERE Q_Type = '多选题';
UPDATE Questions SET Q_Score = 6 WHERE Q_Type = '判断题';
UPDATE Questions SET Q_Score = 7 WHERE Q_Type = '公文改错题';
UPDATE Questions SET Q_Score = 8 WHERE Q_Type = '计算题';
UPDATE Questions SET Q_Score = 9 WHERE Q_Type = '案例分析题';
UPDATE Questions SET Q_Score = 10 WHERE Q_Type = '问答题';

GO