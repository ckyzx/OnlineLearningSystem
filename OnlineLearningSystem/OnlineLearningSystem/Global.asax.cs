using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Routing;
using OnlineLearningSystem.Utilities;

namespace OnlineLearningSystem
{
    // Note: For instructions on enabling IIS6 or IIS7 classic mode, 
    // visit http://go.microsoft.com/?LinkId=9394801

    public class MvcApplication : System.Web.HttpApplication
    {
        public static void RegisterGlobalFilters(GlobalFilterCollection filters)
        {
            filters.Add(new HandleErrorAttribute());
        }

        public static void RegisterRoutes(RouteCollection routes)
        {
            routes.IgnoreRoute("{resource}.axd/{*pathInfo}");

            routes.MapRoute(
                "Default", // Route name
                "{controller}/{action}/{id}", // URL with parameters
                new { controller = "Home", action = "Index", id = UrlParameter.Optional } // Parameter defaults
            );

        }

        protected void Application_Start()
        {
            AreaRegistration.RegisterAllAreas();

            RegisterGlobalFilters(GlobalFilters.Filters);
            RegisterRoutes(RouteTable.Routes);

            // 运行定时任务
            /*TimerTask.Run(10 * 60 * 1000, TimerTask.GeneratePaperTemplate);
            TimerTask.Run(5 * 60 * 1000, TimerTask.ChangePaperStatus);
            TimerTask.Run(5 * 60 * 1000, TimerTask.ChangePaperTemplateStatus);*/
            /*TimerTask.Run(1 * 60 * 1000, TimerTask.GeneratePaperTemplate);
            TimerTask.Run(1 * 60 * 1000, TimerTask.ChangePaperStatus);
            TimerTask.Run(1 * 60 * 1000, TimerTask.ChangePaperTemplateStatus);*/
        }

        /*protected void Application_BeginRequest()
        {
            // 当访问根目录时，重定向至起始页
            if (Context.Request.Path == "/")
            {
                Context.RewritePath("/index.htm");
            }
        }*/

    }
}