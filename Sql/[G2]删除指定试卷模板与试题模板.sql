USE OLS;

DECLARE @eptId INT, @epId INT;

SET @eptId = 25;
SELECT @epId = EP_Id FROM ExaminationPapers WHERE EPT_Id = @eptId;
DELETE FROM ExaminationPaperQuestions WHERE EP_Id = @epId;
DELETE FROM ExaminationPapers WHERE EPT_Id = @eptId;
DELETE FROM ExaminationPaperTemplateQuestions WHERE EPT_Id = @eptId;
DELETE FROM ExaminationPaperTemplates WHERE EPT_Id = @eptId;