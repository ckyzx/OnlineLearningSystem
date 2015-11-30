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
    public class RoleController : OLSController
    {

        URole um = new URole();

        //
        // GET: /Role/

        public ActionResult Index()
        {
            return View();
        }

        //
        // GET: /Role/List

        [Description("角色列表")]
        public ActionResult List()
        {
            return View();
        }

        //
        // POST: /Role/ListDataTablesAjax

        [Description("查询角色")]
        public JsonResult ListDataTablesAjax()
        {

            DataTablesRequest dtRequest;
            DataTablesResponse dtResponse;

            dtRequest = GetDataTablesRequest();
            dtResponse = um.ListDataTablesAjax(dtRequest);

            return Json(dtResponse, JsonRequestBehavior.DenyGet);
        }

        //
        // GET: /Role/Create

        [Description("新建角色")]
        [HttpGet]
        public ActionResult Create()
        {

            Role m;

            m = um.GetNew();
            ViewBag.PermissionCategories = new UPermissionCategory().GetZTreeJson();

            return View(m);
        }

        //
        // POST: /Role/Create

        [Description("添加角色")]
        [HttpPost]
        public ActionResult Create(Role m)
        {

            if (ModelState.IsValid)
            {

                if (um.Create(m))
                {
                    return Redirect("/Content/html/parent_reload.htm");
                }
            }

            ViewBag.PermissionCategories = new UPermissionCategory().GetZTreeJson();

            return View(m);
        }

        //
        // GET: /Role/Edit

        [Description("查看角色")]
        [HttpGet]
        public ActionResult Edit(Int32 id)
        {

            Role m;

            m = um.Get(id);
            ViewBag.PermissionCategories = new UPermissionCategory().GetZTreeJson();

            return View(m);
        }

        //
        // POST: /Role/Edit

        [Description("修改角色")]
        [HttpPost]
        public ActionResult Edit(Role m)
        {

            if (ModelState.IsValid)
            {

                if (um.Edit(m))
                {
                    return Redirect("/Content/html/parent_reload.htm");
                }
            }

            ViewBag.PermissionCategories = new UPermissionCategory().GetZTreeJson();

            return View(m);
        }

        //
        // GET: /Role/Recycle

        [Description("回收角色")]
        public JsonResult Recycle(Int32 id)
        {

            ResponseJson resJson;

            resJson = um.Recycle(id);

            return Json(resJson, JsonRequestBehavior.AllowGet);
        }

        //
        // GET: /Role/Resume

        [Description("恢复角色")]
        public JsonResult Resume(Int32 id)
        {

            ResponseJson resJson;

            resJson = um.Resume(id);

            return Json(resJson, JsonRequestBehavior.AllowGet);
        }

        //
        // GET: /Role/Delete

        [Description("删除角色")]
        public JsonResult Delete(Int32 id)
        {

            ResponseJson resJson;

            resJson = um.Delete(id);

            return Json(resJson, JsonRequestBehavior.AllowGet);
        }

        //
        // GET: /Role/DuplicateName

        [Description("检查角色名称")]
        public JsonResult DuplicateName(Int32 R_Id, String R_Name)
        {

            Boolean matching;

            matching = um.DuplicateName(R_Id, R_Name);

            return Json(!matching, JsonRequestBehavior.AllowGet);
        }

    }
}
