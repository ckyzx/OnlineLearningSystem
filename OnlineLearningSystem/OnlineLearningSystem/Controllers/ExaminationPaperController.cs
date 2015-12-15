using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using OnlineLearningSystem.Models;
using OnlineLearningSystem.Utilities;
using System.ComponentModel;

namespace OnlineLearningSystem.Controllers
{
    public class ExaminationPaperController : OLSController
    {

        UExaminationPaper um = new UExaminationPaper();

        //
        // GET: /ExaminationPaper/

        public ActionResult Index()
        {
            return View();
        }

        //
        // GET: /ExaminationPaper/Paper

        [Description("试卷")]
        public ActionResult Paper()
        {
            return View();
        }

        //
        // GET: /ExaminationPaper/ListGrade

        [Description("打分列表")]
        public ActionResult ListGrade()
        {
            return View();
        }

        //
        // POST: /ExaminationPaper/GetQuestions

        [Description("获取试题")]
        public JsonResult GetQuestions(Int32 epId)
        {

            User u;
            ResponseJson resJson;

            u = (User)Session["User"];

            resJson = um.GetQuestions(epId, u.U_Id);

            return Json(resJson, JsonRequestBehavior.DenyGet);
        }

        //
        // POST: /ExaminationPaper/SubmitAnswers

        [Description("提交答案")]
        public JsonResult SubmitAnswers(String answersJson)
        {

            ResponseJson resJson;

            resJson = um.SubmitAnswers(answersJson);

            return Json(resJson, JsonRequestBehavior.AllowGet);
        }
    }
}
