using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.ComponentModel.DataAnnotations;

namespace OnlineLearningSystem.Models
{
    public class UserOnline
    {
        [Key]
        public Int32 UO_Id { get; set; }
        public Int32 U_Id { get; set; }
        public String UO_Name { get; set; }
        public String UO_IdCardNumber { get; set; }
        public DateTime UO_RefreshTime { get; set; }
    }
}