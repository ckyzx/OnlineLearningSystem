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
        [Column(Order = 0)]
        public Int32 ET_Id { get; set; }

        [Key]
        [Column(Order = 1)]
        public Int32 EPT_Id { get; set; }

        [Key]
        [Column(Order = 2)]
        public Int32 Q_Id { get; set; }
    }
}