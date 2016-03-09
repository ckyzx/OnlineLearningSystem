using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.ComponentModel.DataAnnotations;

namespace OnlineLearningSystem.Models
{
    public class SystemLog
    {
        [Key]
        public Int32 SL_Id {get;set;}
        public String SL_Name { get; set; }
        public Byte SL_Type { get; set; }
        public String SL_Content { get; set; }
        public String SL_Remark { get; set; }
        public Byte SL_Status { get; set; }
        public DateTime SL_AddTime { get; set; }
    }
}