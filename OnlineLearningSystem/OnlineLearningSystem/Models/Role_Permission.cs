using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.ComponentModel.DataAnnotations;

namespace OnlineLearningSystem.Models
{
    public class Role_Permission
    {
        [Key]
        [Column(Order=0)]
        public Int32 R_Id { get; set; }

        [Key]
        [Column(Order = 1)]
        public Int32 P_Id { get; set; }
    }
}