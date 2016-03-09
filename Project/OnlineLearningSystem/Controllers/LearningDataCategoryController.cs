using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using OnlineLearningSystem.Utilities;
using System.ComponentModel;
using OnlineLearningSystem.Models;

namespace OnlineLearningSystem.Controllers
{
    public class LearningDataCategoryController : OLSController
    {

        ULearningDataCategory um = new ULearningDataCategory();

        //
        // GET: /LearningDataCategory/

        public ActionResult Index()
        {
            return View();
        }

        //
        // GET: /LearningDataCategory/List

        [Description("资料目录列表")]
        public ActionResult List()
        {
            return View();
        }

        //
        // POST: /LearningDataCategory/ListDataTablesAjax

        [Description("查询资料目录")]
        public JsonResult ListDataTablesAjax()
        {

            DataTablesRequest dtRequest;
            DataTablesResponse dtResponse;

            dtRequest = GetDataTablesRequest();
            dtResponse = um.ListDataTablesAjax(dtRequest);

            return Json(dtResponse, JsonRequestBehavior.DenyGet);
        }

        //
        // GET: /LearningDataCategory/Create

        [Description("新建资料目录")]
        [HttpGet]
        public ActionResult Create()
        {

            LearningDataCategory m;

            m = um.GetNew();

            return View(m);
        }

        //
        // POST: /LearningDataCategory/Create

        [Description("添加资料目录")]
        [HttpPost]
        public ActionResult Create(LearningDataCategory m)
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
        // GET: /LearningDataCategory/Edit

        [Description("查看资料目录")]
        [HttpGet]
        public ActionResult Edit(Int32 id)
        {

            LearningDataCategory m;

            m = um.Get(id);

            return View(m);
        }

        //
        // POST: /LearningDataCategory/Edit

        [Description("修改资料目录")]
        [HttpPost]
        public ActionResult Edit(LearningDataCategory m)
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
        // GET: /LearningDataCategory/Recycle

        [Description("回收资料目录")]
        public JsonResult Recycle(Int32 id)
        {

            ResponseJson resJson;

            resJson = um.Recycle(id);

            return Json(resJson, JsonRequestBehavior.AllowGet);
        }

        //
        // GET: /LearningDataCategory/Resume

        [Description("恢复资料目录")]
        public JsonResult Resume(Int32 id)
        {

            ResponseJson resJson;

            resJson = um.Resume(id);

            return Json(resJson, JsonRequestBehavior.AllowGet);
        }

        //
        // GET: /LearningDataCategory/Delete

        [Description("删除资料目录")]
        public JsonResult Delete(Int32 id)
        {

            ResponseJson resJson;

            resJson = um.Delete(id);

            return Json(resJson, JsonRequestBehavior.AllowGet);
        }

        //
        // GET: /LearningDataCategory/DuplicateName

        [Description("检查资料目录名称")]
        public JsonResult DuplicateName(Int32 LDC_Id, String LDC_Name)
        {

            Boolean matching;

            matching = um.DuplicateName(LDC_Id, LDC_Name);

            return Json(!matching, JsonRequestBehavior.AllowGet);
        }

        //
        // GET: /LearningDataCategory/Sort

        [Description("资料目录排序")]
        public JsonResult Sort(Int32 originId, Byte sortFlag)
        {
            ResponseJson resJson;

            resJson = um.Sort(originId, sortFlag);

            return Json(resJson, JsonRequestBehavior.AllowGet);
        }
    }
}
