using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Routing;
using System.Timers;
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

            //TimerTask();
        }

        /*protected void Application_BeginRequest()
        {
            // 当访问根目录时，重定向至起始页
            if (Context.Request.Path == "/")
            {
                Context.RewritePath("/index.htm");
            }
        }*/

        private static void TimerTask()
        {
            Timer timer;

            timer = new Timer(24 * 60 * 60 * 1000);
            timer.Elapsed += new ElapsedEventHandler(AutoTask);
            timer.Enabled = true;
            timer.AutoReset = true;
        }

        private static void AutoTask(object source, ElapsedEventArgs e)
        {

            GeneratePaperTemplate gpt;
            ResponseJson resJson;

            gpt = new GeneratePaperTemplate();
            resJson = gpt.Generate();

            //TODO: 记录错误日志
        }
    }
}