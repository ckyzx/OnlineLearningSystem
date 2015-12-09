using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;

namespace OnlineLearningSystem.Models
{
    public class Question
    {
        [Key]
        public Int32 Q_Id { get; set; }

        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public Int32 Q_AutoId { get; set; }

        [DisplayName("题型")]
        [Required(ErrorMessage="请选择{0}")]
        public String Q_Type { get; set; }

        [DisplayName("分类")]
        [Required(ErrorMessage = "请选择{0}")]
        public Int32 QC_Id { get; set; }

        [NotMapped]
        public String QC_Name { get; set; }

        [DisplayName("难度系数")]
        [Required(ErrorMessage = "请选择{0}")]
        public Byte Q_DifficultyCoefficient { get; set; }

        [DisplayName("分数")]
        [Required(ErrorMessage = "请输入{0}")]
        public Int32 Q_Score { get; set; }

        [DisplayName("内容")]
        [Required(ErrorMessage = "请输入{0}")]
        public String Q_Content { get; set; }

        [DisplayName("备选答案")]
        public String Q_OptionalAnswer { get; set; }

        [DisplayName("标准答案")]
        [Required(ErrorMessage = "请输入{0}")]
        public String Q_ModelAnswer { get; set; }

        [DisplayName("备注")]
        public String Q_Remark { get; set; }

        [DisplayName("添加时间")]
        [DataType(DataType.DateTime)]
        public DateTime Q_AddTime { get; set; }

        [DisplayName("状态")]
        [Required(ErrorMessage = "请选择{0}")]
        public Byte Q_Status { get; set; }

    }
}