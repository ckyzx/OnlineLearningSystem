using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Web;
using System.Web.Mvc;
using OnlineLearningSystem.Models;
using Newtonsoft.Json;

namespace OnlineLearningSystem.Utilities
{
    public class URole : Utility
    {
        public List<Role> List()
        {
            return olsEni.Roles.Where(m => m.R_Status == (Byte)Status.Available).ToList();
        }

        public DataTablesResponse ListDataTablesAjax(DataTablesRequest dtRequest)
        {

            DataTablesResponse dtResponse;
            UModel<Role> umodel;

            umodel = new UModel<Role>(dtRequest, "Roles", "R_Id");
            dtResponse = umodel.GetList("R_Status");

            return dtResponse;
        }

        public Role GetNew()
        {

            Role model;

            model = new Role()
            {
                R_Id = 0,
                R_Name = "",
                R_Permissions = "[]",
                R_PermissionCategories = "[]",
                R_Remark = "",
                R_AddTime = DateTime.Now,
                R_Status = (Byte)Status.Available
            };

            return model;
        }

        public Role Get(Int32 id)
        {
            Role model;

            model = olsEni.Roles.SingleOrDefault(m => m.R_Id == id);

            if (null == model)
            {
                throw new NotImplementedException();
            }

            return model;
        }

        public Boolean Create(Role model)
        {
            try
            {

                Int32 rowCount;
                Int32 id;

                rowCount = olsEni.Roles.Count();
                id = 0 == rowCount ? 0 : olsEni.Roles.Max(m => m.R_AutoId);

                model.R_Id = id + 1;
                olsEni.Roles.Add(model);
                olsEni.SaveChanges();

                UpdateRolePermission(model);

                return true;
            }
            catch (Exception ex)
            {

                throw;
            }
        }

        private void UpdateRolePermission(Role model)
        {

            List<Role_Permission> rps;
            Int32[] permissionIds;

            rps = olsEni.Role_Permission.Where(m => m.R_Id == model.R_Id).ToList();

            foreach (var rp in rps)
            {
                olsEni.Entry(rp).State = EntityState.Deleted;
            }
            olsEni.SaveChanges();

            permissionIds = JsonConvert.DeserializeObject<Int32[]>(model.R_Permissions);

            foreach (var pId in permissionIds)
            {
                olsEni.Entry(new Role_Permission
                {
                    R_Id = model.R_Id,
                    P_Id = pId
                }).State = EntityState.Added;
            }
            olsEni.SaveChanges();

        }

        public Boolean Edit(Role model)
        {
            try
            {
                olsEni.Entry(model).State = EntityState.Modified;
                olsEni.SaveChanges();

                UpdateRolePermission(model);

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
                Role model;

                model = olsEni.Roles.SingleOrDefault(m => m.R_Id == id);

                if (null == model)
                {
                    resJson.message = "数据不存在！";
                    return resJson;
                }

                model.R_Status = (Byte)status;
                olsEni.Entry(model).State = EntityState.Modified;
                olsEni.SaveChanges();

                resJson.status = ResponseStatus.Success;
                return resJson;
            }
            catch (Exception ex)
            {
                resJson.status = ResponseStatus.Error;
                resJson.message = StaticHelper.GetExceptionMessageAndRecord(ex);
                return resJson;
            }
        }

        public Boolean DuplicateName(Int32 id, String name)
        {

            try
            {

                Int32 count;

                count = olsEni.Roles.Where(m => m.R_Id != id && m.R_Name == name).Count();

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