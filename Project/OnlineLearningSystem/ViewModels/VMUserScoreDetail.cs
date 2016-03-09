using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace OnlineLearningSystem.ViewModels
{
    public class VMUserScoreDetail
    {
        public Int32 USD_UserId { get; set; }
        public String USD_UserName { get; set; }
        public Int32 USD_DepartmentId { get; set; }
        public String USD_DepartmentName { get; set; }
        public Int32 USD_TaskId { get; set; }
        public String USD_TaskName { get; set; }
        public Byte USD_TaskStatisticType { get; set; }
        public Int32 USD_PaperTemplateId { get; set; }
        public DateTime USD_StartDate { get; set; }
        public DateTime USD_StartTime { get; set; }
        public Int32 USD_PaperId { get; set; }
        public Int32 USD_Score { get; set; }
        public Byte USD_State { get; set; }
    }
}