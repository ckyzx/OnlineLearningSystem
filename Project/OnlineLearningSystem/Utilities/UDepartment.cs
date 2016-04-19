using System;
using System.Collections.Generic;
using System.Linq;
using System.Data;
using System.Web;
using System.Web.Mvc;
using OnlineLearningSystem.Models;
using System.Text;
using Newtonsoft.Json;

namespace OnlineLearningSystem.Utilities
{
    public class UDepartment : Utility
    {

        public List<Department> List()
        {
            return olsEni.Departments.Where(m => m.D_Status == (Byte)Status.Available).OrderBy(m => m.D_Sort).ToList();
        }

        public DataTablesResponse ListDataTablesAjax(DataTablesRequest dtRequest)
        {

            DataTablesResponse dtResponse;
            UModel<Department> umodel;

            umodel = new UModel<Department>(dtRequest, "Departments", "D_Id");
            dtResponse = umodel.GetList("D_Status", "D_Sort");

            return dtResponse;
        }

        public Department GetNew()
        {

            Department model;

            model = new Department()
            {
                D_Name = "",
                D_Level = "",
                D_Roles = "[]",
                D_Remark = "",
                D_AddTime = DateTime.Now,
                D_Status = (Byte)Status.Available
            };

            return model;
        }

        public Department Get(Int32 id)
        {
            Department model;

            model = olsEni.Departments.Single(m => m.D_Id == id && m.D_Status == (Byte)Status.Available);

            return model;
        }

        public Boolean Create(Department model)
        {
            try
            {

                Int32 id;

                id = GetDId();

                model.D_Id = id;
                model.D_Sort = id;

                if (null == model.D_Level)
                {

                    model.D_Level = String.Format("{0:D4}", model.D_Id);
                }

                olsEni.Departments.Add(model);
                olsEni.SaveChanges();

                UpdateDepartmentRole(model);

                return true;
            }
            catch (Exception ex)
            {
                StaticHelper.RecordSystemLog(ex);
                return false;
            }
        }

        public void UpdateDepartmentRole(Department model)
        {

            List<Department_Role> drs;
            Int32[] rs;

            drs = olsEni.Department_Role.Where(m => m.D_Id == model.D_Id).ToList();
            foreach (var dr in drs)
            {
                olsEni.Entry(dr).State = EntityState.Deleted;
            }
            olsEni.SaveChanges();

            rs = JsonConvert.DeserializeObject<Int32[]>(model.D_Roles);
            foreach (var r in rs)
            {

                olsEni.Department_Role.Add(new Department_Role
                {
                    D_Id = model.D_Id,
                    R_Id = Convert.ToInt32(r)
                });
            }
            olsEni.SaveChanges();

        }

