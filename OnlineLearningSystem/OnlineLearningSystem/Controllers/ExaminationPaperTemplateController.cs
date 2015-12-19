using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.ComponentModel;
using OnlineLearningSystem.Models;
using OnlineLearningSystem.Utilities;
//using Newtonsoft.Json;

namespace OnlineLearningSystem.Controllers
{
    public class ExaminationPaperTemplateController : OLSController
    {

        UExaminationPaperTemplate um = new UExaminationPaperTemplate();

        //
        // GET: /ExaminationPaperTemplate/

        public ActionResult Index()
        {
            return View();
        }

        //
        // GET: /ExaminationPaperTemplate/List

        [Description("试卷模板列表，管理后台")]
        public ActionResult List()
        {
            return View();
        }

        //
        // GET: /ExaminationPaperTemplate/ListStudent

        [Description("试卷模板列表，学员后台")]
        public ActionResult ListStudent()
        {
            return View();
        }

        //
        // POST: /ExaminationPaperTemplate/ListDataTablesAjax

        [Description("查询试卷模板，管理后台")]
        public JsonResult ListDataTablesAjax(Int32 etId)
        {

            DataTablesRequest dtRequest;
            DataTablesResponse dtResponse;

            dtRequest = GetDataTablesRequest();
            dtResponse = um.ListDataTablesAjax(dtRequest, etId);

            return Json(dtResponse, JsonRequestBehavior.DenyGet);
        }

        //
        // POST: /ExaminationPaperTemplate/ListDataTablesAjaxStudent

        [Description("查询试卷模板，学员后台")]
        public JsonResult ListDataTablesAjaxStudent(Byte type, Byte ptStatus)
        {

            Int32 uId;
            DataTablesRequest dtRequest;
            DataTablesResponse dtResponse;

            uId = ((User)Session["User"]).U_Id;

            dtRequest = GetDataTablesRequest();
            dtResponse = um.ListDataTablesAjax(dtRequest, uId, type, ptStatus);

            return Json(dtResponse, JsonRequestBehavior.DenyGet);
        }

        //
        // GET: /ExaminationPaperTemplate/Paper

        [Description("进入考试")]
        public ActionResult Paper(Int32 id)
        {

            User u;
            ResponseJson resJson;

            u = (User)Session["User"];
            resJson = um.EnterExamination(id, u.U_Id);

            if (ResponseStatus.Success == resJson.status)
            {
                return RedirectToAction("Paper", "ExaminationPaper", new { epId = resJson.addition });
            }

            resJson.message = resJson.message.Replace("\\r\\n", "||r||n").Replace("\r\n", "|r|n");

            return Redirect("/Content/html/prompt_redirect.htm?prompt=" + resJson.message + "&close=1");
        }

        //
        // GET: /ExaminationPaperTemplate/ListGrade

        [Description("改卷列表")]
        public ActionResult ListGrade()
        {
            return View();
        }

        //
        // GET: /ExaminationPaperTemplate/GetUsers

        [Description("获取改卷用户数据")]
        public JsonResult GetUsers(Int32 id)
        {
            return Json(um.GetUsers(id),JsonRequestBehavior.AllowGet);
        }

        //
        // GET: /ExaminationPaperTemplate/GetQuestions

        [Description("获取改卷试题数据")]
        public JsonResult GetQuestions(Int32 id, Int32 uId)
        {
            return Json(um.GetQuestions(id, uId), JsonRequestBehavior.AllowGet);
        }

        //
        // POST: /ExaminationPaperTemplate/Grade

        [Description("提交改卷数据")]
        [HttpPost]
        public JsonResult Grade(String gradeJson)
        {
            return Json(um.Grade(gradeJson));
        }

        //
        // GET: /ExaminationPaperTemplate/Create

        [Description("新建试卷模板")]
        [HttpGet]
        public ActionResult Create(Int32 etId)
        {

            ExaminationPaperTemplate m;

            m = um.GetNew(etId);

            return View(m);
        }

        //
        // POST: /ExaminationPaperTemplate/Create

        [Description("添加试卷模板")]
        [HttpPost]
        public ActionResult Create(ExaminationPaperTemplate m)
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
        // GET: /ExaminationPaperTemplate/Edit

        [Description("查看试卷模板")]
        [HttpGet]
        public ActionResult Edit(Int32 id)
        {

            ExaminationPaperTemplate m;

            m = um.Get(id);

            return View(m);
        }

        //
        // POST: /ExaminationPaperTemplate/Edit

        [Description("修改试卷模板")]
        [HttpPost]
        public ActionResult Edit(ExaminationPaperTemplate m)
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
        // GET: /ExaminationPaperTemplate/Recycle

        [Description("回收试卷模板")]
        public JsonResult Recycle(Int32 id)
        {

            ResponseJson resJson;

            resJson = um.Recycle(id);

            return Json(resJson, JsonRequestBehavior.AllowGet);
        }

        //
        // GET: /ExaminationPaperTemplate/Resume

        [Description("恢复试卷模板")]
        public JsonResult Resume(Int32 id)
        {

            ResponseJson resJson;

            resJson = um.Resume(id);

            return Json(resJson, JsonRequestBehavior.AllowGet);
        }

        //
        // GET: /ExaminationPaperTemplate/Delete

        [Description("删除试卷模板")]
        public JsonResult Delete(Int32 id)
        {

            ResponseJson resJson;

            resJson = um.Delete(id);

            return Json(resJson, JsonRequestBehavior.AllowGet);
        }

        //
        // GET: /ExaminationPaperTemplate/Terminate

        [Description("终止考试")]
        public JsonResult Terminate(Int32 id)
        {

            ResponseJson resJson;

            resJson = um.Terminate(id);

            return Json(resJson, JsonRequestBehavior.AllowGet);
        }

    }
}
