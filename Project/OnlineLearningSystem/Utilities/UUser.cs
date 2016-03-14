﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Data;
using System.Web;
using System.Web.Mvc;
using OnlineLearningSystem.Models;
using Newtonsoft.Json;
using System.Text;
using System.Security.Cryptography;
using OnlineLearningSystem.ViewModels;
using System.Data.SqlClient;

namespace OnlineLearningSystem.Utilities
{
    public class UUser : Utility
    {

        public DataTablesResponse ListDataTablesAjax(DataTablesRequest dtRequest)
        {

            String dutyName;
            DataTablesResponse dtResponse;
            Duty d;
            UModel<User> umodel;
            List<User> ms;

            umodel = new UModel<User>(dtRequest, "Users", "U_Id");
            dtResponse = umodel.GetList("U_Status", "U_Sort", new String[] { "Du_Name" });

            ms = (List<User>)dtResponse.data;
            foreach (var m1 in ms)
            {
                d = olsEni.Duties.SingleOrDefault(m => m.Du_Id == m1.Du_Id);
                dutyName = null == d ? "" : d.Du_Name;
                m1.Du_Name = dutyName;
                m1.U_Password = "**********";
            }
            dtResponse.data = ms;

            return dtResponse;
        }

        public DataTablesResponse ListDataTablesAjax(DataTablesRequest dtRequest, Int32 departmentId)
        {

            String dutyName, sql;
            DataTablesResponse dtResponse;
            Duty d;
            List<SqlParameter> sps;
            UModel<User> umodel;
            List<User> ms;

            umodel = new UModel<User>(dtRequest, "Users", "U_Id");

            sps = new List<SqlParameter>();
            if (0 != departmentId)
            {
                sps.Add(new SqlParameter("@D_Id", departmentId));
            }

            sql = "SELECT * FROM (SELECT u.*, d.D_Id FROM Users u LEFT JOIN User_Department ud ON u.U_Id = ud.U_Id LEFT JOIN Departments d ON ud.D_Id = d.D_Id) t ";
            dtResponse = umodel.GetList(sql, sps, "U_Status", "U_Sort", new String[] { "Du_Name" });

            ms = (List<User>)dtResponse.data;
            foreach (var m1 in ms)
            {
                d = olsEni.Duties.SingleOrDefault(m => m.Du_Id == m1.Du_Id);
                dutyName = null == d ? "" : d.Du_Name;
                m1.Du_Name = dutyName;
                m1.U_Password = "**********";
            }
            dtResponse.data = ms;

            return dtResponse;
        }

        public List<SelectListItem> GetDutyList(Int32? currentValue)
        {

            List<SelectListItem> list;

            var items = olsEni.Duties
                .Where(m => m.Du_Status == (Byte)Status.Available)
                .Select(m => new { m.Du_Name, m.Du_Id });

            list = new List<SelectListItem>();
            list.Add(new SelectListItem() { Text = "[未设置]", Value = "" });

            foreach (var i in items)
            {
                list.Add(new SelectListItem
                {
                    Text = i.Du_Name,
                    Value = i.Du_Id.ToString(),
                    Selected = i.Du_Id == currentValue ? true : false
                });
            }

            return list;
        }

        public VMUser GetNew()
        {

            VMUser model;

            model = new VMUser()
            {
                U_Id = 0,
                Du_Id = 0,
                Du_Name = "",
                U_Name = "",
                U_LoginName = "LoginName0",
                U_Password = "",
                U_RePassword = "",
                U_Departments = "[]",
                U_Roles = "[]",
                U_Remark = "",
                U_AddTime = DateTime.Now,
                U_Status = (Byte)Status.Available
            };

            return model;
        }

