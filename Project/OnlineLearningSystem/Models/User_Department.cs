using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.ComponentModel.DataAnnotations;

namespace OnlineLearningSystem.Models
{
    public class User_Department
    {
        [Key]
        [Column(Order = 0)]
        public Int32 U_Id { get; set; }

        [Key]
        [Column(Order = 1)]
        public Int32 D_Id { get; set; }
    }
}