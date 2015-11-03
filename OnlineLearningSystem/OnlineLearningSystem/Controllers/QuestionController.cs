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

        UQuestion uq = new UQuestion();

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
        // POST: /Question/ListDataTablesAjax

        public JsonResult ListDataTablesAjax()
        {

            DataTablesRequest dtRequest;

            dtRequest = GetDataTablesRequest();

            return Json(new UQuestion().ListDataTablesAjax(dtRequest), JsonRequestBehavior.DenyGet);
        }

        //
        // GET: /Question/DocxUploadAndImport

        public ActionResult DocxUploadAndImport()
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

        //
        // GET: /Question/Create

        [HttpGet]
        public ActionResult Create()
        {

            Question q;

            q = uq.GetNew();

            ViewBag.Types = uq.GetTypeList(q.Q_Type);
            ViewBag.Classifies = uq.GetClassifyList(q.Q_Classify);

            return View(q);
        }

        //
        // POST: /Question/Create

        [HttpPost]
        public ActionResult Create(Question q)
        {

            if (ModelState.IsValid)
            {

                if (uq.Create(q))
                {
                    return RedirectToAction("List");
                }
            }

            ViewBag.Types = uq.GetTypeList(q.Q_Type);
            ViewBag.Classifies = uq.GetClassifyList(q.Q_Classify);

            return View(q);
        }

        // GET: /Question/Edit

        public ActionResult Edit(String id)
        {
            return View();
        }

        // POST: /Question/Edit

        public ActionResult Edit(Question q)
        {
            return View();
        }

        //
        // GET: /Question/Recycle

        public JsonResult Recycle(String id)
        {
            return Json(0);
        }

        //
        // GET: /Question/Delete

        public JsonResult Delete(String id)
        {
            return Json(0);
        }
    }
}
