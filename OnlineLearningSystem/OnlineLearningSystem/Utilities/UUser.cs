using System;
using System.Collections.Generic;
using System.Linq;
using System.Data;
using System.Web;
using System.Web.Mvc;
using OnlineLearningSystem.Models;
using Newtonsoft.Json;
using System.Text;
using System.Security.Cryptography;

namespace OnlineLearningSystem.Utilities
{
    public class UUser : Utility
    {

        public DataTablesResponse ListDataTablesAjax(DataTablesRequest dtRequest)
        {

            DataTablesResponse dtResponse;
            Int32 recordsTotal, recordsFiltered;
            Duty d;
            String whereSql, orderColumn, dutyName;
            List<User> us;


            dtResponse = new DataTablesResponse();

            dtResponse.draw = dtRequest.Draw;

            recordsTotal = olsEni.Users.Count();
            dtResponse.recordsTotal = recordsTotal;


            //TODO:指定筛选条件
            whereSql = "";
            foreach (var col in dtRequest.Columns)
            {

                if ("" != col.Name)
                {

                    whereSql += col.Name + "||";
                }
            }

            //TODO:指定排序列
            orderColumn = dtRequest.Columns[dtRequest.OrderColumn].Name;

            var tmpQs =
                olsEni
                .Users
                .OrderBy(m => m.U_Id)
                .Where(m =>
                    (m.U_Name.Contains(dtRequest.SearchValue)
                    || m.U_LoginName.Contains(dtRequest.SearchValue))
                    && m.U_Status != (Byte)Status.Delete)
                .Select(m => new
                {
                    U_Id = m.U_Id,
                    U_Duty = m.Du_Id,
                    U_Name = m.U_Name,
                    U_LoginName = m.U_LoginName,
                    U_Remark = m.U_Remark,
                    U_AddTime = m.U_AddTime,
                    U_Status = m.U_Status
                })
                .ToList();

            // 获取分类名称
            us = new List<User>();

            foreach (var m in tmpQs)
            {

                d = olsEni.Duties.SingleOrDefault(m1 => m1.Du_Id == m.U_Duty);
                dutyName = null == d ? "" : d.Du_Name;

                us.Add(new User()
                {
                    U_Id = m.U_Id,
                    Du_Id = m.U_Duty,
                    Du_Name = dutyName,
                    U_Name = m.U_Name,
                    U_LoginName = m.U_LoginName,
                    U_Remark = m.U_Remark,
                    U_AddTime = m.U_AddTime,
                    U_Status = m.U_Status
                });
            }

            tmpQs = null;

            recordsFiltered = us.Count();
            dtResponse.recordsFiltered = recordsFiltered;

            if (-1 != dtRequest.Length)
            {
                us =
                    us
                    .Skip(dtRequest.Start).Take(dtRequest.Length)
                    .ToList();
            }

            dtResponse.data = us;

            return dtResponse;
        }

        public List<SelectListItem> GetDutyList(Int32? currentValue)
        {

            List<SelectListItem> list;

            var items =
                olsEni.
                Duties.
                Where(m => m.Du_Status == (Byte)Status.Available)
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

        public User GetNew()
        {

            User model;

            model = new User()
            {
                U_Id = 0,
                Du_Id = 0,
                Du_Name = "",
                U_Name = "",
                U_LoginName = "",
                U_Password = "",
                U_Departments = "{}",
                U_Remark = "",
                U_AddTime = DateTime.Now,
                U_Status = (Byte)Status.Available
            };

            return model;
        }

        public User Get(Int32 id)
        {

            User model;

            model = olsEni.Users.SingleOrDefault(m => m.U_Id == id);

            if (null == model)
            {
                throw new NotImplementedException();
            }

            return model;
        }

        public Boolean Create(User model)
        {
            try
            {

                Int32 rowCount;
                Int32 uId;

                rowCount = olsEni.Users.Count();
                uId = 0 == rowCount ? 0 : olsEni.Users.Max(m => m.U_AutoId);

                model.U_Id = uId + 1;
                model.U_Password = EncryptPassword(model.U_Password);

                olsEni.Users.Add(model);
                olsEni.SaveChanges();

                UpdateUserDepartment(model);

                return true;
            }
            catch (Exception ex)
            {

                throw;
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

        public Boolean Edit(User model)
        {
            try
            {

                model.U_Password = EncryptPassword(model.U_Password);

                olsEni.Entry(model).State = EntityState.Modified;
                olsEni.SaveChanges();

                UpdateUserDepartment(model);

                return true;
            }
            catch (Exception ex)
            {

                throw;
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
                resJson.message = StaticHelper.GetExceptionMessage(ex);
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

                u =
                    olsEni
                    .Users
                    .SingleOrDefault(m =>
                        (m.U_Name.ToLower() == userName
                        && m.U_Password == password)
                        || (m.U_LoginName.ToLower() == userName
                        && m.U_Password == password));

                if (null == u)
                {
                    resJson.message = "用户名或密码有误。";
                    return resJson;
                }



                // 收集角色列表
                var rs = GetUserRoleList(u.U_Id);
                var ds = GetDepartmentList(u.U_Id);

                if(rs.Count() == 0){
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
                resJson.message = StaticHelper.GetExceptionMessage(ex);
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

                model = olsEni.Users.SingleOrDefault(m => m.U_Id == uId);

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
                resJson.message = StaticHelper.GetExceptionMessage(ex);
                return resJson;
            }
        }

        public Boolean CheckPassword(Int32 uId, String password)
        {
            try
            {
                
                User model;

                model = olsEni.Users.SingleOrDefault(m => m.U_Id == uId);

                if (null == model)
                {
                    return false;
                }

                password = EncryptPassword(password);

                if (password == model.U_Password)
                {
                    return true;
                }

                return false;
            }
            catch (Exception ex)
            {
                return false;
            }
        }
    }
}