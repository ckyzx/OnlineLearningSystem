using System;
using System.Collections.Generic;
using System.Linq;
using System.Data;
using System.Web;
using System.Web.Mvc;
using OnlineLearningSystem.Models;

namespace OnlineLearningSystem.Utilities
{
    public class UDuty : Utility
    {
        public DataTablesResponse ListDataTablesAjax(DataTablesRequest dtRequest)
        {

            DataTablesResponse dtResponse;
            Int32 recordsTotal, recordsFiltered;
            String whereSql, orderColumn;
            List<Duty> ms;


            dtResponse = new DataTablesResponse();

            dtResponse.draw = dtRequest.Draw;

            recordsTotal = olsEni.Duties.Count();
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
                .Duties
                .OrderBy(model => model.Du_Id)
                .Where(model =>
                    model.Du_Name.Contains(dtRequest.SearchValue)
                    && model.Du_Status != (Byte)Status.Delete)
                .Select(model => new
                {
                    Du_Id = model.Du_Id,
                    Du_Name = model.Du_Name,
                    Du_Remark = model.Du_Remark,
                    Du_AddTime = model.Du_AddTime,
                    Du_Status = model.Du_Status
                })
                .ToList();

            // 获取分类名称
            ms = new List<Duty>();

            foreach (var model in tmpMs)
            {

                ms.Add(new Duty()
                {
                    Du_Id = model.Du_Id,
                    Du_Name = model.Du_Name,
                    Du_Remark = model.Du_Remark,
                    Du_AddTime = model.Du_AddTime,
                    Du_Status = model.Du_Status
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

        public Duty GetNew()
        {

            Duty model;

            model = new Duty()
            {
                Du_Id = 0,
                Du_Name = "",
                Du_Remark = "",
                Du_AddTime = DateTime.Now,
                Du_Status = (Byte)Status.Available
            };

            return model;
        }

        public Duty Get(Int32 id)
        {
            Duty model;

            model = olsEni.Duties.SingleOrDefault(m => m.Du_Id == id);

            if (null == model)
            {
                throw new NotImplementedException();
            }

            return model;
        }

        public Boolean Create(Duty model)
        {
            try
            {

                Int32 rowCount;
                Int32 id;

                rowCount = olsEni.Duties.Count();
                id = 0 == rowCount ? 0 : olsEni.Duties.Max(m => m.Du_AutoId);

                model.Du_Id = id + 1;
                olsEni.Duties.Add(model);
                olsEni.SaveChanges();

                return true;
            }
            catch (Exception ex)
            {

                throw;
            }
        }

        public Boolean Edit(Duty model)
        {
            try
            {
                olsEni.Entry(model).State = EntityState.Modified;
                olsEni.SaveChanges();

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
                Duty model;

                model = olsEni.Duties.SingleOrDefault(m => m.Du_Id == id);

                if (null == model)
                {
                    resJson.message = "数据不存在！";
                    return resJson;
                }

                model.Du_Status = (Byte)status;
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

    }
}