        public VMUser Get(Int32 id)
        {

            User model;
            VMUser vmModel;
            Duty duty;
            String duName;

            model = olsEni.Users.Single(m =>
                m.U_Id == id
                && m.U_Status == (Byte)Status.Available);

            if (null != model.Du_Id)
            {
                duty = olsEni.Duties.SingleOrDefault(m => m.Du_Id == model.Du_Id);
                duName = duty.Du_Name;
            }
            else
            {
                duName = "";
            }

            vmModel = new VMUser
            {
                U_Id = model.U_Id,
                Du_Id = model.Du_Id,
                Du_Name = duName,
                U_IdCardNumber = model.U_IdCardNumber,
                U_Name = model.U_Name,
                U_LoginName = model.U_LoginName,
                U_Password = "**********",
                U_RePassword = "**********",
                U_Departments = model.U_Departments,
                U_Roles = model.U_Roles,
                U_Remark = model.U_Remark,
                U_AddTime = model.U_AddTime,
                U_Status = model.U_Status,
                U_Sort = model.U_Sort
            };

            return vmModel;
        }

        public Boolean Create(VMUser vmModel)
        {
            try
            {

                Int32 uId;
                User model;

                // 不允许将密码设置为“**********”
                if (vmModel.U_Password == "**********")
                {
                    return false;
                }

                uId = GetUId();

                model = new User
                {
                    U_Id = uId,
                    Du_Id = vmModel.Du_Id,
                    U_IdCardNumber = vmModel.U_IdCardNumber,
                    U_Name = vmModel.U_Name,
                    U_LoginName = "LoginName" + uId,
                    U_Password = EncryptPassword(vmModel.U_Password),
                    U_Departments = vmModel.U_Departments,
                    U_Roles = vmModel.U_Roles,
                    U_Remark = vmModel.U_Remark,
                    U_AddTime = vmModel.U_AddTime,
                    U_Status = vmModel.U_Status,
                    U_Sort = uId
                };

                olsEni.Users.Add(model);
                olsEni.SaveChanges();

                UpdateUserDepartment(model);
                UpdateUserRole(model);

                return true;
            }
            catch (Exception ex)
            {
                StaticHelper.RecordSystemLog(ex);
                return false;
            }
        }

        private String EncryptPassword(String password)
        {

            MD5CryptoServiceProvider md5;
            Byte[] bytes;

            md5 = new MD5CryptoServiceProvider();
            bytes = Encoding.UTF8.GetBytes(password);
            bytes = md5.ComputeHash(bytes);
            password = BitConverter.ToString(bytes);
            password = password.Replace("-", "");

            return password;
        }

        public void UpdateUserDepartment(User model)
        {

            List<User_Department> uds;
            Int32[] ds;

            uds = olsEni.User_Department.Where(m => m.U_Id == model.U_Id).ToList();
            foreach (var ud in uds)
            {
                olsEni.Entry(ud).State = EntityState.Deleted;
            }
            olsEni.SaveChanges();

            ds = JsonConvert.DeserializeObject<Int32[]>(model.U_Departments);
            foreach (var d in ds)
            {

                olsEni.User_Department.Add(new User_Department
                {
                    U_Id = model.U_Id,
                    D_Id = Convert.ToInt32(d)
                });
            }
            olsEni.SaveChanges();

        }

        public void UpdateUserRole(User model)
        {

            List<User_Role> urs;
            Int32[] rs;

            urs = olsEni.User_Role.Where(m => m.U_Id == model.U_Id).ToList();
            foreach (var ud in urs)
            {
                olsEni.Entry(ud).State = EntityState.Deleted;
            }
            olsEni.SaveChanges();

            rs = JsonConvert.DeserializeObject<Int32[]>(model.U_Roles);
            foreach (var r in rs)
            {

                olsEni.User_Role.Add(new User_Role
                {
                    U_Id = model.U_Id,
                    R_Id = Convert.ToInt32(r)
                });
            }
            olsEni.SaveChanges();

        }

