using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using OnlineLearningSystem.Models;
using OnlineLearningSystem.Utilities;

namespace OnlineLearningSystem.Controllers
{
    public class QuestionController : OLSController
    {
        //
        // GET: /Question/

        public ActionResult Index()
        {
            return View();
        }

        //
        // GET: /Question/List

        public ActionResult List()
        {
            return View(new List<Question>());
        }

        //
        // GET: /Question/ListDataTablesAjax

        public JsonResult ListDataTablesAjax()
        {

            DataTablesRequest dtRequest;

            dtRequest = GetDataTablesRequest();

            return Json(new UQuestion().ListDataTablesAjax(dtRequest), JsonRequestBehavior.DenyGet);
        }

        //
        // GET: /Question/UploadAndImport

        public ActionResult UploadAndImport()
        {
            return View();
        }

        //
        // GET: /Question/Import

        public JsonResult Import(String filePath)
        {

            filePath = Server.MapPath(filePath);

            return Json(new UQuestion().ImportDocx(filePath));
        }
    }
}
