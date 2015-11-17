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

            var tmpMs =
                olsEni
                .Departments
                .OrderBy(model => model.D_Id)
                .Where(model =>
                    model.D_Name.Contains(dtRequest.SearchValue)
                    && model.D_Status != (Byte)Status.Delete)
                .Select(model => new
                {
                    D_Id = model.D_Id,
                    D_Name = model.D_Name,
                    D_Level = model.D_Level,
                    D_Remark = model.D_Remark,
                    D_AddTime = model.D_AddTime,
                    D_Status = model.D_Status
                })
                .ToList();

            // 获取分类名称
            ms = new List<Department>();

            foreach (var model in tmpMs)
            {

                ms.Add(new Department()
                {
                    D_Id = model.D_Id,
                    D_Name = model.D_Name,
                    D_Level = model.D_Level,
                    D_Remark = model.D_Remark,
                    D_AddTime = model.D_AddTime,
                    D_Status = model.D_Status
                });
            }

            tmpMs = null;

            recordsFiltered = ms.Count();
            dtResponse.recordsFiltered = recordsFiltered;

            if (-1 != dtRequest.Length)
            {
                ms =
                    ms
                    .Skip(dtRequest.Start).Take(dtRequest.Length)
                    .ToList();
            }

            dtResponse.data = ms;

            return dtResponse;
        }

        public Department GetNew()
        {

            Department model;

            model = new Department()
            {
                D_Id = 0,
                D_Name = "",
                D_Level = "",
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

                Int32 rowCount;
                Int32 id;

                rowCount = olsEni.Departments.Count();
                id = 0 == rowCount ? 0 : olsEni.Departments.Max(m => m.D_AutoId);

                model.D_Id = id + 1;

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
    }
}