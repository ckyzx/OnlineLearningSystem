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
    public class ExaminationTaskController : OLSController
    {

        UExaminationTask um = new UExaminationTask();

        //
        // GET: /ExaminationTask/

        public ActionResult Index()
        {
            return View();
        }

        //
        // GET: /ExaminationTask/List

        [Description("考试任务列表")]
        public ActionResult List()
        {
            return View();
        }

        //
        // POST: /ExaminationTask/ListDataTablesAjax

        [Description("查询考试任务")]
        public JsonResult ListDataTablesAjax()
        {

            DataTablesRequest dtRequest;
            DataTablesResponse dtResponse;

            dtRequest = GetDataTablesRequest();
            dtResponse = um.ListDataTablesAjax(dtRequest);

            return Json(dtResponse, JsonRequestBehavior.DenyGet);
        }

        //
        // GET: /ExaminationTask/Create

        [Description("新建考试任务")]
        [HttpGet]
        public ActionResult Create()
        {

            ExaminationTask m;

            m = um.GetNew();
            ViewBag.DepartmentsAndUsers = new UDepartment().GetDepartmentsAndUsersZTreeJson();
            ViewBag.ExaminationTaskTemplates = um.GetTemplateList();

            return View(m);
        }

        //
        // POST: /ExaminationTask/Create

        [Description("添加考试任务")]
        [HttpPost]
        public ActionResult Create(ExaminationTask m)
        {

            if (ModelState.IsValid)
            {

                if (um.Create(m))
                {
                    return Redirect("/Content/html/parent_reload.htm");
                }
            }

            ViewBag.DepartmentsAndUsers = new UDepartment().GetDepartmentsAndUsersZTreeJson();
            ViewBag.ExaminationTaskTemplates = um.GetTemplateList();

            return View(m);
        }

        //
        // GET: /ExaminationTask/Edit

        [Description("查看考试任务")]
        [HttpGet]
        public ActionResult Edit(Int32 id)
        {

            ExaminationTask m;

            m = um.Get(id);
            ViewBag.DepartmentsAndUsers = new UDepartment().GetDepartmentsAndUsersZTreeJson();
            ViewBag.ExaminationTaskTemplates = um.GetTemplateList();

            return View(m);
        }

        //
        // POST: /ExaminationTask/Edit

        [Description("修改考试任务")]
        [HttpPost]
        public ActionResult Edit(ExaminationTask m)
        {

            if (ModelState.IsValid)
            {

                if (um.Edit(m))
                {
                    return Redirect("/Content/html/parent_reload.htm");
                }
            }

            ViewBag.DepartmentsAndUsers = new UDepartment().GetDepartmentsAndUsersZTreeJson();
            ViewBag.ExaminationTaskTemplates = um.GetTemplateList();

            return View(m);
        }

        //
        // GET: /ExaminationTask/Recycle

        [Description("回收考试任务")]
        public JsonResult Recycle(Int32 id)
        {

            ResponseJson resJson;

            resJson = um.Recycle(id);

            return Json(resJson, JsonRequestBehavior.AllowGet);
        }

        //
        // GET: /ExaminationTask/Resume

        [Description("恢复考试任务")]
        public JsonResult Resume(Int32 id)
        {

            ResponseJson resJson;

            resJson = um.Resume(id);

            return Json(resJson, JsonRequestBehavior.AllowGet);
        }

        //
        // GET: /ExaminationTask/Delete

        [Description("删除考试任务")]
        public JsonResult Delete(Int32 id)
        {

            ResponseJson resJson;

            resJson = um.Delete(id);

            return Json(resJson, JsonRequestBehavior.AllowGet);
        }

    }
}
