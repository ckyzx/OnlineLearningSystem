using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using System.Web.Mvc;

namespace OnlineLearningSystem.Models
{
    public class ExaminationTaskTemplate
    {
        [Key]
        public Int32 ETT_Id { get; set; }

        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public Int32 ETT_AutoId { get; set; }

        [DisplayName("名称")]
        [Required(ErrorMessage="请输入{0}")]
        [Remote("DuplicateName", "ExaminationTaskTemplate", ErrorMessage = "名称已存在", AdditionalFields = "ETT_Id")]
        [RegularExpression(@"^[\u4E00-\u9FA5\uF900-\uFA2D]{1}[\u4E00-\u9FA5\uF900-\uFA2D0-9]{1,11}$", ErrorMessage = "请输入2至12位，中文开头的字符，可带数字")]
        public String ETT_Name { get; set; }

        [DisplayName("任务类型")]
        [Required(ErrorMessage = "请选择{0}")]
        public Byte ETT_Type { get; set; }

        [DisplayName("参与部门")]
        [RegularExpression(@"^\[(\d+,{0,1}\s*)+\]$", ErrorMessage = "请选择参与部门")]
        public String ETT_ParticipatingDepartment { get; set; }

        [DisplayName("参与人员")]
        [RegularExpression(@"^\[(\d+,{0,1}\s*)+\]$", ErrorMessage = "请选择参与人员")]
        public String ETT_Attendee { get; set; }

        [DisplayName("成绩计算")]
        [Required(ErrorMessage = "请选择{0}")]
        [Range(1, 2, ErrorMessage = "请选择{0}")]
        public Byte ETT_StatisticType { get; set; }

        [DisplayName("出题总分")]
        [Required(ErrorMessage = "请输入{0}")]
        [Range(100, 1000, ErrorMessage = "请输入大于 {1} 且小于 {2} 的整数")]
        public Int32 ETT_TotalScore { get; set; }

        [DisplayName("出题数量")]
        [Required(ErrorMessage = "请输入{0}")]
        [Range(10, 1000, ErrorMessage = "请输入大于 {1} 且小于 {2} 的整数")]
        public Int32 ETT_TotalNumber { get; set; }

        [DisplayName("出题难度")]
        [Required(ErrorMessage = "请输入{0}")]
        public Byte ETT_DifficultyCoefficient { get; set; }

        [DisplayName("出题方式")]
        [Required(ErrorMessage = "请选择{0}")]
        public Byte ETT_Mode { get; set; }

        [DisplayName("自动类型")]
        [Required(ErrorMessage = "请选择{0}")]
        public Byte ETT_AutoType { get; set; }

        [DisplayName("考试日期")]
        [Required(ErrorMessage = "请输入{0}")]
        public Byte ETT_AutoOffsetDay { get; set; }

        [DisplayName("出题分类")]
        [Required(ErrorMessage = "请选择{0}")]
        public String ETT_AutoClassifies { get; set; }

        [DisplayName("出题比例")]
        [Required(ErrorMessage = "请输入{0}")]
        public String ETT_AutoRatio { get; set; }

        [DisplayName("开始时间")]
        [DataType(DataType.DateTime)]
        public DateTime ETT_StartTime { get; set; }

        [DisplayName("结束时间")]
        [DataType(DataType.DateTime)]
        public DateTime ETT_EndTime { get; set; }

        [DisplayName("持续天数")]
        public Byte ETT_ContinuedDays { get; set; }

        [DisplayName("考试时长")]
        [Required(ErrorMessage = "请输入{0}")]
        [Range(0, 360, ErrorMessage = "请输入 {1} 至 {2} 之间的整数。")]
        public Int32 ETT_TimeSpan { get; set; }

        [DisplayName("备注")]
        [MaxLength(200, ErrorMessage="请输入小于 {1} 个字符的内容。")]
        public String ETT_Remark { get; set; }

        [DisplayName("添加时间")]
        [DataType(DataType.DateTime)]
        public DateTime ETT_AddTime { get; set; }

        [DisplayName("状态")]
        [Required(ErrorMessage = "请选择{0}")]
        public Byte ETT_Status { get; set; }
    }
}