using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;

namespace OnlineLearningSystem.Models
{
    public class ExaminationPaperQuestion
    {
        [Key]
        public Int32 EPQ_Id { get; set; }

        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public Int32 EPQ_AutoId { get; set; }

        public Int32 EP_Id { get; set; }

        public Int32 EPTQ_Id { get; set; }

        public String EPQ_Answer { get; set; }

        public Byte EPQ_Exactness { get; set; }

        public String EPQ_Critique { get; set; }

        public DateTime EPQ_AddTime { get; set; }
    }
}