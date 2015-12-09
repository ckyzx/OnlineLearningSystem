BEGIN TRAN UpdateOLS_v01015

USE OLS;

GO

ALTER TABLE ExaminationTasks
ADD ET_StatisticType TINYINT NULL;
ALTER TABLE ExaminationTasks
ADD ET_TotalScore INT NULL;
ALTER TABLE ExaminationTasks
ADD ET_AutoNumber INT NULL;
ALTER TABLE ExaminationTasks
ADD ET_AutoClassifies TEXT NULL;
ALTER TABLE ExaminationTasks
ADD ET_AutoRatio VARCHAR(500) NULL;

GO

UPDATE ExaminationTasks SET ET_StatisticType = 0, ET_TotalScore = 100, ET_AutoNumber = 10, ET_AutoClassifies = '[]', ET_AutoRatio = '[]';

GO

ALTER TABLE ExaminationTasks
ALTER COLUMN ET_StatisticType TINYINT NOT NULL;
ALTER TABLE ExaminationTasks
ALTER COLUMN ET_TotalScore INT NOT NULL;
ALTER TABLE ExaminationTasks
ALTER COLUMN ET_AutoNumber INT NOT NULL;
ALTER TABLE ExaminationTasks
ALTER COLUMN ET_AutoClassifies TEXT NOT NULL;
ALTER TABLE ExaminationTasks
ALTER COLUMN ET_AutoRatio VARCHAR(500) NOT NULL;

ALTER TABLE ExaminationTasks
ALTER COLUMN ET_ParticipatingDepartment TEXT NOT NULL;
ALTER TABLE ExaminationTasks
ALTER COLUMN ET_Attendee TEXT NOT NULL;
ALTER TABLE ExaminationTasks
ALTER COLUMN ET_AutoOffsetDay TINYINT NOT NULL;
ALTER TABLE ExaminationTasks
ALTER COLUMN ET_PaperTemplates TEXT NOT NULL;
ALTER TABLE ExaminationTasks
ALTER COLUMN ET_Questions TEXT NOT NULL;

GO

ALTER TABLE Questions
ADD Q_Score INT NULL;

GO

UPDATE Questions SET Q_Score = 0;

GO

ALTER TABLE Questions
ALTER COLUMN Q_Score INT NOT NULL;

COMMIT TRAN UpdateOLS_v01015