        public Boolean Edit(Department model)
        {
            try
            {

                if (null == model.D_Level)
                {
                    model.D_Level = String.Format("{0:D4}", model.D_Id);
                }

                olsEni.Entry(model).State = EntityState.Modified;
                olsEni.SaveChanges();

                UpdateDepartmentRole(model);

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
                Department model;

                model = olsEni.Departments.SingleOrDefault(m => m.D_Id == id);

                if (null == model)
                {
                    resJson.message = "数据不存在！";
                    return resJson;
                }

                // 处理部门中的用户状态
                setUserStatus(id, status);

                model.D_Status = (Byte)status;
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

        private void setUserStatus(int dId, Status status)
        {
            List<User_Department> uds;
            List<User> us;

            if (status != Status.Available)
            {
                uds = olsEni.User_Department.Where(m => m.D_Id == dId).ToList();
                foreach (var ud in uds)
                {
                    us = olsEni.Users.Where(m => m.U_Id == ud.U_Id).ToList();
                    foreach (var u in us)
                    {
                        if (u.U_Status != (Byte)status)
                        {
                            u.U_Status = (Byte)status;
                        }
                    }
                }
            }
        }

        public String GetZTreeJsonWithUsers()
        {

            return GetZTreeJson(true);
        }

        public String GetZTreeJson(Boolean hasUser = false)
        {

            List<Department> ds;
            StringBuilder zTreeJson;

            ds = olsEni.Departments.Where(m => m.D_Status == (Byte)Status.Available).OrderBy(m => m.D_Sort).ToList();

            zTreeJson = new StringBuilder();
            zTreeJson.Append("[");

            foreach (var d in ds)
            {

                zTreeJson.Append("{");
                zTreeJson.Append("\"departmentId\":" + d.D_Id + ", \"name\":\"" + d.D_Name + "\"");

                if (hasUser)
                {
                    zTreeJson.Append(GetUsersZTreeJson(d.D_Id));
                }

                zTreeJson.Append("},");
            }

            zTreeJson.Remove(zTreeJson.Length - 1, 1);
            zTreeJson.Append("]");

            return zTreeJson.ToString();
        }

        private String GetUsersZTreeJson(Int32 dId)
        {

            StringBuilder zTreeJson;
            User u;
            List<User_Department> uds;
            List<User> us;

            zTreeJson = new StringBuilder();

            uds = olsEni.User_Department.Where(m => m.D_Id == dId).ToList();
            if (uds.Count > 0)
            {

                zTreeJson.Append(", \"children\":[ ");

                us = new List<User>();
                foreach (var ud in uds)
                {

                    u = olsEni.Users.SingleOrDefault(m =>
                        m.U_Id == ud.U_Id
                        && m.U_Status == (Byte)Status.Available);
                    if (null != u)
                    {
                        us.Add(u);
                    }
                }
                us = us.OrderBy(m => m.U_Sort).ToList();
                foreach (var u1 in us)
                {
                    zTreeJson.Append("{");
                    zTreeJson.Append("\"userNode\": true, \"departmentId\":" + dId + ", \"userId\":" + u1.U_Id + ", \"name\":\"" + u1.U_Name + "\"");
                    zTreeJson.Append("},");
                }
                zTreeJson.Remove(zTreeJson.Length - 1, 1);
                zTreeJson.Append("]");
            }

            return zTreeJson.ToString();
        }

        public ResponseJson GetZTreeResJson(Byte status)
        {

            ResponseJson resJson;

            resJson = new ResponseJson(ResponseStatus.Success, now);
            resJson.data = GetZTreeJson(status);

            return resJson;
        }

        public String GetZTreeJson(Byte status)
        {

            List<Department> ds;
            StringBuilder zTreeJson;

            ds = olsEni.Departments.Where(m => m.D_Status == (Byte)Status.Available).OrderBy(m => m.D_Sort).ToList();

            if (status == (Byte)Status.Unset)
            {
                // 当状态为“[未设置]”，显示除“删除”以外部门
                ds = olsEni.Departments.Where(m => m.D_Status != (Byte)Status.Delete).OrderBy(m => m.D_Sort).ToList();
            }
            // 当状态为“缓存”或“回收”，需同时获取“正常”部门
            // 因为“缓存”或“回收”用户的部门可能是“正常”的
            else if (status != (Byte)Status.Delete)
            {
                ds =
                    olsEni.Departments
                    .Where(m =>
                        m.D_Status == status
                        || m.D_Status == (Byte)Status.Available)
                    .OrderBy(m => m.D_Sort)
                    .ToList();
            }
            else
            {
                ds = olsEni.Departments.Where(m => m.D_Status == status).OrderBy(m => m.D_Sort).ToList();
            }

            zTreeJson = new StringBuilder();
            zTreeJson.Append("[");

            foreach (var d in ds)
            {

                zTreeJson.Append("{");
                zTreeJson.Append("\"departmentId\":" + d.D_Id + ", \"name\":\"" + d.D_Name + "\"");
                zTreeJson.Append("},");
            }

            zTreeJson.Remove(zTreeJson.Length - 1, 1);
            zTreeJson.Append("]");

            return zTreeJson.ToString();
        }

        public Boolean DuplicateName(Int32 id, String name)
        {

            try
            {

                Int32 count;

                count = olsEni.Departments.Where(m => m.D_Id != id && m.D_Name == name).Count();

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

                String name;
                Double originSort, destSort;
                Department originModel, destModel, adjustModel;
                Department[] modelAry;
                List<Department> us;

                name = "部门";
                modelAry = new Department[2];

                originModel = olsEni.Departments.Single(m => m.D_Id == originId);
                originSort = originModel.D_Sort;

                // 置顶
                if (1 == sortFlag)
                {

                    destSort = olsEni.Departments.Min(m => m.D_Sort);
                    destModel = olsEni.Departments.Single(m => m.D_Sort == destSort);

                    if (destSort == originSort)
                    {
                        resJson.status = ResponseStatus.Error;
                        resJson.message = "该" + name + "已置顶。";
                        return resJson;
                    }

                    originSort = destSort - 1;
                    originModel.D_Sort = originSort;
                }
                else if (2 == sortFlag)
                {

                    us = olsEni.Departments
                        .Where(m => m.D_Sort < originSort)
                        .OrderByDescending(m => m.D_Sort).Take(2).ToList();

                    if (us.Count == 0)
                    {
                        resJson.status = ResponseStatus.Error;
                        resJson.message = "该" + name + "已处于顶部。";
                        return resJson;
                    }
                    else if (us.Count == 1)
                    {
                        destModel = us[0];
                        originSort = destModel.D_Sort;
                        destSort = originModel.D_Sort;
                        originModel.D_Sort = originSort;
                        destModel.D_Sort = destSort;
                    }
                    else
                    {
                        destModel = us[1];
                        destSort = destModel.D_Sort;
                        originSort = Math.Round(destSort + 0.00001, 5, MidpointRounding.AwayFromZero);
                        originModel.D_Sort = originSort;
                    }

                }
                else// if (3 == sortFlag)
                {

                    us = olsEni.Departments
                        .Where(m => m.D_Sort > originSort)
                        .OrderBy(m => m.D_Sort).Take(1).ToList();

                    if (us.Count == 0)
                    {
                        resJson.status = ResponseStatus.Error;
                        resJson.message = "该" + name + "已处于底部。";
                        return resJson;
                    }

                    destModel = us[0];
                    destSort = destModel.D_Sort;

                    originSort = Math.Round(destSort + 0.00001, 5, MidpointRounding.AwayFromZero);
                    originModel.D_Sort = originSort;
                }

                adjustModel = olsEni.Departments.SingleOrDefault(m => m.D_Sort == originSort);
                if (adjustModel != null)
                {
                    adjustModel.D_Sort = Math.Round(originSort + 0.00001, 5, MidpointRounding.AwayFromZero);
                }

                if (0 == olsEni.SaveChanges())
                {
                    resJson.status = ResponseStatus.Error;
                    resJson.message = ResponseMessage.SaveChangesError;
                    return resJson;
                }

                modelAry[0] = originModel;
                modelAry[1] = destModel;

                resJson.addition = modelAry;
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

        internal List<SelectListItem> GetDepartmentList(Int32 currentValue = 0)
        {

            List<SelectListItem> list;

            var items = olsEni.Departments
                .Where(m => m.D_Status == (Byte)Status.Available)
                .OrderBy(m => m.D_Sort)
                .Select(model => new { model.D_Name, model.D_Id });

            list = new List<SelectListItem>();
            list.Add(new SelectListItem() { Text = "", Value = "" });

            foreach (var i in items)
            {
                list.Add(new SelectListItem
                {
                    Text = i.D_Name,
                    Value = i.D_Id.ToString(),
                    Selected = i.D_Id == currentValue ? true : false
                });
            }

            return list;
        }
    }
}