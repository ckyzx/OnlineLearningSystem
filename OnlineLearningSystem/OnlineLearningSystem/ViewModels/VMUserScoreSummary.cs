using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace OnlineLearningSystem.ViewModels
{
    public class VMUserScoreSummary
    {
        public Int32 USS_UserId { get; set; }
        public String USS_UserName { get; set; }
        public String USS_DepartmentName { get; set; }
        public String USS_DutyName { get; set; }
        public Int32 USS_TotalNumber { get; set; }
        public Int32 USS_DoneNumber { get; set; }
        public Int32 USS_UndoNumber { get; set; }
        public Int32 USS_PassNumber { get; set; }
        public Decimal USS_PassRatio { get; set; }
        public Decimal USS_DoneRatio { get; set; }
    }
}