using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;

namespace OnlineLearningSystem.Models
{
    public class Role
    {
        [Key]
        public Int32 R_Id { get; set; }

        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public Int32 R_AutoId { get; set; }

        [DisplayName("名称")]
        [Required(ErrorMessage = "请输入{0}")]
        public String R_Name { get; set; }

        [DisplayName("操作权限")]
        public String R_Permissions { get; set; }

        [DisplayName("权限目录")]
        public String R_PermissionCategories { get; set; }

        [DisplayName("备注")]
        public String R_Remark { get; set; }

        [DisplayName("添加时间")]
        [DataType(DataType.DateTime)]
        public DateTime R_AddTime { get; set; }

        [DisplayName("状态")]
        [Required(ErrorMessage = "请选择{0}")]
        public Byte R_Status { get; set; }
    }
}