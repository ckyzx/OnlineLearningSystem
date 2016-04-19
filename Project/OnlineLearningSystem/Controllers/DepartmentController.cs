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
    public class DepartmentController : OLSController
    {

        UDepartment um = new UDepartment();

        //
        // GET: /Department/

        public ActionResult Index()
        {
            return View();
        }

        //
        // GET: /Department/List

        [Description("部门列表")]
        public ActionResult List()
        {
            return View();
        }

        //
        // POST: /Department/ListDataTablesAjax

        [Description("查询部门")]
        public JsonResult ListDataTablesAjax()
        {

            DataTablesRequest dtRequest;
            DataTablesResponse dtResponse;

            dtRequest = GetDataTablesRequest();
            dtResponse = um.ListDataTablesAjax(dtRequest);

            return Json(dtResponse, JsonRequestBehavior.DenyGet);
        }

        //
        // GET: /Department/Create

        [Description("新建部门")]
        [HttpGet]
        public ActionResult Create()
        {

            Department m;

            m = um.GetNew();
            ViewBag.Roles = new URole().List();

            return View(m);
        }

        //
        // POST: /Department/Create

        [Description("添加部门")]
        [HttpPost]
        public ActionResult Create(Department m)
        {

            if (ModelState.IsValid)
            {

                if (um.Create(m))
                {
                    return Redirect("/Contents/html/parent_reload.htm");
                }
            }

            ViewBag.Roles = new URole().List();

            return View(m);
        }

        //
        // GET: /Department/Edit

        [Description("查看部门")]
        [HttpGet]
        public ActionResult Edit(Int32 id)
        {

            Department m;

            m = um.Get(id);
            ViewBag.Roles = new URole().List();

            return View(m);
        }

        //
        // POST: /Department/Edit

        [Description("修改部门")]
        [HttpPost]
        public ActionResult Edit(Department m)
        {

            if (ModelState.IsValid)
            {

                if (um.Edit(m))
                {
                    return Redirect("/Contents/html/parent_reload.htm");
                }
            }

            ViewBag.Roles = new URole().List();

            return View(m);
        }

        //
        // GET: /Department/Recycle

        [Description("回收部门")]
        public JsonResult Recycle(Int32 id)
        {

            ResponseJson resJson;

            resJson = um.Recycle(id);

            return Json(resJson, JsonRequestBehavior.AllowGet);
        }

        //
        // GET: /Department/Resume

        [Description("恢复部门")]
        public JsonResult Resume(Int32 id)
        {

            ResponseJson resJson;

            resJson = um.Resume(id);

            return Json(resJson, JsonRequestBehavior.AllowGet);
        }

        //
        // GET: /Department/Delete

        [Description("删除部门")]
        public JsonResult Delete(Int32 id)
        {

            ResponseJson resJson;

            resJson = um.Delete(id);

            return Json(resJson, JsonRequestBehavior.AllowGet);
        }

        //
        // GET: /Department/DuplicateName

        [Description("检查部门名称")]
        public JsonResult DuplicateName(Int32 D_Id, String D_Name)
        {

            Boolean matching;

            matching = um.DuplicateName(D_Id, D_Name);

            return Json(!matching, JsonRequestBehavior.AllowGet);
        }

        //
        // GET: /Department/Sort

        [Description("部门排序")]
        public JsonResult Sort(Int32 originId, Byte sortFlag)
        {
            ResponseJson resJson;

            resJson = um.Sort(originId, sortFlag);

            return Json(resJson, JsonRequestBehavior.AllowGet);
        }

        //
        // GET: /Department/GetZTreeResJson

        [Description("获取部门树表数据")]
        public JsonResult GetZTreeResJson(Byte status)
        {
            ResponseJson resJson;
            resJson = new UDepartment().GetZTreeResJson(status);
            return Json(resJson, JsonRequestBehavior.AllowGet);
        }
    }
}
