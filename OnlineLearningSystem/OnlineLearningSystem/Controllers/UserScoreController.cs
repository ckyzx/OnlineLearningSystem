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
            return View();
        }

        //
        // POST: /UserScore/ListSummaryDataTablesAjax

        [Description("查询用户成绩概览")]
        public JsonResult ListSummaryDataTablesAjax()
        {

            DataTablesRequest dtRequest;
            DataTablesResponse dtResponse;

            dtRequest = GetDataTablesRequest();
            dtResponse = um.ListSummaryDataTablesAjax(dtRequest);

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

            DataTablesRequest dtRequest;
            DataTablesResponse dtResponse;

            dtRequest = GetDataTablesRequest();
            dtResponse = um.ListDetailDataTablesAjax(dtRequest, uId);

            return Json(dtResponse, JsonRequestBehavior.DenyGet);
        }

        //
        // GET: /UserScore/DetailExportToExcel

        [Description("导出详情到表格")]
        public JsonResult DetailExportToExcel(Int32 uId)
        {

            String excelFile;
            DataTablesRequest dtRequest;

            dtRequest = GetDataTablesRequest();
            excelFile = um.DetailExportToExcel(uId);

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
