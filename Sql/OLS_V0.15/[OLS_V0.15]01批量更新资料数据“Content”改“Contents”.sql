USE OLS;

GO

UPDATE  dbo.LearningDatas
SET     LD_Video = REPLACE(LD_Video, '/Content/', '/Contents/')
WHERE   LD_Video LIKE '%/Content/%';

GO
