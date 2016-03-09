using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.ComponentModel;

namespace OnlineLearningSystem.Controllers
{
    public class PanelController : OLSController
    {
        //
        // GET: /Panel/

        [Description("控制面板")]
        public ActionResult Index()
        {
            return View();
        }

        //
        // GET: /Panel/Welcome

        [Description("欢迎面板")]
        public ActionResult Welcome()
        {
            return View();
        }

    }
}
