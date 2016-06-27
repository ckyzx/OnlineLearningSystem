using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.ComponentModel.DataAnnotations;

namespace OnlineLearningSystem.Models
{
    public class ExaminationQuestionDone
    {
        [Key]
        public Int32 EQD_Id { get; set; }

        public Int32 ET_Id { get; set; }

        public Int32 EPT_Id { get; set; }

        public Int32 U_Id { get; set; }

        public Int32 Q_Id { get; set; }
    }
}