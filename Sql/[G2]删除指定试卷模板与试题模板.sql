USE OLS;

DECLARE @eptId int, @epId INT;

SET @eptId = 6;
select @epId = EP_Id from ExaminationPapers where EPT_Id = @eptId;
delete from ExaminationPaperQuestions where EP_Id = @epId;
delete from ExaminationPapers where EPT_Id = @eptId;
DELETE FROM ExaminationPaperTemplateQuestions WHERE EPT_Id = @eptId;
DELETE FROM ExaminationPaperTemplates WHERE EPT_Id = @eptId;