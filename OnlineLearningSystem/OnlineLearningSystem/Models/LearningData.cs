using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel;

namespace OnlineLearningSystem.Models
{
    public class LearningData
    {
        [Key]
        public Int32 LD_Id { get; set; }

        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public Int32 LD_AutoId { get; set; }

        [DisplayName("标题")]
        [Remote("DuplicateName", "LearningData", ErrorMessage = "标题已存在", AdditionalFields = "LD_Id")]
        [Required(ErrorMessage = "请输入{0}")]
        [RegularExpression(@"^[\u4E00-\u9FA5\uF900-\uFA2D]{1}[\u4E00-\u9FA5\uF900-\uFA2D0-9]{1,199}$", ErrorMessage = "请输入2至200位，中文开头的字符，可带数字")]
        public String LD_Title { get; set; }

        [DisplayName("目录")]
        [Required(ErrorMessage = "请选择{0}")]
        public Int32 LDC_Id { get; set; }

        [DisplayName("内容")]
        public String LD_Content { get; set; }

        [DisplayName("备注")]
        [MaxLength(200, ErrorMessage="请输入小于200个字符的内容。")]
        public String LD_Remark { get; set; }

        [DisplayName("添加时间")]
        [DataType(DataType.DateTime)]
        public DateTime LD_AddTime { get; set; }

        [DisplayName("状态")]
        [Required(ErrorMessage = "请选择{0}")]
        public Byte LD_Status { get; set; }

        [DisplayName("排序")]
        [Required(ErrorMessage = "请设置{0}")]
        public Double LD_Sort { get; set; }
    }
}