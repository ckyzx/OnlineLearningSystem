using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace OnlineLearningSystem.ViewModels
{
    public class VMExaminationStudentPaperTemplate
    {
        public Int32 ESPT_TaskId { get; set; }
        public String ESPT_TaskName { get; set; }
        public Byte ESPT_TaskType { get; set; }
        public Int32 ESPT_UserId { get; set; }
        public String ESPT_UserName { get; set; }
        public Int32 ESPT_PaperTemplateId { get; set; }
        public Byte ESPT_Status { get; set; }
        public Byte ESPT_PaperTemplateStatus { get; set; }
        public DateTime ESPT_PaperTemplateStartTime { get; set; }
        public Int32 ESPT_PaperTemplateTimeSpan { get; set; }
        public DateTime ESPT_PaperTemplateAddTime { get; set; }
        public String ESPT_PaperTemplateRemark { get; set; }
        public Int32 ESPT_PaperId { get; set; }
        public Byte ESPT_PaperStatus { get; set; }
        public String ESPT_PaperScore { get; set; }
        public Byte ESPT_PageType { get; set; }
    }
}