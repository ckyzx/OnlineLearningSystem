use OLS;

update Questions set Q_Score = 4 where Q_Type = '单选题';
update Questions set Q_Score = 5 where Q_Type = '多选题';
update Questions set Q_Score = 6 where Q_Type = '判断题';
update Questions set Q_Score = 7 where Q_Type = '公文改错题';
update Questions set Q_Score = 8 where Q_Type = '计算题';
update Questions set Q_Score = 9 where Q_Type = '案例分析题';
update Questions set Q_Score = 10 where Q_Type = '问答题';