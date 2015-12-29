using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;

namespace OnlineLearningSystem.Models
{
    [Serializable]
    public class User
    {
        [Key]
        public Int32 U_Id { get; set; }

        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public Int32 U_AutoId { get; set; }

        [DisplayName("职务")]
        public Int32? Du_Id { get; set; }

        [NotMapped]
        public String Du_Name { get; set; }

        [DisplayName("部门")]
        public String U_Departments { get; set; }

        [NotMapped]
        public List<Department> U_DepartmentList { get; set; }

        [DisplayName("角色")]
        public String U_Roles { get; set; }

        [NotMapped]
        public List<Role> U_RoleList { get; set; }

        [NotMapped]
        public List<Permission> U_PermissionList { get; set; }

        [DisplayName("用户名")]
        [Required(ErrorMessage = "请输入{0}")]
        public String U_Name { get; set; }

        [DisplayName("登录名")]
        [Required(ErrorMessage = "请输入{0}")]
        public String U_LoginName { get; set; }

        [DisplayName("密码")]
        [Required(ErrorMessage = "请输入{0}")]
        public String U_Password { get; set; }

        [DisplayName("备注")]
        public String U_Remark { get; set; }

        [DisplayName("添加时间")]
        [DataType(DataType.DateTime)]
        public DateTime U_AddTime { get; set; }

        [DisplayName("状态")]
        [Required(ErrorMessage = "请选择{0}")]
        public Byte U_Status { get; set; }

        [DisplayName("排序")]
        [Required(ErrorMessage = "请设置{0}")]
        public Double U_Sort { get; set; }

        [NotMapped]
        public String U_Score { get; set; }
    }
}