using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace OnlineLearningSystem.ViewModels
{
    public class VMUserScoreDetail
    {
        public String USD_TaskName { get; set; }
        public DateTime USD_TaskTime { get; set; }
        public Boolean USD_IfAttendee { get; set; }
        public Int32 USD_Score { get; set; }
        public Byte USD_state { get; set; }
    }
}