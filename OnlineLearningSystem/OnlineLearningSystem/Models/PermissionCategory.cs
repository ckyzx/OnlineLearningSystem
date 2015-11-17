using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;

namespace OnlineLearningSystem.Models
{
    public class PermissionCategory
    {
        [Key]
        public Int32 PC_Id { get; set; }

        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public Int32 PC_AutoId { get; set; }

        [DisplayName("名称")]
        [Required(ErrorMessage = "请输入{0}")]
        public String PC_Name { get; set; }

        [DisplayName("层级")]
        public String PC_Level { get; set; }

        [DisplayName("操作权限")]
        [NotMapped]
        public String PC_Permissions { get; set; }

        [DisplayName("备注")]
        public String PC_Remark { get; set; }

        [DisplayName("添加时间")]
        [DataType(DataType.DateTime)]
        public DateTime PC_AddTime { get; set; }

        [DisplayName("状态")]
        [Required(ErrorMessage = "请选择{0}")]
        public Byte PC_Status { get; set; }
    }
}