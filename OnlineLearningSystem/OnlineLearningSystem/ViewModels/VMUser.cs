using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel;
using OnlineLearningSystem.Models;

namespace OnlineLearningSystem.ViewModels
{
    public class VMUser
    {
        public Int32 U_Id { get; set; }

        [DisplayName("职务")]
        [Required(ErrorMessage = "请选择{0}")]
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
        [Remote("DuplicateName", "User", ErrorMessage = "用户名已存在。")]
        [Required(ErrorMessage = "请输入{0}")]
        public String U_Name { get; set; }

        [DisplayName("登录名")]
        [Remote("DuplicateLoginName", "User", ErrorMessage = "登录名已存在。")]
        [Required(ErrorMessage = "请输入{0}")]
        public String U_LoginName { get; set; }

        [DisplayName("旧密码")]
        [Remote("CheckOldPassword", "User", ErrorMessage = "旧密码不正确")]
        [Required(ErrorMessage = "请输入{0}")]
        public String U_OldPassword { get; set; }

        [DisplayName("输入密码")]
        [Required(ErrorMessage = "请输入{0}")]
        public String U_Password { get; set; }

        [DisplayName("重复密码")]
        [Compare("U_Password", ErrorMessage = "重复密码不一致")]
        [Required(ErrorMessage = "请输入{0}")]
        public String U_RePassword { get; set; }

        [DisplayName("备注")]
        public String U_Remark { get; set; }

        [DisplayName("添加时间")]
        [DataType(DataType.DateTime)]
        public DateTime U_AddTime { get; set; }

        [DisplayName("状态")]
        [Required(ErrorMessage = "请选择{0}")]
        public Byte U_Status { get; set; }
    }
}