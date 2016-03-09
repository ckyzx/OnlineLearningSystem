using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.ComponentModel;
using OnlineLearningSystem.Models;
using OnlineLearningSystem.ViewModels;
using OnlineLearningSystem.Utilities;

namespace OnlineLearningSystem.Controllers
{
    public class UserController : OLSController
    {

        UUser um = new UUser();

        //
        // GET: /User/

        public ActionResult Index()
        {
            return View();
        }

        //
        // GET: /User/List

        [Description("用户列表")]
        public ActionResult List()
        {

            ViewBag.DepartmentsZTreeJson = new UDepartment().GetZTreeJson();

            return View();
        }

        //
        // GET: /User/ListDataTablesAjax

        [Description("查询用户")]
        public JsonResult ListDataTablesAjax(Int32 departmentId = 0)
        {

            DataTablesRequest dtRequest;
            DataTablesResponse dtResponse;

            dtRequest = GetDataTablesRequest();
            dtResponse = um.ListDataTablesAjax(dtRequest, departmentId);

            return Json(dtResponse, JsonRequestBehavior.DenyGet);
        }

        //
        // GET: /User/Create

        [Description("新建用户")]
        [HttpGet]
        public ActionResult Create()
        {

            VMUser u;

            u = um.GetNew();

            ViewBag.Duties = um.GetDutyList(u.Du_Id);
            ViewBag.Departments = new UDepartment().List();
            ViewBag.Roles = new URole().List();

            return View(u);
        }

        //
        // POST: /User/Create

        [Description("添加用户")]
        [HttpPost]
        public ActionResult Create(VMUser u)
        {

            if (ModelState.IsValid)
            {

                if (um.Create(u))
                {
                    return Redirect("/Contents/html/parent_reload.htm");
                }
            }

            ViewBag.Duties = um.GetDutyList(u.Du_Id);
            ViewBag.Departments = new UDepartment().List();
            ViewBag.Roles = new URole().List();

            return View(u);
        }

        //
        // GET: /User/Edit

        [Description("查看用户")]
        [HttpGet]
        public ActionResult Edit(Int32 id)
        {

            VMUser u;

            u = um.Get(id);

            ViewBag.Duties = um.GetDutyList(u.Du_Id);
            ViewBag.Departments = new UDepartment().List();
            ViewBag.Roles = new URole().List();

            return View(u);
        }

        //
        // POST: /User/Edit

        [Description("编辑用户")]
        [HttpPost]
        public ActionResult Edit(VMUser u)
        {

            if (ModelState.IsValid)
            {

                if (um.Edit(u))
                {
                    return Redirect("/Contents/html/parent_reload.htm");
                }
            }

            ViewBag.Duties = um.GetDutyList(u.Du_Id);
            ViewBag.Departments = new UDepartment().List();
            ViewBag.Roles = new URole().List();

            return View(u);
        }

        //
        // GET: /User/Recycle

        [Description("回收用户")]
        public JsonResult Recycle(Int32 id)
        {

            ResponseJson resJson;

            resJson = um.Recycle(id);

            return Json(resJson, JsonRequestBehavior.AllowGet);
        }

        //
        // GET: /User/Resume

        [Description("恢复用户")]
        public JsonResult Resume(Int32 id)
        {

            ResponseJson resJson;

            resJson = um.Resume(id);

            return Json(resJson, JsonRequestBehavior.AllowGet);
        }

        //
        // GET: /User/Delete

        [Description("删除用户")]
        public JsonResult Delete(Int32 id)
        {

            ResponseJson resJson;

            resJson = um.Delete(id);

            return Json(resJson, JsonRequestBehavior.AllowGet);
        }

        //
        // GET: /User/Login

        [HttpGet]
        public ActionResult Login(){

            if (null != Session["User"])
            {
                return RedirectToAction("Index", "Panel");
            }

            return View();
        }

        //
        // POST: /User/Login

        [HttpPost]
        public JsonResult Login(String userName, String password)
        {

            ResponseJson resJson;

            resJson = um.Login(userName, password);
            Session["User"] = resJson.addition;
            resJson.addition = null;

            return Json(resJson, JsonRequestBehavior.DenyGet);
        }

        //
        // GET: /User/Logout

        [HttpGet]
        public ActionResult Logout()
        {

            Session.Clear();
            return RedirectToAction("Login", "User");
        }

        //
        // GET: /User/ModifyPassword

        [Description("修改密码")]
        [HttpGet]
        public ActionResult ModifyPassword()
        {
            return View();
        }

        // POST: /User/ModifyPassword

        [HttpPost]
        public ActionResult ModifyPassword(String U_OldPassword, String U_Password)
        {

            User m;
            ResponseJson resJson;

            m = (User)Session["User"];
            
            resJson = um.ModifyPassword(m.U_Id, U_OldPassword, U_Password);
            if (resJson.status == ResponseStatus.Success)
            {
                return Redirect("/Contents/html/layer_close.htm");
            }

            return View(new VMUser());
        }

        //
        // GET: /User/CheckOldPassword

        //
        // GET: /User/DuplicateIdCardNumber

        [Description("检查身份证号")]
        public JsonResult DuplicateIdCardNumber(Int32 U_Id, String U_IdCardNumber)
        {

            Boolean matching;

            matching = um.DuplicateIdCardNumber(U_Id, U_IdCardNumber);

            return Json(!matching, JsonRequestBehavior.AllowGet);
        }

        //
        // GET: /User/DuplicateName

        [Description("检查用户名")]
        public JsonResult DuplicateName(Int32 U_Id, String U_Name)
        {

            Boolean matching;

            matching = um.DuplicateName(U_Id, U_Name);

            return Json(!matching, JsonRequestBehavior.AllowGet);
        }

        //
        // GET: /User/DuplicateLoginName

        [Description("检查登录名")]
        public JsonResult DuplicateLoginName(Int32 U_Id, String U_LoginName)
        {

            Boolean matching;

            matching = um.DuplicateLoginName(U_Id, U_LoginName);

            return Json(!matching, JsonRequestBehavior.AllowGet);
        }

        [Description("检查密码")]
        public JsonResult CheckOldPassword(String U_OldPassword)
        {

            User m;
            Boolean matching;

            m = (User)Session["User"];

            matching = um.CheckOldPassword(m.U_Id, U_OldPassword);

            return Json(matching, JsonRequestBehavior.AllowGet);
        }

        //
        // GET: /User/Sort

        [Description("用户排序")]
        public JsonResult Sort(Int32 originId, Byte sortFlag)
        {
            ResponseJson resJson;

            resJson = um.Sort(originId, sortFlag);

            return Json(resJson, JsonRequestBehavior.AllowGet);
        }
    }
}
