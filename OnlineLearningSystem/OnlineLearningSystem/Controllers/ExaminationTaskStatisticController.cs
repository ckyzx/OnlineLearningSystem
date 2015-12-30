using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.ComponentModel;
using OnlineLearningSystem.Models;
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

        //
        // GET: /ExaminationTaskStatistic/ListUser

        [Description("用户考试统计列表")]
        public ActionResult ListUser()
        {
            return View();
        }

        //
        // POST: /ExaminationTaskStatistic/ListUserDataTablesAjax

        [Description("查询用户考试统计")]
        public JsonResult ListUserDataTablesAjax(Int32 eptId)
        {

            DataTablesRequest dtRequest;
            DataTablesResponse dtResponse;

            dtRequest = GetDataTablesRequest();
            dtResponse = um.ListUserDataTablesAjax(dtRequest, eptId);

            return Json(dtResponse, JsonRequestBehavior.DenyGet);
        }

        //
        // GET: /ExaminationTaskStatistic/Personal

        public ActionResult Personal()
        {

            Int32 uId;
            User u;

            u = (User)Session["User"];
            uId = u.U_Id;

            return View(um.GetPersonalStatistic(uId));
        }
    }
}