        public Boolean Edit(VMUser vmModel)
        {
            try
            {

                User model;

                model = olsEni.Users.Single(m =>
                    m.U_Id == vmModel.U_Id
                    && m.U_Status == (Byte)Status.Available);

                model.U_Id = vmModel.U_Id;
                model.Du_Id = vmModel.Du_Id;
                model.U_IdCardNumber = vmModel.U_IdCardNumber;
                model.U_Name = vmModel.U_Name;
                model.U_LoginName = vmModel.U_LoginName;
                model.U_Departments = vmModel.U_Departments;
                model.U_Roles = vmModel.U_Roles;
                model.U_Remark = vmModel.U_Remark;
                model.U_Status = vmModel.U_Status;
                model.U_Sort = vmModel.U_Sort;

                if ("**********" != vmModel.U_Password)
                {
                    model.U_Password = EncryptPassword(vmModel.U_Password);
                }

                olsEni.Entry(model).State = EntityState.Modified;
                olsEni.SaveChanges();

                UpdateUserDepartment(model);
                UpdateUserRole(model);

                return true;
            }
            catch (Exception ex)
            {
                StaticHelper.RecordSystemLog(ex);
                return false;
            }
        }

        public ResponseJson Recycle(Int32 id)
        {

            return SetStatus(id, Status.Recycle);
        }

        public ResponseJson Resume(Int32 id)
        {

            return SetStatus(id, Status.Available);
        }

        public ResponseJson Delete(Int32 id)
        {

            return SetStatus(id, Status.Delete);
        }

        public ResponseJson SetStatus(Int32 id, Status status)
        {

            ResponseJson resJson;

            resJson = new ResponseJson();

            try
            {
                User model;

                model = olsEni.Users.SingleOrDefault(m => m.U_Id == id);

                if (null == model)
                {
                    resJson.message = "数据不存在！";
                    return resJson;
                }

                model.U_Status = (Byte)status;
                olsEni.Entry(model).State = EntityState.Modified;
                olsEni.SaveChanges();

                resJson.status = ResponseStatus.Success;
                return resJson;
            }
            catch (Exception ex)
            {
                resJson.status = ResponseStatus.Error;
                resJson.message = ex.Message;
                resJson.detail = StaticHelper.GetExceptionMessageAndRecord(ex);
                return resJson;
            }
        }

        public ResponseJson Login(String userName, String password)
        {

            ResponseJson resJson;

            resJson = new ResponseJson();

            try
            {

                User u;

                userName = userName.ToLower();
                password = EncryptPassword(password);

                /*u = olsEni.Users.SingleOrDefault(m =>
                        ((m.U_Name.ToLower() == userName
                            && m.U_Password == password)
                        || (m.U_LoginName.ToLower() == userName
                            && m.U_Password == password))
                        && m.U_Status == (Byte)Status.Available);*/

                u = olsEni.Users.SingleOrDefault(m =>
                        m.U_IdCardNumber.ToLower() == userName
                        && m.U_Password == password
                        && m.U_Status == (Byte)Status.Available);

                if (null == u)
                {
                    resJson.message = "身份证号或密码有误。";
                    return resJson;
                }



                // 收集角色列表
                var rs = GetUserRoleList(u.U_Id);
                var ds = GetDepartmentList(u.U_Id);

                if (rs.Count() == 0)
                {
                    rs = GetDepartmentRoleList(ds);
                }
                u.U_RoleList = rs;

                // 收集部门列表
                u.U_DepartmentList = ds;

                // 收集权限列表
                var ps = GetPermissionList(u.U_RoleList);
                u.U_PermissionList = ps;

                resJson.status = ResponseStatus.Success;
                resJson.addition = u;
                return resJson;
            }
            catch (Exception ex)
            {
                resJson.status = ResponseStatus.Error;
                resJson.message = ex.Message;
                resJson.detail = StaticHelper.GetExceptionMessageAndRecord(ex);
                return resJson;
            }
        }

        private List<Role> GetUserRoleList(Int32 uId)
        {

            List<User_Role> urs;
            List<Role> rs;
            Role r;

            urs = olsEni.User_Role.Where(m => m.U_Id == uId).ToList();
            rs = new List<Role>();
            foreach (var ur in urs)
            {
                r = olsEni.Roles.SingleOrDefault(m => m.R_Id == ur.R_Id);

                if (null != r)
                {
                    rs.Add(r);
                }
            }

            return rs;
        }

