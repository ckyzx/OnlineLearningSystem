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
        // GET: /ExaminationTask/ListStudent

        [Description("考试任务列表，学员后台")]
        public ActionResult ListStudent()
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
        // POST: /ExaminationTask/ListDataTablesAjaxByMode

        [Description("查询考试任务")]
        public JsonResult ListDataTablesAjaxByMode(Byte mode)
        {

            DataTablesRequest dtRequest;
            DataTablesResponse dtResponse;

            dtRequest = GetDataTablesRequest();
            dtResponse = um.ListDataTablesAjax(dtRequest, mode);

            return Json(dtResponse, JsonRequestBehavior.DenyGet);
        }

        //
        // POST: /ExaminationTask/ListDataTablesAjaxByType

        [Description("查询考试任务")]
        public JsonResult ListDataTablesAjaxByType(Byte type, Byte enabled)
        {

            DataTablesRequest dtRequest;
            DataTablesResponse dtResponse;

            dtRequest = GetDataTablesRequest();
            dtResponse = um.ListDataTablesAjax(dtRequest, type, enabled);

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
            ViewBag.DepartmentsAndUsers = new UDepartment().GetZTreeJsonWithUsers();
            ViewBag.ExaminationTaskTemplates = um.GetTemplateList();
            ViewBag.QuestionClassifies = new UQuestionClassify().GetZTreeJson(Status.Available);

            return View(m);
        }

        //
        // POST: /ExaminationTask/Create

        [Description("添加考试任务")]
        [HttpPost]
        public ActionResult Create(ExaminationTask m)
        {

            ResponseJson resJson;

            if (ModelState.IsValid)
            {

                resJson = um.Create(m);
                if (ResponseStatus.Success == resJson.status)
                {
                    return Redirect("/Contents/html/parent_reload.htm");
                }

                ModelState.AddModelError("", resJson.message);
            }

            ViewBag.DepartmentsAndUsers = new UDepartment().GetZTreeJsonWithUsers();
            ViewBag.ExaminationTaskTemplates = um.GetTemplateList();
            ViewBag.QuestionClassifies = new UQuestionClassify().GetZTreeJson(Status.Available);

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
            ViewBag.DepartmentsAndUsers = new UDepartment().GetZTreeJsonWithUsers();
            ViewBag.ExaminationTaskTemplates = um.GetTemplateList();
            ViewBag.QuestionClassifies = new UQuestionClassify().GetZTreeJson(Status.Available);

            return View(m);
        }

        //
        // POST: /ExaminationTask/Edit

        [Description("修改考试任务")]
        [HttpPost]
        public ActionResult Edit(ExaminationTask m)
        {

            String returnMessage;

            if (ModelState.IsValid)
            {

                returnMessage = um.Edit(m);
                if (returnMessage == null)
                {
                    return Redirect("/Contents/html/parent_reload.htm");
                }

                ModelState.AddModelError("", returnMessage);
            }

            ViewBag.DepartmentsAndUsers = new UDepartment().GetZTreeJsonWithUsers();
            ViewBag.ExaminationTaskTemplates = um.GetTemplateList();
            ViewBag.QuestionClassifies = new UQuestionClassify().GetZTreeJson(Status.Available);

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

        //
        // GET: /ExaminationTask/StartTask

        [Description("开始考试任务")]
        public JsonResult StartTask(Int32 id)
        {

            ResponseJson resJson;

            resJson = um.StartTask(id);

            return Json(resJson, JsonRequestBehavior.AllowGet);
        }

        //
        // GET: /ExaminationTask/StopTask

        [Description("结束考试任务")]
        public JsonResult StopTask(Int32 id)
        {

            ResponseJson resJson;

            resJson = um.StopTask(id);

            return Json(resJson, JsonRequestBehavior.AllowGet);
        }

        //
        // GET: /ExaminationTask/DuplicateName

        [Description("检查考试任务名称")]
        public JsonResult DuplicateName(Int32 ET_Id, String ET_Name)
        {

            Boolean matching;

            matching = um.DuplicateName(ET_Id, ET_Name);

            return Json(!matching, JsonRequestBehavior.AllowGet);
        }

        //
        // GET: /ExaminationTask/GetDoingUserNumber

        [Description("获取正在考试的人数")]
        public JsonResult GetDoingUserNumber(Int32 id)
        {
            return Json(um.GetDoingUserNumber(id), JsonRequestBehavior.AllowGet);
        }

        //
        // GET: /ExaminationTask/EnterExercise

        [Description("进入练习")]
        public ActionResult EnterExercise(Int32 id)
        {
            User u = (User)Session["User"];
            ResponseJson resJson = um.EnterExercise(id, u.U_Id);

            if (ResponseStatus.Success == resJson.status)
            {
                return RedirectToAction("Paper", "ExaminationPaper", new { epId = resJson.data });
            }

            resJson.message = resJson.message.Replace("\\r\\n", "||r||n").Replace("\r\n", "|r|n");

            return Redirect("/Contents/html/prompt_redirect.htm?prompt=" + resJson.message + "&close=1");
        }

    }
}
