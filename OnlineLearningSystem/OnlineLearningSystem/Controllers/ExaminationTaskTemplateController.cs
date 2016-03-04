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
    public class ExaminationTaskTemplateController : OLSController
    {

        UExaminationTaskTemplate um = new UExaminationTaskTemplate();

        //
        // GET: /ExaminationTaskTemplate/

        public ActionResult Index()
        {
            return View();
        }

        //
        // GET: /ExaminationTaskTemplate/List

        [Description("考试任务模板列表")]
        public ActionResult List()
        {
            return View();
        }

        //
        // POST: /ExaminationTaskTemplate/ListDataTablesAjax

        [Description("查询考试任务模板")]
        public JsonResult ListDataTablesAjax()
        {

            DataTablesRequest dtRequest;
            DataTablesResponse dtResponse;

            dtRequest = GetDataTablesRequest();
            dtResponse = um.ListDataTablesAjax(dtRequest);

            return Json(dtResponse, JsonRequestBehavior.DenyGet);
        }

        //
        // GET: /ExaminationTaskTemplate/Create

        [Description("新建考试任务模板")]
        [HttpGet]
        public ActionResult Create()
        {

            ExaminationTaskTemplate m;

            m = um.GetNew();
            ViewBag.DepartmentsAndUsers = new UDepartment().GetZTreeJsonWithUsers();
            ViewBag.QuestionClassifies = new UQuestionClassify().GetZTreeJson(Status.Available);

            return View(m);
        }

        //
        // POST: /ExaminationTaskTemplate/Create

        [Description("添加考试任务模板")]
        [HttpPost]
        public ActionResult Create(ExaminationTaskTemplate m)
        {

            if (ModelState.IsValid)
            {

                if (um.Create(m))
                {
                    return Redirect("/Content/html/parent_reload.htm");
                }
            }

            ViewBag.DepartmentsAndUsers = new UDepartment().GetZTreeJsonWithUsers();
            ViewBag.QuestionClassifies = new UQuestionClassify().GetZTreeJson(Status.Available);

            return View(m);
        }

        //
        // GET: /ExaminationTaskTemplate/Edit

        [Description("查看考试任务模板")]
        [HttpGet]
        public ActionResult Edit(Int32 id)
        {

            ExaminationTaskTemplate m;

            m = um.Get(id);
            ViewBag.DepartmentsAndUsers = new UDepartment().GetZTreeJsonWithUsers();
            ViewBag.QuestionClassifies = new UQuestionClassify().GetZTreeJson(Status.Available);

            return View(m);
        }

        //
        // POST: /ExaminationTaskTemplate/Edit

        [Description("修改考试任务模板")]
        [HttpPost]
        public ActionResult Edit(ExaminationTaskTemplate m)
        {

            if (ModelState.IsValid)
            {

                if (um.Edit(m))
                {
                    return Redirect("/Content/html/parent_reload.htm");
                }
            }

            ViewBag.DepartmentsAndUsers = new UDepartment().GetZTreeJsonWithUsers();
            ViewBag.QuestionClassifies = new UQuestionClassify().GetZTreeJson(Status.Available);

            return View(m);
        }

        //
        // GET: /ExaminationTaskTemplate/Recycle

        [Description("回收考试任务模板")]
        public JsonResult Recycle(Int32 id)
        {

            ResponseJson resJson;

            resJson = um.Recycle(id);

            return Json(resJson, JsonRequestBehavior.AllowGet);
        }

        //
        // GET: /ExaminationTaskTemplate/Resume

        [Description("恢复考试任务模板")]
        public JsonResult Resume(Int32 id)
        {

            ResponseJson resJson;

            resJson = um.Resume(id);

            return Json(resJson, JsonRequestBehavior.AllowGet);
        }

        //
        // GET: /ExaminationTaskTemplate/Delete

        [Description("删除考试任务模板")]
        public JsonResult Delete(Int32 id)
        {

            ResponseJson resJson;

            resJson = um.Delete(id);

            return Json(resJson, JsonRequestBehavior.AllowGet);
        }

        //
        // GET: /ExaminationTaskTemplate/DuplicateName

        [Description("检查考试任务模板名称")]
        public JsonResult DuplicateName(Int32 ETT_Id, String ETT_Name)
        {

            Boolean matching;

            matching = um.DuplicateName(ETT_Id, ETT_Name);

            return Json(!matching, JsonRequestBehavior.AllowGet);
        }

    }
}
