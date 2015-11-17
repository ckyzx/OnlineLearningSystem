using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;

namespace OnlineLearningSystem.Models
{
    public class ExaminationPaperTemplate
    {
        [Key]
        public Int32 EPT_Id { get; set; }

        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public Int32 EPT_AutoId { get; set; }

        public Int32 ET_Id { get; set; }

        public Byte ET_Type { get; set; }

        [DisplayName("试卷模板状态")]
        public Byte EPT_PaperTemplateStatus { get; set; }

        [DisplayName("开始时间")]
        [DataType(DataType.DateTime)]
        public DateTime EPT_StartTime { get; set; }

        [DisplayName("结束时间")]
        [DataType(DataType.DateTime)]
        public DateTime EPT_EndTime { get; set; }

        [DisplayName("时长")]
        public Int32 EPT_TimeSpan { get; set; }

        [DisplayName("试题模板")]
        public String EPT_Questions { get; set; }

        [DisplayName("备注")]
        public String EPT_Remark { get; set; }

        [DisplayName("添加时间")]
        [DataType(DataType.DateTime)]
        public DateTime EPT_AddTime { get; set; }

        [DisplayName("状态")]
        [Required(ErrorMessage = "请选择{0}")]
        public Byte EPT_Status { get; set; }
    }
}