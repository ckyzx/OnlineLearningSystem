using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel;
using System.Web.Mvc;

namespace OnlineLearningSystem.Models
{
    public class QuestionClassify
    {
        [Key]
        public Int32 QC_Id { get; set; }

        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public Int32 QC_AutoId { get; set; }

        [DisplayName("名称")]
        [Remote("DuplicateName", "QuestionClassify", ErrorMessage = "名称已存在", AdditionalFields = "QC_Id")]
        [Required(ErrorMessage = "请输入{0}")]
        [RegularExpression(@"^[\u4E00-\u9FA5\uF900-\uFA2D]{1}[\u4E00-\u9FA5\uF900-\uFA2D0-9、，。-：“”（）【】]{1,99}$", ErrorMessage = "请输入2至100位，中文开头的字符，可带数字、中文标点")]
        public String QC_Name { get; set; }

        [DisplayName("层级")]
        public String QC_Level { get; set; }

        [DisplayName("备注")]
        [MaxLength(200, ErrorMessage="请输入小于200个字符的内容。")]
        public String QC_Remark { get; set; }

        [DisplayName("添加时间")]
        [DataType(DataType.DateTime)]
        public DateTime QC_AddTime { get; set; }

        [DisplayName("状态")]
        [Required(ErrorMessage = "请选择{0}")]
        public Byte QC_Status { get; set; }
    }
}