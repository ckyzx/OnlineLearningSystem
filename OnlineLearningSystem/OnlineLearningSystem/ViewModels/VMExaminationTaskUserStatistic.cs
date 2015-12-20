using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace OnlineLearningSystem.ViewModels
{
    public class VMExaminationTaskUserStatistic
    {
        public Int32 ETUS_TaskId { get; set; }
        public String ETUS_TaskName { get; set; }
        public Byte ETUS_TaskAutoType { get; set; }
        public Byte ETUS_TaskStatisticType { get; set; }
        public Int32 ETUS_PaperTemplateId { get; set; }
        public DateTime ETUS_PaperTemplateDate { get; set; }
        public Int32 ETUS_DepartmentId { get; set; }
        public String ETUS_DepartmentName { get; set; }
        public Int32 ETUS_UserId { get; set; }
        public String ETUS_UserName { get; set; }
        public Int32 ETUS_DutyId { get; set; }
        public String ETUS_DutyName { get; set; }
        public Int32 ETUS_PaperId { get; set; }
        public DateTime ETUS_PaperAddTime { get; set; }
        public Int32 ETUS_Score { get; set; }
        public Byte ETUS_State { get; set; }
    }
}