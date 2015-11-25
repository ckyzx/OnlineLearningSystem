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
    public class VMUserModifyPassword
    {
        [DisplayName("旧密码")]
        [Remote("CheckOldPassword", "User", ErrorMessage = "旧密码不正确")]
        [Required(ErrorMessage = "请输入{0}")]
        public String U_OldPassword { get; set; }

        [DisplayName("输入密码")]
        [Required(ErrorMessage = "请输入{0}")]
        [RegularExpression(@"^[\@A-Za-z0-9\!\#\$\%\^\&\*\.\~]{6,22}$", ErrorMessage = "请输入6至22位，字母、数字或英文标点的混合字符")]
        public String U_Password { get; set; }

        [DisplayName("重复密码")]
        [Compare("U_Password", ErrorMessage = "重复密码不一致")]
        [Required(ErrorMessage = "请输入{0}")]
        [RegularExpression(@"^[\@A-Za-z0-9\!\#\$\%\^\&\*\.\~]{6,22}$", ErrorMessage = "请输入6至22位，字母、数字或英文标点的混合字符")]
        public String U_RePassword { get; set; }

    }
}