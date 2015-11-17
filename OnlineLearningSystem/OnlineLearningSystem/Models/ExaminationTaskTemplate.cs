using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;

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
        public String ETT_Name { get; set; }

        [DisplayName("任务类型")]
        [Required(ErrorMessage = "请选择{0}")]
        public Byte ETT_Type { get; set; }

        [DisplayName("出题方式")]
        [Required(ErrorMessage = "请选择{0}")]
        public Byte ETT_Mode { get; set; }

        [DisplayName("出题难度")]
        [Required(ErrorMessage = "请输入{0}")]
        public Byte ETT_DifficultyCoefficient { get; set; }

        [DisplayName("参与部门")]
        public String ETT_ParticipatingDepartment { get; set; }

        [DisplayName("参与人员")]
        public String ETT_Attendee { get; set; }

        [DisplayName("自动类型")]
        [Required(ErrorMessage = "请选择{0}")]
        public Byte ETT_AutoType { get; set; }

        [DisplayName("自动偏移日")]
        [Required(ErrorMessage = "请输入{0}")]
        public Byte ETT_AutoOffsetDay { get; set; }

        [DisplayName("开始时间")]
        [DataType(DataType.DateTime)]
        public DateTime ETT_StartTime { get; set; }

        [DisplayName("结束时间")]
        [DataType(DataType.DateTime)]
        public DateTime ETT_EndTime { get; set; }

        [DisplayName("时长")]
        [Required(ErrorMessage = "请输入{0}")]
        public Int32 ETT_TimeSpan { get; set; }

        [DisplayName("备注")]
        public String ETT_Remark { get; set; }

        [DisplayName("添加时间")]
        [DataType(DataType.DateTime)]
        public DateTime ETT_AddTime { get; set; }

        [DisplayName("状态")]
        [Required(ErrorMessage = "请选择{0}")]
        public Byte ETT_Status { get; set; }
    }
}