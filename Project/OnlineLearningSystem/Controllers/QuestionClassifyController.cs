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
    public class QuestionClassifyController : OLSController
    {

        UQuestionClassify um = new UQuestionClassify();

        //
        // GET: /QuestionClassify/

        public ActionResult Index()
        {
            return View();
        }

        //
        // GET: /QuestionClassify/List

        [Description("试题分类列表")]
        public ActionResult List()
        {
            return View();
        }

        //
        // POST: /QuestionClassify/ListDataTablesAjax

        [Description("查询试题分类")]
        public JsonResult ListDataTablesAjax()
        {

            DataTablesRequest dtRequest;
            DataTablesResponse dtResponse;

            dtRequest = GetDataTablesRequest();
            dtResponse = um.ListDataTablesAjax(dtRequest);

            return Json(dtResponse, JsonRequestBehavior.DenyGet);
        }

        //
        // GET: /QuestionClassify/Create

        [Description("新建试题分类")]
        [HttpGet]
        public ActionResult Create()
        {

            QuestionClassify m;

            m = um.GetNew();

            return View(m);
        }

        //
        // POST: /QuestionClassify/Create

        [Description("添加试题分类")]
        [HttpPost]
        public ActionResult Create(QuestionClassify m)
        {

            if (ModelState.IsValid)
            {

                if (um.Create(m))
                {
                    return Redirect("/Contents/html/parent_reload.htm");
                }
            }

            return View(m);
        }

        //
        // GET: /QuestionClassify/Edit

        [Description("查看试题分类")]
        [HttpGet]
        public ActionResult Edit(Int32 id)
        {

            QuestionClassify m;

            m = um.Get(id);

            return View(m);
        }

        //
        // POST: /QuestionClassify/Edit

        [Description("修改试题分类")]
        [HttpPost]
        public ActionResult Edit(QuestionClassify m)
        {

            if (ModelState.IsValid)
            {

                if (um.Edit(m))
                {
                    return Redirect("/Contents/html/parent_reload.htm");
                }
            }

            return View(m);
        }

        //
        // GET: /QuestionClassify/Recycle

        [Description("回收试题分类")]
        public JsonResult Recycle(Int32 id)
        {

            ResponseJson resJson;

            resJson = um.Recycle(id);

            return Json(resJson, JsonRequestBehavior.AllowGet);
        }

        //
        // GET: /QuestionClassify/Resume

        [Description("恢复试题分类")]
        public JsonResult Resume(Int32 id)
        {

            ResponseJson resJson;

            resJson = um.Resume(id);

            return Json(resJson, JsonRequestBehavior.AllowGet);
        }

        //
        // GET: /QuestionClassify/Delete

        [Description("删除试题分类")]
        public JsonResult Delete(Int32 id)
        {

            ResponseJson resJson;

            resJson = um.Delete(id);

            return Json(resJson, JsonRequestBehavior.AllowGet);
        }

        //
        // GET: /QuestionClassify/DuplicateName

        [Description("检查试题分类名称")]
        public JsonResult DuplicateName(Int32 QC_Id, String QC_Name)
        {

            Boolean matching;

            matching = um.DuplicateName(QC_Id, QC_Name);

            return Json(!matching, JsonRequestBehavior.AllowGet);
        }

        //
        // GET: /QuestionClassify/GetZTreeResJson

        [Description("获取试题分类树表数据")]
        public JsonResult GetZTreeResJson(Byte status)
        {
            ResponseJson resJson;
            resJson = new UQuestionClassify().GetZTreeResJson(status);
            return Json(resJson, JsonRequestBehavior.AllowGet);
        }
    }
}
