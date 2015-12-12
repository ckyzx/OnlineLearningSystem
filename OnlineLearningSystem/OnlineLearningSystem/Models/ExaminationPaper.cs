using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;

namespace OnlineLearningSystem.Models
{
    public class ExaminationPaper
    {
        [Key]
        public Int32 EP_Id { get; set; }

        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public Int32 EP_AutoId { get; set; }

        [DisplayName("试卷模板")]
        public Int32 EPT_Id { get; set; }

        [DisplayName("试卷状态")]
        public Byte EP_PaperStatus { get; set; }

        [DisplayName("结束时间")]
        public DateTime EP_EndTime { get; set; }

        [DisplayName("时长")]
        public Int32 EP_TimeSpan { get; set; }

        [DisplayName("用户编号")]
        public Int32 EP_UserId { get; set; }

        [DisplayName("用户名")]
        public String EP_UserName { get; set; }

        [DisplayName("得分")]
        public Int32 EP_Score { get; set; }

        [DisplayName("备注")]
        public String EP_Remark { get; set; }

        [DisplayName("添加时间")]
        public DateTime EP_AddTime { get; set; }

        [DisplayName("状态")]
        public Byte EP_Status { get; set; }

    }
}