        private List<Permission> GetPermissionList(List<Role> rs)
        {

            List<Role_Permission> rps;
            Permission p;
            List<Permission> ps;

            ps = new List<Permission>();
            foreach (var r in rs)
            {

                rps = olsEni.Role_Permission.Where(m => m.R_Id == r.R_Id).ToList();
                foreach (var rp in rps)
                {

                    p = olsEni.Permissions.SingleOrDefault(m => m.P_Id == rp.P_Id);
                    if (null != p)
                    {
                        if (!ps.Contains(p))
                        {
                            ps.Add(p);
                        }
                    }
                }
            }

            return ps;
        }

        private List<Department> GetDepartmentList(Int32 uId)
        {

            List<User_Department> uds;
            List<Department> ds;
            Department d;

            uds = olsEni.User_Department.Where(m => m.U_Id == uId).ToList();
            ds = new List<Department>();
            foreach (var ud in uds)
            {

                d = olsEni.Departments.SingleOrDefault(m => m.D_Id == ud.D_Id);
                if (null != d)
                {
                    ds.Add(d);
                }
            }

            return ds;
        }

        private List<Role> GetDepartmentRoleList(List<Department> ds)
        {

            List<Department_Role> drs;
            List<Role> rs;
            Role r;

            rs = new List<Role>();
            foreach (var d in ds)
            {

                drs = olsEni.Department_Role.Where(m => m.D_Id == d.D_Id).ToList();
                foreach (var dr in drs)
                {

                    r = olsEni.Roles.SingleOrDefault(m => m.R_Id == dr.R_Id);
                    if (null != r)
                    {
                        rs.Add(r);
                    }
                }
            }

            return rs;
        }

        public ResponseJson ModifyPassword(Int32 uId, String oldPassword, String newPassword)
        {

            ResponseJson resJson;

            resJson = new ResponseJson();

            try
            {

                User model;

                model = olsEni.Users.SingleOrDefault(m =>
                    m.U_Id == uId
                    && m.U_Status == (Byte)Status.Available);

                if (null == model)
                {
                    resJson.status = ResponseStatus.Error;
                    resJson.message = "用户不存在。";
                    return resJson;
                }

                oldPassword = EncryptPassword(oldPassword);

                if (oldPassword != model.U_Password)
                {
                    resJson.status = ResponseStatus.Error;
                    resJson.message = "旧密码不正确。";
                    return resJson;
                }

                // 不允许将密码设置为“**********”
                if (newPassword == "**********")
                {
                    resJson.status = ResponseStatus.Error;
                    resJson.message = "新密码无效。";
                    return resJson;
                }

                newPassword = EncryptPassword(newPassword);
                model.U_Password = newPassword;
                if (olsEni.SaveChanges() == 0)
                {
                    resJson.status = ResponseStatus.Error;
                    resJson.message = "密码修改失败。";
                    return resJson;
                }

                resJson.status = ResponseStatus.Success;
                return resJson;
            }
            catch (Exception ex)
            {
                resJson.status = ResponseStatus.Error;
                resJson.message = ex.Message;
                resJson.detail = StaticHelper.GetExceptionMessageAndRecord(ex);
                return resJson;
            }
        }

        public Boolean CheckOldPassword(Int32 uId, String oldPassword)
        {
            try
            {

                User model;

                model = olsEni.Users.SingleOrDefault(m =>
                    m.U_Id == uId
                    && m.U_Status == (Byte)Status.Available);

                if (null == model)
                {
                    return false;
                }

                oldPassword = EncryptPassword(oldPassword);

                if (oldPassword == model.U_Password)
                {
                    return true;
                }

                return false;
            }
            catch (Exception ex)
            {
                StaticHelper.RecordSystemLog(ex);
                return false;
            }
        }

        public Boolean DuplicateName(Int32 uId, String name)
        {
            try
            {

                Int32 count;

                count = olsEni.Users.Where(m =>
                    m.U_Id != uId
                    && m.U_Name == name).Count();

                if (count > 0)
                {
                    return true;
                }

                return false;
            }
            catch (Exception ex)
            {
                StaticHelper.RecordSystemLog(ex);
                return false;
            }
        }

