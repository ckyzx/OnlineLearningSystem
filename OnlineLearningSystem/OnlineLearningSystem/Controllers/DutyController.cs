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
    public class DutyController : OLSController
    {

        UDuty um = new UDuty();

        //
        // GET: /Duty/

        public ActionResult Index()
        {
            return View();
        }

        //
        // GET: /Duty/List

        [Description("职务列表")]
        public ActionResult List()
        {
            return View();
        }

        //
        // POST: /Duty/ListDataTablesAjax

        [Description("查询职务")]
        public JsonResult ListDataTablesAjax()
        {

            DataTablesRequest dtRequest;
            DataTablesResponse dtResponse;

            dtRequest = GetDataTablesRequest();
            dtResponse = um.ListDataTablesAjax(dtRequest);

            return Json(dtResponse, JsonRequestBehavior.DenyGet);
        }

        //
        // GET: /Duty/Create

        [Description("新建职务")]
        [HttpGet]
        public ActionResult Create()
        {

            Duty m;

            m = um.GetNew();

            return View(m);
        }

        //
        // POST: /Duty/Create

        [Description("添加职务")]
        [HttpPost]
        public ActionResult Create(Duty m)
        {

            if (ModelState.IsValid)
            {

                if (um.Create(m))
                {
                    return Redirect("/Content/html/parent_reload.htm");
                }
            }

            return View(m);
        }

        //
        // GET: /Duty/Edit

        [Description("查看职务")]
        [HttpGet]
        public ActionResult Edit(Int32 id)
        {

            Duty m;

            m = um.Get(id);

            return View(m);
        }

        //
        // POST: /Duty/Edit

        [Description("修改职务")]
        [HttpPost]
        public ActionResult Edit(Duty m)
        {

            if (ModelState.IsValid)
            {

                if (um.Edit(m))
                {
                    return Redirect("/Content/html/parent_reload.htm");
                }
            }

            return View(m);
        }

        //
        // GET: /Duty/Recycle

        [Description("回收职务")]
        public JsonResult Recycle(Int32 id)
        {

            ResponseJson resJson;

            resJson = um.Recycle(id);

            return Json(resJson, JsonRequestBehavior.AllowGet);
        }

        //
        // GET: /Duty/Resume

        [Description("恢复职务")]
        public JsonResult Resume(Int32 id)
        {

            ResponseJson resJson;

            resJson = um.Resume(id);

            return Json(resJson, JsonRequestBehavior.AllowGet);
        }

        //
        // GET: /Duty/Delete

        [Description("删除职务")]
        public JsonResult Delete(Int32 id)
        {

            ResponseJson resJson;

            resJson = um.Delete(id);

            return Json(resJson, JsonRequestBehavior.AllowGet);
        }

        //
        // GET: /Duty/DuplicateName

        [Description("检查职务名称")]
        public JsonResult DuplicateName(Int32 Du_Id, String Du_Name)
        {

            Boolean matching;

            matching = um.DuplicateName(Du_Id, Du_Name);

            return Json(!matching, JsonRequestBehavior.AllowGet);
        }

        //
        // GET: /Duty/Sort

        [Description("职务排序")]
        public JsonResult Sort(Int32 originId, Byte sortFlag)
        {
            ResponseJson resJson;

            resJson = um.Sort(originId, sortFlag);

            return Json(resJson, JsonRequestBehavior.AllowGet);
        }
    }
}
