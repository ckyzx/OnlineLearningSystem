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
    public class UserScoreController : OLSController
    {

        UUserScore um = new UUserScore();

        //
        // GET: /UserScore/

        public ActionResult Index()
        {
            return View();
        }

        //
        // GET: /UserScore/ListSummary

        [Description("用户成绩概览")]
        public ActionResult ListSummary()
        {

            ViewBag.departments = new UDepartment().GetDepartmentList();

            return View();
        }

        //
        // POST: /UserScore/ListSummaryDataTablesAjax

        [Description("查询用户成绩概览")]
        public JsonResult ListSummaryDataTablesAjax(Int32 dId = 0)
        {

            DataTablesRequest dtRequest;
            DataTablesResponse dtResponse;

            dtRequest = GetDataTablesRequest();
            dtResponse = um.ListSummaryDataTablesAjax(dtRequest, dId);

            return Json(dtResponse, JsonRequestBehavior.DenyGet);
        }

        //
        // GET: /UserScore/ListDetail

        [Description("用户成绩详情")]
        public ActionResult ListDetail()
        {
            return View();
        }

        //
        // POST: /UserScore/ListDetailDataTablesAjax

        [Description("查询用户成绩详情")]
        public JsonResult ListDetailDataTablesAjax(Int32 uId)
        {

            String taskName;
            DateTime beginTime, endTime;
            DataTablesRequest dtRequest;
            DataTablesResponse dtResponse;

            taskName = Request["taskName"] != null ? Request["taskName"].ToString() : "";
            beginTime = Request["beginTime"] != null ? Convert.ToDateTime(Request["beginTime"]) : new DateTime(1, 1, 1);
            endTime = Request["endTime"] != null ? Convert.ToDateTime(Request["endTime"]) : new DateTime(1, 1, 1);

            dtRequest = GetDataTablesRequest();
            dtResponse = um.ListDetailDataTablesAjax(dtRequest, uId, taskName, beginTime, endTime);

            return Json(dtResponse, JsonRequestBehavior.DenyGet);
        }

        //
        // GET: /UserScore/DetailExportToExcel

        [Description("导出用户成绩详情到表格")]
        public JsonResult DetailExportToExcel(Int32 uId)
        {

            String taskName, excelFile;
            DateTime beginTime, endTime;

            taskName = Request["taskName"] != null ? Request["taskName"].ToString() : "";
            beginTime = Request["beginTime"] != null ? Convert.ToDateTime(Request["beginTime"]) : new DateTime(1,1,1);
            endTime = Request["endTime"] != null ? Convert.ToDateTime(Request["endTime"]) : new DateTime(1, 1, 1);
            
            excelFile = um.DetailExportToExcel(uId, taskName, beginTime, endTime);

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

        //
        // GET: /UserScore/SummaryExportToExcel

        [Description("导出用户成绩概览到表格")]
        public JsonResult SummaryExportToExcel(Int32 dId = 0)
        {

            String excelFile;

            excelFile = um.SummaryExportToExcel(dId);

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
