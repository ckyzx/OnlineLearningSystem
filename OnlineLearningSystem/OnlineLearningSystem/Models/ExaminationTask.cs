using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using System.Web.Mvc;

namespace OnlineLearningSystem.Models
{
    public class ExaminationTask
    {
        [Key]
        public Int32 ET_Id { get; set; }

        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public Int32 ET_AutoId { get; set; }

        [DisplayName("名称")]
        [Required(ErrorMessage = "请输入{0}")]
        [Remote("DuplicateName", "ExaminationTask", ErrorMessage = "名称已存在", AdditionalFields = "ET_Id")]
        [RegularExpression(@"^[\u4E00-\u9FA5\uF900-\uFA2D]{1}[\u4E00-\u9FA5\uF900-\uFA2D0-9]{1,11}$", ErrorMessage = "请输入2至12位，中文开头的字符，可带数字")]
        public String ET_Name { get; set; }

        [DisplayName("启用状态")]
        [Required(ErrorMessage = "请选择{0}")]
        public Byte ET_Enabled { get; set; }

        [NotMapped]
        [DisplayName("任务模板")]
        public String ET_Template { get; set; }

        [DisplayName("任务类型")]
        [Required(ErrorMessage = "请选择{0}")]
        public Byte ET_Type { get; set; }

        [DisplayName("参与部门")]
        [RegularExpression(@"^\[(\d+,{0,1}\s*)+\]$", ErrorMessage = "请选择参与部门")]
        public String ET_ParticipatingDepartment { get; set; }

        [DisplayName("参与人员")]
        [RegularExpression(@"^\[(\d+,{0,1}\s*)+\]$", ErrorMessage = "请选择参与人员")]
        public String ET_Attendee { get; set; }

        [DisplayName("成绩计算")]
        [Required(ErrorMessage = "请选择{0}")]
        [Range(1, 2, ErrorMessage = "请选择{0}")]
        public Byte ET_StatisticType { get; set; }

        [DisplayName("出题总分")]
        [Required(ErrorMessage = "请输入{0}")]
        [Range(100, 1000, ErrorMessage = "请输入大于100且小于1000的整数")]
        public Int32 ET_TotalScore { get; set; }

        [DisplayName("出题难度")]
        [Required(ErrorMessage = "请输入{0}")]
        public Byte ET_DifficultyCoefficient { get; set; }

        [DisplayName("出题数量")]
        [Required(ErrorMessage = "请输入{0}")]
        [Range(10, 1000, ErrorMessage = "请输入大于10且小于1000的整数")]
        public Int32 ET_TotalNumber { get; set; }

        [DisplayName("出题方式")]
        [Required(ErrorMessage = "请选择{0}")]
        public Byte ET_Mode { get; set; }

        [DisplayName("自动类型")]
        [Required(ErrorMessage = "请选择{0}")]
        public Byte ET_AutoType { get; set; }

        [DisplayName("考试日期")]
        [Required(ErrorMessage = "请输入{0}")]
        public Byte ET_AutoOffsetDay { get; set; }

        [DisplayName("出题分类")]
        [Required(ErrorMessage = "请选择{0}")]
        public String ET_AutoClassifies { get; set; }

        [DisplayName("出题比例")]
        [Required(ErrorMessage = "请输入{0}")]
        public String ET_AutoRatio { get; set; }

        [DisplayName("开始时间")]
        [DataType(DataType.DateTime)]
        public DateTime ET_StartTime { get; set; }

        [DisplayName("结束时间")]
        [DataType(DataType.DateTime)]
        public DateTime ET_EndTime { get; set; }

        [DisplayName("考试时长")]
        [Required(ErrorMessage = "请输入{0}")]
        [Range(10, 360, ErrorMessage = "请输入{1}至{2}之间的数字。")]
        public Int32 ET_TimeSpan { get; set; }

        [DisplayName("试卷模板")]
        public String ET_PaperTemplates { get; set; }

        [DisplayName("试题")]
        public String ET_Questions { get; set; }

        [DisplayName("备注")]
        [MaxLength(200, ErrorMessage="请输入小于{1}个字符的内容。")]
        public String ET_Remark { get; set; }

        [DisplayName("添加时间")]
        [DataType(DataType.DateTime)]
        public DateTime ET_AddTime { get; set; }

        [DisplayName("状态")]
        [Required(ErrorMessage = "请选择{0}")]
        public Byte ET_Status { get; set; }

    }
}