        public Boolean DuplicateLoginName(Int32 uId, String loginName)
        {
            try
            {

                Int32 count;

                count = olsEni.Users.Where(m =>
                    m.U_Id != uId
                    && m.U_LoginName == loginName).Count();

                if (count > 0)
                {
                    return true;
                }

                return false;
            }
            catch (Exception ex)
            {
                StaticHelper.RecordSystemLog(ex);
                return false;
            }
        }

        public Boolean DuplicateIdCardNumber(Int32 uId, String idCardNumber)
        {
            try
            {

                Int32 count;

                count = olsEni.Users.Where(m =>
                    m.U_Id != uId
                    && m.U_IdCardNumber == idCardNumber).Count();

                if (count > 0)
                {
                    return true;
                }

                return false;
            }
            catch (Exception ex)
            {
                StaticHelper.RecordSystemLog(ex);
                return false;
            }
        }

        public ResponseJson Sort(Int32 originId, Byte sortFlag)
        {

            ResponseJson resJson;

            resJson = new ResponseJson();

            try
            {

                Double originSort, destSort;
                User originUser, destUser, adjustUser;
                User[] userAry;
                List<User> us;

                userAry = new User[2];

                originUser = olsEni.Users.Single(m => m.U_Id == originId);
                originSort = originUser.U_Sort;

                // 置顶
                if (1 == sortFlag)
                {

                    destSort = olsEni.Users.Min(m => m.U_Sort);
                    destUser = olsEni.Users.Single(m => m.U_Sort == destSort);

                    if (destSort == originSort)
                    {
                        resJson.status = ResponseStatus.Error;
                        resJson.message = "该用户已置顶。";
                        return resJson;
                    }

                    originSort = destSort - 1;
                    originUser.U_Sort = originSort;
                }
                else if (2 == sortFlag)
                {

                    us = olsEni.Users.Where(m =>
                        m.U_Sort < originSort)
                        .OrderByDescending(m => m.U_Sort).Take(2).ToList();

                    if (us.Count == 0)
                    {
                        resJson.status = ResponseStatus.Error;
                        resJson.message = "该用户已处于顶部。";
                        return resJson;
                    }
                    else if (us.Count == 1)
                    {
                        destUser = us[0];
                        originSort = destUser.U_Sort;
                        destSort = originUser.U_Sort;
                        originUser.U_Sort = originSort;
                        destUser.U_Sort = destSort;
                    }
                    else
                    {
                        destUser = us[1];
                        destSort = destUser.U_Sort;
                        originSort = Math.Round(destSort + 0.00001, 5, MidpointRounding.AwayFromZero);
                        originUser.U_Sort = originSort;
                    }

                }
                else// if (3 == sortFlag)
                {

                    us = olsEni.Users.Where(m =>
                        m.U_Sort > originSort)
                        .OrderBy(m => m.U_Sort)
                        .Take(1).ToList();

                    if (us.Count == 0)
                    {
                        resJson.status = ResponseStatus.Error;
                        resJson.message = "该用户已处于底部。";
                        return resJson;
                    }

                    destUser = us[0];
                    destSort = destUser.U_Sort;

                    originSort = Math.Round(destSort + 0.00001, 5, MidpointRounding.AwayFromZero);
                    originUser.U_Sort = originSort;
                }

                adjustUser = olsEni.Users.SingleOrDefault(m => m.U_Sort == originSort);
                if (adjustUser != null)
                {
                    adjustUser.U_Sort = Math.Round(originSort + 0.00001, 5, MidpointRounding.AwayFromZero);
                }

                if (0 == olsEni.SaveChanges())
                {
                    resJson.status = ResponseStatus.Error;
                    resJson.message = ResponseMessage.SaveChangesError;
                    return resJson;
                }

                originUser.U_Password = "**********";
                destUser.U_Password = "**********";

                userAry[0] = originUser;
                userAry[1] = destUser;

                resJson.addition = userAry;
                resJson.status = ResponseStatus.Success;
                return resJson;
            }
            catch (Exception ex)
            {
                resJson.status = ResponseStatus.Error;
                resJson.message = ex.Message;
                resJson.detail = StaticHelper.GetExceptionMessageAndRecord(ex);
                return resJson;
            }
        }

    }
}