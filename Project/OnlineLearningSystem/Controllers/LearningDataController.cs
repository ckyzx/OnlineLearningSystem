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
    public class LearningDataController : OLSController
    {

        ULearningData um = new ULearningData();

        //
        // GET: /LearningData/

        public ActionResult Index()
        {
            return View();
        }

        //
        // GET: /LearningData/List

        [Description("资料列表")]
        public ActionResult List()
        {

            ViewBag.LearningDataCategoryZTreeJson = new ULearningDataCategory().GetZTreeJson();

            return View();
        }

        //
        // GET: /LearningData/ListStudent

        [Description("资料列表，学员后台")]
        public ActionResult ListStudent()
        {

            ViewBag.LearningDataCategoryZTreeJson = new ULearningDataCategory().GetZTreeJson();

            return View();
        }

        //
        // POST: /LearningData/ListDataTablesAjax

        [Description("查询资料")]
        public JsonResult ListDataTablesAjax(Int32 ldcId = 0)
        {

            DataTablesRequest dtRequest;
            DataTablesResponse dtResponse;

            dtRequest = GetDataTablesRequest();
            dtResponse = um.ListDataTablesAjax(dtRequest, ldcId);

            return Json(dtResponse, JsonRequestBehavior.DenyGet);
        }

        //
        // GET: /LearningData/Create

        [Description("新建资料")]
        [HttpGet]
        public ActionResult Create()
        {

            LearningData m;

            m = um.GetNew();
            ViewBag.categories = um.GetCategoryList(m.LDC_Id);

            return View(m);
        }

        //
        // POST: /LearningData/Create

        [Description("添加资料")]
        [HttpPost]
        [ValidateInput(false)]
        public ActionResult Create(LearningData m)
        {

            if (ModelState.IsValid)
            {

                if (um.Create(m))
                {
                    return Redirect("/Contents/html/parent_reload.htm");
                }
            }

            ViewBag.categories = um.GetCategoryList(m.LDC_Id);

            return View(m);
        }

        //
        // GET: /LearningData/View

        [Description("查看资料")]
        [HttpGet]
        public ActionResult View(Int32 id)
        {

            LearningData m;

            m = um.Get(id);
            ViewBag.categories = um.GetCategoryList(m.LDC_Id);

            return View(m);
        }

        //
        // GET: /LearningData/Edit

        [Description("查看资料")]
        [HttpGet]
        public ActionResult Edit(Int32 id)
        {

            LearningData m;

            m = um.Get(id);
            ViewBag.categories = um.GetCategoryList(m.LDC_Id);

            return View(m);
        }

        //
        // POST: /LearningData/Edit

        [Description("修改资料")]
        [HttpPost]
        [ValidateInput(false)]
        public ActionResult Edit(LearningData m)
        {

            if (ModelState.IsValid)
            {

                if (um.Edit(m))
                {
                    return Redirect("/Contents/html/parent_reload.htm");
                }
            }

            ViewBag.categories = um.GetCategoryList(m.LDC_Id);

            return View(m);
        }

        //
        // GET: /LearningData/Recycle

        [Description("回收资料")]
        public JsonResult Recycle(Int32 id)
        {

            ResponseJson resJson;

            resJson = um.Recycle(id);

            return Json(resJson, JsonRequestBehavior.AllowGet);
        }

        //
        // GET: /LearningData/Resume

        [Description("恢复资料")]
        public JsonResult Resume(Int32 id)
        {

            ResponseJson resJson;

            resJson = um.Resume(id);

            return Json(resJson, JsonRequestBehavior.AllowGet);
        }

        //
        // GET: /LearningData/Delete

        [Description("删除资料")]
        public JsonResult Delete(Int32 id)
        {

            ResponseJson resJson;

            resJson = um.Delete(id);

            return Json(resJson, JsonRequestBehavior.AllowGet);
        }

        //
        // GET: /LearningData/DuplicateName

        [Description("检查资料标题")]
        public JsonResult DuplicateName(Int32 LD_Id, String LD_Title)
        {

            Boolean matching;

            matching = um.DuplicateName(LD_Id, LD_Title);

            return Json(!matching, JsonRequestBehavior.AllowGet);
        }

        //
        // GET: /LearningData/Sort

        [Description("资料排序")]
        public JsonResult Sort(Int32 originId, Byte sortFlag)
        {
            ResponseJson resJson;

            resJson = um.Sort(originId, sortFlag);

            return Json(resJson, JsonRequestBehavior.AllowGet);
        }
    }
}
