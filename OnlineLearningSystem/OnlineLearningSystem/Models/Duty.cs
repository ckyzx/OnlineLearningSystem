using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;

namespace OnlineLearningSystem.Models
{
    public class Duty
    {
        [Key]
        public Int32 Du_Id { get; set; }

        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public Int32 Du_AutoId { get; set; }

        [DisplayName("名称")]
        [Required(ErrorMessage="请输入{0}")]
        public String Du_Name { get; set; }

        [DisplayName("备注")]
        public String Du_Remark { get; set; }

        [DisplayName("添加时间")]
        [DataType(DataType.DateTime)]
        public DateTime Du_AddTime { get; set; }

        [DisplayName("状态")]
        [Required(ErrorMessage = "请选择{0}")]
        public Byte Du_Status { get; set; }
    }
}