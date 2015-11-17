using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using OnlineLearningSystem.Models;
using OnlineLearningSystem.Utilities;

namespace OnlineLearningSystem.Controllers
{
    public class ActionPermissionController : OLSController
    {
        //
        // GET: /ActionPermission/

        public ActionResult Index()
        {
            return View();
        }

        //
        // GET: /ActionPermission/List

        public ActionResult List()
        {

            List<ActionPermission> aps;

            aps = StaticHelper.GetActionPermission();

            return View(aps);
        }

    }
}
