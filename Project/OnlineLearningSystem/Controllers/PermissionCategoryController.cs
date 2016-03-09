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
    public class PermissionCategoryController : OLSController
    {

        UPermissionCategory um = new UPermissionCategory();

        //
        // GET: /PermissionCategory/

        public ActionResult Index()
        {
            return View();
        }

        //
        // GET: /PermissionCategory/List

        [Description("权限目录列表")]
        public ActionResult List()
        {
            return View();
        }

        //
        // POST: /PermissionCategory/ListDataTablesAjax

        [Description("查询权限目录")]
        public JsonResult ListDataTablesAjax()
        {

            DataTablesRequest dtRequest;
            DataTablesResponse dtResponse;

            dtRequest = GetDataTablesRequest();
            dtResponse = um.ListDataTablesAjax(dtRequest);

            return Json(dtResponse, JsonRequestBehavior.DenyGet);
        }

        //
        // GET: /PermissionCategory/Create

        [Description("新建权限目录")]
        [HttpGet]
        public ActionResult Create()
        {

            PermissionCategory m;

            ViewBag.ActionPermissions = StaticHelper.GetActionPermission();

            m = um.GetNew();

            return View(m);
        }

        //
        // POST: /PermissionCategory/Create

        [Description("添加权限目录")]
        [HttpPost]
        public ActionResult Create(PermissionCategory m)
        {

            if (ModelState.IsValid)
            {

                if (um.Create(m))
                {
                    return Redirect("/Contents/html/parent_reload.htm");
                }
            }

            ViewBag.ActionPermissions = StaticHelper.GetActionPermission();

            return View(m);
        }

        //
        // GET: /PermissionCategory/Edit

        [Description("查看权限目录")]
        [HttpGet]
        public ActionResult Edit(Int32 id)
        {

            PermissionCategory m;

            ViewBag.ActionPermissions = StaticHelper.GetActionPermission();

            m = um.Get(id);

            return View(m);
        }

        //
        // POST: /PermissionCategory/Edit

        [Description("修改权限目录")]
        [HttpPost]
        public ActionResult Edit(PermissionCategory m)
        {

            if (ModelState.IsValid)
            {

                if (um.Edit(m))
                {
                    return Redirect("/Contents/html/parent_reload.htm");
                }
            }

            ViewBag.ActionPermissions = StaticHelper.GetActionPermission();

            return View(m);
        }

        //
        // GET: /PermissionCategory/Recycle

        [Description("回收权限目录")]
        public JsonResult Recycle(Int32 id)
        {

            ResponseJson resJson;

            resJson = um.Recycle(id);

            return Json(resJson, JsonRequestBehavior.AllowGet);
        }

        //
        // GET: /PermissionCategory/Resume

        [Description("恢复权限目录")]
        public JsonResult Resume(Int32 id)
        {

            ResponseJson resJson;

            resJson = um.Resume(id);

            return Json(resJson, JsonRequestBehavior.AllowGet);
        }

        //
        // GET: /PermissionCategory/Delete

        [Description("删除权限目录")]
        public JsonResult Delete(Int32 id)
        {

            ResponseJson resJson;

            resJson = um.Delete(id);

            return Json(resJson, JsonRequestBehavior.AllowGet);
        }

        //
        // GET: /PermissionCatetory/DuplicateName

        [Description("检查权限目录名称")]
        public JsonResult DuplicateName(Int32 PC_Id, String PC_Name)
        {

            Boolean matching;

            matching = um.DuplicateName(PC_Id, PC_Name);

            return Json(!matching, JsonRequestBehavior.AllowGet);
        }

    }
}
