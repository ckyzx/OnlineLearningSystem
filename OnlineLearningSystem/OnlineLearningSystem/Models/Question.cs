using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.ComponentModel.DataAnnotations;

namespace OnlineLearningSystem.Models
{
    public class Question
    {
        [Key]
        public Int32 Q_Id { get; set; }
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public Int32 Q_AutoId { get; set; }
        public String Q_Type { get; set; }
        public Int32 Q_Classify { get; set; }
        [NotMapped]
        public String Q_ClassifyName { get; set; }
        public String Q_Content { get; set; }
        public String Q_OptionalAnswer { get; set; }
        public String Q_ModelAnswer { get; set; }
        public Byte Q_DifficultyCoefficient { get; set; }
        public String Q_Remark { get; set; }
        public DateTime Q_AddTime { get; set; }
        public Byte Q_Status { get; set; }

    }
}