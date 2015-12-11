using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;

namespace OnlineLearningSystem.Models
{
    public class ExaminationPaperTemplateQuestion
    {
        [Key]
        public Int32 EPTQ_Id { get; set; }

        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public Int32 EPTQ_AutoId { get; set; }

        public Int32 EPT_Id { get; set; }

        [DisplayName("题型")]
        [Required(ErrorMessage = "请选择{0}")]
        public String EPTQ_Type { get; set; }

        [DisplayName("分类")]
        [Required(ErrorMessage = "请选择{0}")]
        public Int32 EPTQ_Classify { get; set; }

        [DisplayName("难度系数")]
        [Required(ErrorMessage = "请选择{0}")]
        public Byte EPTQ_DifficultyCoefficient { get; set; }

        [DisplayName("分数")]
        [Required(ErrorMessage = "请输入{0}")]
        public Int32 EPTQ_Score { get; set; }

        [DisplayName("内容")]
        [Required(ErrorMessage = "请输入{0}")]
        public String EPTQ_Content { get; set; }

        [DisplayName("备选答案")]
        public String EPTQ_OptionalAnswer { get; set; }

        [DisplayName("标准答案")]
        [Required(ErrorMessage = "请输入{0}")]
        public String EPTQ_ModelAnswer { get; set; }

        [DisplayName("备注")]
        public String EPTQ_Remark { get; set; }

        [DisplayName("添加时间")]
        [DataType(DataType.DateTime)]
        public DateTime EPTQ_AddTime { get; set; }

        [DisplayName("状态")]
        [Required(ErrorMessage = "请选择{0}")]
        public Byte EPTQ_Status { get; set; }

    }
}