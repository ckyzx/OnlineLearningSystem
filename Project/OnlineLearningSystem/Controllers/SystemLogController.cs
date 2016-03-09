using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using OnlineLearningSystem.Utilities;
using System.ComponentModel;

namespace OnlineLearningSystem.Controllers
{
    public class SystemLogController : OLSController
    {

        USystemLog um = new USystemLog();

        //
        // GET: /SystemLog/

        public ActionResult Index()
        {
            return View();
        }

        //
        // GET: /SystemLog/List

        [Description("系统日志列表")]
        public ActionResult List()
        {
            return View();
        }

        //
        // GET: /SystemLog/ListDataTablesAjax

        [Description("查询系统日志")]
        public JsonResult ListDataTablesAjax()
        {

            DataTablesRequest dtRequest;
            DataTablesResponse dtResponse;

            dtRequest = GetDataTablesRequest();
            dtResponse = um.ListDataTablesAjax(dtRequest);

            return Json(dtResponse, JsonRequestBehavior.DenyGet);
        }
    }
}
