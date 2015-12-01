using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;

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
        public String ET_Name { get; set; }

        [NotMapped]
        [DisplayName("任务模板")]
        public String ET_Template { get; set; }

        [DisplayName("任务类型")]
        [Required(ErrorMessage = "请选择{0}")]
        public Byte ET_Type { get; set; }

        [DisplayName("出题方式")]
        [Required(ErrorMessage = "请选择{0}")]
        public Byte ET_Mode { get; set; }

        [DisplayName("出题难度")]
        [Required(ErrorMessage = "请输入{0}")]
        public Byte ET_DifficultyCoefficient { get; set; }

        [DisplayName("参与部门")]
        public String ET_ParticipatingDepartment { get; set; }

        [DisplayName("参与人员")]
        public String ET_Attendee { get; set; }

        [DisplayName("自动类型")]
        [Required(ErrorMessage = "请选择{0}")]
        public Byte ET_AutoType { get; set; }

        [DisplayName("自动偏移日")]
        [Required(ErrorMessage = "请输入{0}")]
        public Byte ET_AutoOffsetDay { get; set; }

        [DisplayName("开始时间")]
        [DataType(DataType.DateTime)]
        public DateTime ET_StartTime { get; set; }

        [DisplayName("结束时间")]
        [DataType(DataType.DateTime)]
        public DateTime ET_EndTime { get; set; }

        [DisplayName("时长")]
        [Required(ErrorMessage = "请输入{0}")]
        public Int32 ET_TimeSpan { get; set; }

        [DisplayName("试卷模板")]
        public String ET_PaperTemplates { get; set; }

        [DisplayName("试题")]
        public String ET_Questions { get; set; }

        [DisplayName("备注")]
        public String ET_Remark { get; set; }

        [DisplayName("添加时间")]
        [DataType(DataType.DateTime)]
        public DateTime ET_AddTime { get; set; }

        [DisplayName("状态")]
        [Required(ErrorMessage = "请选择{0}")]
        public Byte ET_Status { get; set; }

        [NotMapped]
        [DisplayName("模板状态")]
        public Byte EPT_PaperTemplateStatus { get; set; }
    }
}