using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.ComponentModel;
using OnlineLearningSystem.Utilities;

namespace OnlineLearningSystem.Controllers
{
    public class ExaminationTaskStatisticController : OLSController
    {

        UExaminationTaskStatistic um = new UExaminationTaskStatistic();

        //
        // GET: /ExaminationTaskStatistic/

        public ActionResult Index()
        {
            return View();
        }

        //
        // GET: /ExaminationTaskStatistic/List

        [Description("考试统计列表")]
        public ActionResult List()
        {
            return View();
        }

        //
        // POST: /ExaminationTaskStatistic/ListDataTablesAjax

        [Description("查询考试统计")]
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
