using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using System.Web.Mvc;

namespace OnlineLearningSystem.Models
{
    public class Duty
    {
        [Key]
        public Int32 Du_Id { get; set; }

        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public Int32 Du_AutoId { get; set; }

        [DisplayName("名称")]
        [Remote("DuplicateName", "Duty", ErrorMessage = "名称已存在", AdditionalFields = "Du_Id")]
        [Required(ErrorMessage = "请输入{0}")]
        [RegularExpression(@"^[\u4E00-\u9FA5\uF900-\uFA2D]{1}[\u4E00-\u9FA5\uF900-\uFA2D0-9]{1,21}$", ErrorMessage = "请输入2至22位，中文开头的字符，可带数字")]
        public String Du_Name { get; set; }

        [DisplayName("备注")]
        public String Du_Remark { get; set; }

        [DisplayName("添加时间")]
        [DataType(DataType.DateTime)]
        public DateTime Du_AddTime { get; set; }

        [DisplayName("状态")]
        [Required(ErrorMessage = "请选择{0}")]
        public Byte Du_Status { get; set; }

        [DisplayName("排序")]
        [Required(ErrorMessage = "请设置{0}")]
        public Double Du_Sort { get; set; }
    }
}