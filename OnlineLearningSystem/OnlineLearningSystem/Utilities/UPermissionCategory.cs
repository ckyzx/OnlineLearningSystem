using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Web;
using System.Web.Mvc;
using OnlineLearningSystem.Models;
using Newtonsoft.Json;
using System.Text;

namespace OnlineLearningSystem.Utilities
{
    public class UPermissionCategory : Utility
    {
        public DataTablesResponse ListDataTablesAjax(DataTablesRequest dtRequest)
        {

            DataTablesResponse dtResponse;
            Int32 recordsTotal, recordsFiltered;
            String whereSql, orderColumn;
            List<PermissionCategory> ms;


            dtResponse = new DataTablesResponse();

            dtResponse.draw = dtRequest.Draw;

            recordsTotal = olsEni.PermissionCategories.Count();
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
                .PermissionCategories
                .OrderBy(model => model.PC_Id)
                .Where(model =>
                    model.PC_Name.Contains(dtRequest.SearchValue)
                    && model.PC_Status != (Byte)Status.Delete)
                .Select(model => new
                {
                    PC_Id = model.PC_Id,
                    PC_Name = model.PC_Name,
                    PC_Remark = model.PC_Remark,
                    PC_AddTime = model.PC_AddTime,
                    PC_Status = model.PC_Status
                })
                .ToList();

            // 获取分类名称
            ms = new List<PermissionCategory>();

            foreach (var model in tmpMs)
            {

                ms.Add(new PermissionCategory()
                {
                    PC_Id = model.PC_Id,
                    PC_Name = model.PC_Name,
                    PC_Remark = model.PC_Remark,
                    PC_AddTime = model.PC_AddTime,
                    PC_Status = model.PC_Status
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

        public PermissionCategory GetNew()
        {

            PermissionCategory model;

            model = new PermissionCategory()
            {
                PC_Id = 0,
                PC_Name = "",
                PC_Permissions = "[]",
                PC_Remark = "",
                PC_AddTime = DateTime.Now,
                PC_Status = (Byte)Status.Available
            };

            return model;
        }

        public PermissionCategory Get(Int32 id)
        {

            PermissionCategory model;
            List<ActionPermission> aps;

            model = olsEni.PermissionCategories.SingleOrDefault(m => m.PC_Id == id);

            if (null == model)
            {
                throw new NotImplementedException();
            }

            aps =
                olsEni
                .Permissions
                .Where(m => m.PC_Id == model.PC_Id)
                .Select(m => new ActionPermission
                {
                    ControllerName = m.P_Controller,
                    ActionName = m.P_Action,
                    Description = m.P_Name
                }).ToList();

            model.PC_Permissions = JsonConvert.SerializeObject(aps);

            return model;
        }

        public Boolean Create(PermissionCategory model)
        {
            try
            {

                DateTime now;
                Int32 rowCount;
                Int32 id;

                now = DateTime.Now;

                rowCount = olsEni.PermissionCategories.Count();
                id = 0 == rowCount ? 1 : olsEni.PermissionCategories.Max(m => m.PC_AutoId) + 1;

                model.PC_Id = id;

                if (null == model.PC_Level)
                {
                    model.PC_Level = String.Format("{0:D4}", model.PC_Id);
                }

                olsEni.PermissionCategories.Add(model);
                olsEni.SaveChanges();

                UpdatePermission(model);

                return true;
            }
            catch (Exception ex)
            {

                throw;
            }
        }

        public Boolean Edit(PermissionCategory model)
        {
            try
            {

                DateTime now;

                now = DateTime.Now;

                if (null == model.PC_Level)
                {
                    model.PC_Level = String.Format("{0:D4}", model.PC_Id);
                }

                olsEni.Entry(model).State = EntityState.Modified;
                olsEni.SaveChanges();

                UpdatePermission(model);

                return true;
            }
            catch (Exception ex)
            {

                throw;
            }
        }

        private void UpdatePermission(PermissionCategory model)
        {

            Int32 rowCount;
            Int32 id;
            List<ActionPermission> aps;
            Permission p;

            aps = (List<ActionPermission>)JsonConvert.DeserializeObject<List<ActionPermission>>(model.PC_Permissions);

            rowCount = olsEni.Permissions.Count();
            id = 0 == rowCount ? 1 : olsEni.Permissions.Max(m => m.P_AutoId) + 1;

            foreach (var ap in aps)
            {

                p = olsEni
                    .Permissions
                    .SingleOrDefault(m =>
                        m.P_Controller == ap.ControllerName
                        && m.P_Action == ap.ActionName
                        && m.P_Name == ap.Description);

                // 不重复插入权限记录，如果已存在权限记录将重设其权限目录
                if (null == p)
                {

                    olsEni.Permissions.Add(new Permission
                    {
                        P_Id = id,
                        PC_Id = model.PC_Id,
                        P_Name = ap.Description,
                        P_Controller = ap.ControllerName,
                        P_Action = ap.ActionName,
                        P_AddTime = now
                    });

                    id += 1;
                }
                else
                {

                    p.PC_Id = model.PC_Id;
                    olsEni.Entry(p).State = EntityState.Modified;
                }
            }
            olsEni.SaveChanges();
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
                PermissionCategory model;

                model = olsEni.PermissionCategories.SingleOrDefault(m => m.PC_Id == id);

                if (null == model)
                {
                    resJson.message = "数据不存在！";
                    return resJson;
                }

                model.PC_Status = (Byte)status;
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

        public String GetPermissionCategoriesZTreeJson()
        {

            List<PermissionCategory> pcs;
            List<Permission> ps;
            StringBuilder zTreeJson;

            pcs = olsEni.PermissionCategories.Where(m => m.PC_Status == (Byte)Status.Available).ToList();

            zTreeJson = new StringBuilder();
            zTreeJson.Append("[");

            foreach (var pc in pcs)
            {

                zTreeJson.Append("{");
                zTreeJson.Append("\"permissionCategoryId\":" + pc.PC_Id + ", \"name\":\"" + pc.PC_Name + "\"");

                ps = olsEni.Permissions.Where(m => m.PC_Id == pc.PC_Id).ToList();
                if (ps.Count > 0)
                {

                    zTreeJson.Append(", \"children\":[");

                    foreach (var p in ps)
                    {

                        zTreeJson.Append("{");

                        zTreeJson.Append("\"permissionNode\": true, \"permissionCategoryId\":" + pc.PC_Id + ", \"permissionId\":" + p.P_Id + ", \"name\":\"" + p.P_Name + "\"");

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

                count = olsEni.PermissionCategories.Where(m => m.PC_Id != id && m.PC_Name == name).Count();

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
    }
}