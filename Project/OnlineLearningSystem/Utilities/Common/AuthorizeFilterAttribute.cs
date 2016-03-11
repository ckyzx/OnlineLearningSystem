using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using OnlineLearningSystem.Models;

namespace OnlineLearningSystem.Utilities
{
    public class AuthorizeFilterAttribute:ActionFilterAttribute
    {
        public override void OnActionExecuting(ActionExecutingContext filterContext)
        {

            //[禁用权限验证]
            //return;

            String path, controller, action;
            User u;
            List<Permission> ps;
            Int32 pCount;

            if (null == filterContext)
            {
                throw new ArgumentNullException();
            }

            path = filterContext.HttpContext.Request.Path.ToLower();

            if (path == "/user/login" || path == "/user/logout")
            {
                return;
            }

            controller = filterContext.RouteData.Values["controller"].ToString().ToLower();
            action = filterContext.RouteData.Values["action"].ToString().ToLower();

            u = (User)filterContext.HttpContext.Session["User"];

            if (null == u)
            {
                filterContext.Result = new ContentResult { Content = @"<script>alert('您尚未登录系统！');location.href='/Contents/html/goto_login.htm';</script>" };
                return;
            }

            ps = u.U_PermissionList;

            pCount = ps.Where(m => 
                m.P_Controller.ToLower() == controller 
                && m.P_Action.ToLower() == action).Count();

            if (pCount == 0)
            {
                filterContext.Result = new ContentResult { Content = @"<script>alert('抱歉，您不具有当前操作的权限！');</script>" };
            }
        }
    }
}