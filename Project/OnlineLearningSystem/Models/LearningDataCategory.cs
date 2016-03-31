using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;

namespace OnlineLearningSystem.Models
{
    public class LearningDataCategory
    {
        [Key]
        public Int32 LDC_Id { get; set; }

        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public Int32 LDC_AutoId { get; set; }

        [DisplayName("名称")]
        [Remote("DuplicateName", "LearningDataCategory", ErrorMessage = "名称已存在", AdditionalFields = "LDC_Id")]
        [Required(ErrorMessage = "请输入{0}")]
        [RegularExpression(@"^[\u4E00-\u9FA5\uF900-\uFA2D0-9、，。：“”（）【】~\!\@\#\$\%\^\&\*\(\)_\+\-\=\[\]\{\};'\\\:""\|\,\.\/\<\>\?]{2,200}$", ErrorMessage = "请输入 2 至 200 位，包含中文、数字和标点的字符。")]
        public String LDC_Name { get; set; }

        [DisplayName("备注")]
        [MaxLength(200, ErrorMessage="请输入小于200个字符的内容。")]
        public String LDC_Remark { get; set; }

        [DisplayName("添加时间")]
        [DataType(DataType.DateTime)]
        public DateTime LDC_AddTime { get; set; }

        [DisplayName("状态")]
        [Required(ErrorMessage = "请选择{0}")]
        public Byte LDC_Status { get; set; }

        [DisplayName("排序")]
        [Required(ErrorMessage = "请设置{0}")]
        public Double LDC_Sort { get; set; }
    }
}