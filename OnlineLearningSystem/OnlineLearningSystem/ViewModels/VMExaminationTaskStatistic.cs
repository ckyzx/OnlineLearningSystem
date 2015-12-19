using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.ComponentModel.DataAnnotations;

namespace OnlineLearningSystem.ViewModels
{
    public class VMExaminationTaskStatistic
    {
        public Int32 ETS_TaskId { get; set; }
        public String ETS_TaskName { get; set; }
        public DateTime ETS_Date { get; set; }
        public Int32 ETS_AttendeeNumber { get; set; }
        public Int32 ETS_PaperNumber { get; set; }
        public Int32 ETS_PassNumber { get; set; }
        public Int32 ETS_FlunkNumber { get; set; }
    }
}