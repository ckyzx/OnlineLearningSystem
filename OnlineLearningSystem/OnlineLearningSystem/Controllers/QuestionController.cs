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
    public class QuestionController : OLSController
    {

        UQuestion um = new UQuestion();

        //
        // GET: /Question/

        public ActionResult Index()
        {
            return View();
        }

        //
        // GET: /Question/List

        [Description("试题列表")]
        public ActionResult List()
        {
            return View();
        }

        //
        // POST: /Question/ListDataTablesAjax

        [Description("查询试题")]
        public JsonResult ListDataTablesAjax()
        {

            DataTablesRequest dtRequest;
            DataTablesResponse dtResponse;

            dtRequest = GetDataTablesRequest();
            dtResponse = um.ListDataTablesAjax(dtRequest);

            return Json(dtResponse, JsonRequestBehavior.DenyGet);
        }

        //
        // GET: /Question/DocxUploadAndImport

        [Description("试题上传")]
        public ActionResult DocxUploadAndImport()
        {
            return View();
        }

        //
        // GET: /Question/Import

        [Description("试题导入")]
        public JsonResult Import(String filePath)
        {

            filePath = Server.MapPath(filePath);

            return Json(new UQuestion().ImportDocx(filePath));
        }

        //
        // GET: /Question/Create

        [Description("新建试题")]
        [HttpGet]
        public ActionResult Create()
        {

            Question m;

            m = um.GetNew();

            ViewBag.Types = um.GetTypeList(m.Q_Type);
            ViewBag.Classifies = um.GetClassifyList(m.QC_Id);

            return View(m);
        }

        //
        // POST: /Question/Create

        [Description("添加试题")]
        [HttpPost]
        public ActionResult Create(Question m)
        {

            if (ModelState.IsValid)
            {

                if (um.Create(m))
                {
                    return Redirect("/Content/html/parent_reload.htm");
                }
            }

            ViewBag.Types = um.GetTypeList(m.Q_Type);
            ViewBag.Classifies = um.GetClassifyList(m.QC_Id);

            return View(m);
        }

        //
        // GET: /Question/Edit

        [Description("查看试题")]
        [HttpGet]
        public ActionResult Edit(Int32 id)
        {

            Question m;

            m = um.Get(id);

            ViewBag.Types = um.GetTypeList(m.Q_Type);
            ViewBag.Classifies = um.GetClassifyList(m.QC_Id);

            return View(m);
        }

        //
        // POST: /Question/Edit

        [Description("编辑试题")]
        [HttpPost]
        public ActionResult Edit(Question m)
        {

            if (ModelState.IsValid)
            {

                if (um.Edit(m))
                {
                    return Redirect("/Content/html/parent_reload.htm");
                }
            }

            ViewBag.Types = um.GetTypeList(m.Q_Type);
            ViewBag.Classifies = um.GetClassifyList(m.QC_Id);

            return View(m);
        }

        //
        // GET: /Question/Recycle

        [Description("回收试题")]
        public JsonResult Recycle(Int32 id)
        {

            ResponseJson resJson;

            resJson = um.Recycle(id);

            return Json(resJson,JsonRequestBehavior.AllowGet);
        }

        //
        // GET: /Question/Resume

        [Description("恢复试题")]
        public JsonResult Resume(Int32 id)
        {

            ResponseJson resJson;

            resJson = um.Resume(id);

            return Json(resJson, JsonRequestBehavior.AllowGet);
        }

        //
        // GET: /Question/Delete

        [Description("删除试题")]
        public JsonResult Delete(Int32 id)
        {

            ResponseJson resJson;

            resJson = um.Delete(id);

            return Json(resJson, JsonRequestBehavior.AllowGet);
        }

        //
        // GET: /Question/SetDifficultyCoefficient

        [Description("设置难度系数")]
        public JsonResult SetDifficultyCoefficient(Int32 id, Byte coefficient)
        {

            ResponseJson resJson;

            resJson = um.SetDifficultyCoefficient(id, coefficient);

            return Json(resJson, JsonRequestBehavior.AllowGet);
        }
    }
}
