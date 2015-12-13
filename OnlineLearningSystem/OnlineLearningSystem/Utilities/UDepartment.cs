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
            return olsEni.Departments.Where(m => m.D_Status == (Byte)Status.Available).ToList();
        }

        public DataTablesResponse ListDataTablesAjax(DataTablesRequest dtRequest)
        {

            DataTablesResponse dtResponse;
            Int32 recordsTotal, recordsFiltered;
            String whereSql, orderColumn;
            Object[] modelDatas;
            List<Department> ms;


            dtResponse = new DataTablesResponse();

            dtResponse.draw = dtRequest.Draw;

            recordsTotal = olsEni.Departments.Count();
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

            modelDatas = GetModels(dtRequest);
            ms = (List<Department>)modelDatas[1];

            recordsFiltered = (Int32)modelDatas[0];
            dtResponse.recordsFiltered = recordsFiltered;
            dtResponse.data = ms;

            return dtResponse;
        }

        private object[] GetModels(DataTablesRequest dtRequest)
        {

            Int32 count;
            List<Department> ms;

            count = olsEni
                .Departments
                .OrderBy(m => m.D_Sort)
                .Where(m =>
                    m.D_Name.Contains(dtRequest.SearchValue)
                    && m.D_Status != (Byte)Status.Delete)
                .Count();

            if (-1 == dtRequest.Length)
            {

                ms =
                    olsEni
                    .Departments
                    .OrderBy(m => m.D_Sort)
                    .Where(m =>
                        m.D_Name.Contains(dtRequest.SearchValue)
                        && m.D_Status != (Byte)Status.Delete)
                    .ToList();

            }
            else
            {

                ms =
                    olsEni
                    .Departments
                    .Where(m =>
                        m.D_Name.Contains(dtRequest.SearchValue)
                        && m.D_Status != (Byte)Status.Delete)
                    .OrderBy(m => m.D_Sort)
                    .Skip(dtRequest.Start).Take(dtRequest.Length)
                    .ToList();
            }

            return new Object[] { count, ms };
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

            model = olsEni.Departments.SingleOrDefault(m => m.D_Id == id);

            if (null == model)
            {
                throw new NotImplementedException();
            }

            return model;
        }

        public Boolean Create(Department model)
        {
            try
            {

                Int32 id;

                id = olsEni.Departments.Count();
                id = 1 == id ? 1 : olsEni.Departments.Max(m => m.D_AutoId) + 1;

                model.D_Id = id + 1;
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

                throw;
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
                Department model;

                model = olsEni.Departments.SingleOrDefault(m => m.D_Id == id);

                if (null == model)
                {
                    resJson.message = "数据不存在！";
                    return resJson;
                }

                model.D_Status = (Byte)status;
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

        public String GetDepartmentsAndUsersZTreeJson()
        {

            List<Department> ds;
            List<User_Department> uds;
            User u;
            StringBuilder zTreeJson;

            ds = olsEni.Departments.Where(m => m.D_Status == (Byte)Status.Available).ToList();

            zTreeJson = new StringBuilder();
            zTreeJson.Append("[");

            foreach (var d in ds)
            {

                zTreeJson.Append("{");
                zTreeJson.Append("\"departmentId\":" + d.D_Id + ", \"name\":\"" + d.D_Name + "\"");

                uds = olsEni.User_Department.Where(m => m.D_Id == d.D_Id).ToList();
                if (uds.Count > 0)
                {

                    zTreeJson.Append(", \"children\":[");

                    foreach (var ud in uds)
                    {

                        zTreeJson.Append("{");

                        u = olsEni.Users.SingleOrDefault(m => m.U_Id == ud.U_Id);
                        if (null != u)
                        {
                            zTreeJson.Append("\"userNode\": true, \"departmentId\":" + d.D_Id + ", \"userId\":" + u.U_Id + ", \"name\":\"" + u.U_Name + "\"");
                        }

                        zTreeJson.Append("},");
                    }

                    zTreeJson.Remove(zTreeJson.Length - 1, 1);
                    zTreeJson.Append("]");
                }

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

                    us =
                        olsEni
                        .Departments
                        .Where(m => m.D_Sort < originSort)
                        .OrderByDescending(m => m.D_Sort)
                        .Take(2).ToList();

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

                    us =
                        olsEni
                        .Departments
                        .Where(m => m.D_Sort > originSort)
                        .OrderBy(m => m.D_Sort)
                        .Take(1).ToList();

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
                    resJson.message = ResponseMessage.SaveChangeError;
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
                resJson.message = StaticHelper.GetExceptionMessage(ex);
                return resJson;
            }
        }
    }
}