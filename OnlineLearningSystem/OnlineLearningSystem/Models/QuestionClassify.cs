using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.ComponentModel.DataAnnotations;

namespace OnlineLearningSystem.Models
{
    public class QuestionClassify
    {
        [Key]
        public Int32 QC_Id { get; set; }
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public Int32 QC_AutoId { get; set; }
        public String QC_Name { get; set; }
        public String QC_Level { get; set; }
        public String QC_Remark { get; set; }
        public DateTime QC_AddTime { get; set; }
        public Byte QC_Status { get; set; }
    }
}