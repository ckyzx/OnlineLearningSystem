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

        [DisplayName("身份证号")]
        [Remote("DuplicateIdCardNumber", "User", ErrorMessage = "身份证号已存在", AdditionalFields = "U_Id")]
        [Required(ErrorMessage = "请输入{0}")]
        [RegularExpression(@"(^\d{15}$)|(^\d{18}$)|(^\d{17}(\d|X|x)$)", ErrorMessage = "请输入正确格式的身份证号")]
        public String U_IdCardNumber { get; set; }

        [DisplayName("用户名")]
        //[Remote("DuplicateName", "User", ErrorMessage = "用户名已存在", AdditionalFields = "U_Id")]
        [Required(ErrorMessage = "请输入{0}")]
        [RegularExpression(@"^[\u4E00-\u9FA5\uF900-\uFA2D]{1}[\u4E00-\u9FA5\uF900-\uFA2D0-9]{1,11}$", ErrorMessage = "请输入2至12位，中文开头的字符，可带数字")]
        public String U_Name { get; set; }

        [DisplayName("登录名")]
        //[Remote("DuplicateLoginName", "User", ErrorMessage = "登录名已存在", AdditionalFields = "U_Id")]
        [Required(ErrorMessage = "请输入{0}")]
        [RegularExpression(@"^[A-Za-z]{1}[A-Za-z0-9]{4,21}$", ErrorMessage = "请输入5至22位，字母开头的字符，可带数字")]
        public String U_LoginName { get; set; }

        [DisplayName("输入密码")]
        [Required(ErrorMessage = "请输入{0}")]
        [RegularExpression(@"^[\@A-Za-z0-9\!\#\$\%\^\&\*\.\~]{6,22}$", ErrorMessage = "请输入6至22位，字母、数字或英文标点的混合字符")]
        public String U_Password { get; set; }

        [DisplayName("重复密码")]
        [Compare("U_Password", ErrorMessage = "重复密码不一致")]
        [Required(ErrorMessage = "请输入{0}")]
        [RegularExpression(@"^[\@A-Za-z0-9\!\#\$\%\^\&\*\.\~]{6,22}$", ErrorMessage = "请输入6至22位，字母、数字或英文标点的混合字符")]
        public String U_RePassword { get; set; }

        [DisplayName("备注")]
        [MaxLength(200, ErrorMessage="请输入小于200个字符的内容。")]
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
    }
}