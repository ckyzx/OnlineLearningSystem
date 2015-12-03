using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;

namespace OnlineLearningSystem.Models
{
    [Serializable]
    public class Permission
    {
        [Key]
        public Int32 P_Id { get; set; }

        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public Int32 P_AutoId{get;set;}

        public Int32 PC_Id { get; set; }

        [ForeignKey("PC_Id")]
        public PermissionCategory PermissionCategory { get; set; }

        [DisplayName("名称")]
        [Required(ErrorMessage = "请输入{0}")]
        public String P_Name { get; set; }

        [DisplayName("控制器")]
        [Required(ErrorMessage = "请输入{0}")]
        public String P_Controller { get; set; }

        [DisplayName("行为")]
        [Required(ErrorMessage = "请输入{0}")]
        public String P_Action { get; set; }

        [DisplayName("备注")]
        public String P_Remark { get; set; }

        [DisplayName("添加时间")]
        [DataType(DataType.DateTime)]
        public DateTime P_AddTime { get; set; }
    }
}