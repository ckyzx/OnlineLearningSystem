using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.ComponentModel;
using OnlineLearningSystem.Models;
using OnlineLearningSystem.Utilities;
using System.IO;

namespace OnlineLearningSystem.Controllers
{
    public class ExaminationTaskStatisticController : OLSController
    {

        UExaminationTaskStatistic um = new UExaminationTaskStatistic();

        //
        // GET: /ExaminationTaskStatistic/

        public ActionResult Index()
        {
            return View();
        }

        //
        // GET: /ExaminationTaskStatistic/List

        [Description("考试统计列表")]
        public ActionResult List()
        {
            return View();
        }

        //
        // POST: /ExaminationTaskStatistic/ListDataTablesAjax

        [Description("查询考试统计")]
        public JsonResult ListDataTablesAjax()
        {

            String taskName;
            DateTime beginTime, endTime;
            DataTablesRequest dtRequest;
            DataTablesResponse dtResponse;

            taskName = Request["taskName"] != null ? Request["taskName"].ToString() : "";
            beginTime = Request["beginTime"] != null ? Convert.ToDateTime(Request["beginTime"]) : new DateTime(1, 1, 1);
            endTime = Request["endTime"] != null ? Convert.ToDateTime(Request["endTime"]) : new DateTime(1, 1, 1);

            dtRequest = GetDataTablesRequest();
            dtResponse = um.ListDataTablesAjax(dtRequest, taskName, beginTime, endTime);

            return Json(dtResponse, JsonRequestBehavior.DenyGet);
        }

        //
        // GET: /ExaminationTaskStatistic/ListUser

        [Description("用户考试统计列表")]
        public ActionResult ListUser()
        {
            return View();
        }

        //
        // POST: /ExaminationTaskStatistic/ListUserDataTablesAjax

        [Description("查询用户考试统计")]
        public JsonResult ListUserDataTablesAjax(Int32 eptId)
        {

            DataTablesRequest dtRequest;
            DataTablesResponse dtResponse;

            dtRequest = GetDataTablesRequest();
            dtResponse = um.ListUserDataTablesAjax(dtRequest, eptId);

            return Json(dtResponse, JsonRequestBehavior.DenyGet);
        }

        //
        // GET: /ExaminationTaskStatistic/Personal

        public ActionResult Personal()
        {

            Int32 uId;
            User u;

            u = (User)Session["User"];
            uId = u.U_Id;

            return View(um.GetPersonalStatistic(uId));
        }

        //
        // GET: /ExaminationTaskStatistic/TaskExportToExcel

        [Description("导出考试统计概览到表格")]
        public JsonResult TaskExportToExcel()
        {

            String excelFile, taskName;
            DateTime beginTime, endTime;

            taskName = Request["taskName"] != null ? Request["taskName"].ToString() : "";
            beginTime = Request["beginTime"] != null ? Convert.ToDateTime(Request["beginTime"]) : new DateTime(1, 1, 1);
            endTime = Request["endTime"] != null ? Convert.ToDateTime(Request["endTime"]) : new DateTime(1, 1, 1);

            excelFile = um.TaskExportToExcel(taskName, beginTime, endTime);

            FileInfo downloadFile = new FileInfo(excelFile);
            Response.Clear();
            Response.ClearHeaders();
            Response.Buffer = false;
            Response.ContentType = "application/octet-stream";
            Response.AppendHeader("Content-Disposition", "attachment;filename=" + System.Web.HttpUtility.UrlEncode(downloadFile.Name, System.Text.Encoding.UTF8));
            Response.AppendHeader("Content-Length", downloadFile.Length.ToString());
            Response.WriteFile(downloadFile.FullName);
            Response.Flush();
            Response.End();

            return Json(downloadFile.Name, JsonRequestBehavior.AllowGet);
        }
    }
}
