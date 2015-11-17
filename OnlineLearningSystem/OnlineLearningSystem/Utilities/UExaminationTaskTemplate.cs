using System;
using System.Collections.Generic;
using System.Linq;
using System.Data;
using System.Web;
using System.Web.Mvc;
using OnlineLearningSystem.Models;

namespace OnlineLearningSystem.Utilities
{
    public class UExaminationTaskTemplate : Utility
    {

        public DataTablesResponse ListDataTablesAjax(DataTablesRequest dtRequest)
        {

            DataTablesResponse dtResponse;
            Int32 recordsTotal, recordsFiltered;
            String whereSql, orderColumn;
            List<ExaminationTaskTemplate> ms;


            dtResponse = new DataTablesResponse();

            dtResponse.draw = dtRequest.Draw;

            recordsTotal = olsEni.ExaminationTaskTemplates.Count();
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
                .ExaminationTaskTemplates
                .OrderBy(model => model.ETT_Id)
                .Where(model =>
                    model.ETT_Name.Contains(dtRequest.SearchValue)
                    && model.ETT_Status != (Byte)Status.Delete)
                .Select(model => new
                {
                    ETT_Id = model.ETT_Id,
                    ETT_Name = model.ETT_Name,
                    ETT_ParticipatingDepartment = model.ETT_ParticipatingDepartment,
                    ETT_Attendee = model.ETT_Attendee,
                    ETT_AutoType = model.ETT_AutoType,
                    ETT_StartTime = model.ETT_StartTime,
                    ETT_EndTime = model.ETT_EndTime,
                    ETT_TimeSpan = model.ETT_TimeSpan,
                    ETT_Remark = model.ETT_Remark,
                    ETT_AddTime = model.ETT_AddTime,
                    ETT_Status = model.ETT_Status
                })
                .ToList();

            // 获取分类名称
            ms = new List<ExaminationTaskTemplate>();

            foreach (var model in tmpMs)
            {

                ms.Add(new ExaminationTaskTemplate()
                {
                    ETT_Id = model.ETT_Id,
                    ETT_Name = model.ETT_Name,
                    ETT_ParticipatingDepartment = model.ETT_ParticipatingDepartment,
                    ETT_Attendee = model.ETT_Attendee,
                    ETT_AutoType = model.ETT_AutoType,
                    ETT_StartTime = model.ETT_StartTime,
                    ETT_EndTime = model.ETT_EndTime,
                    ETT_TimeSpan = model.ETT_TimeSpan,
                    ETT_Remark = model.ETT_Remark,
                    ETT_AddTime = model.ETT_AddTime,
                    ETT_Status = model.ETT_Status
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

        public ExaminationTaskTemplate GetNew()
        {

            DateTime initDateTime;
            ExaminationTaskTemplate model;

            initDateTime = new DateTime(1970, 1, 1);

            model = new ExaminationTaskTemplate()
            {
                ETT_Id = 0,
                ETT_Name = "",
                ETT_ParticipatingDepartment = "[]",
                ETT_Attendee = "[]",
                ETT_StartTime = initDateTime,
                ETT_EndTime = initDateTime.AddDays(7),
                ETT_TimeSpan = 60,
                ETT_Remark = "",
                ETT_AddTime = DateTime.Now,
                ETT_Status = (Byte)Status.Available
            };

            return model;
        }

        public ExaminationTaskTemplate Get(Int32 id)
        {
            ExaminationTaskTemplate model;

            model = olsEni.ExaminationTaskTemplates.SingleOrDefault(m => m.ETT_Id == id);

            if (null == model)
            {
                throw new NotImplementedException();
            }

            return model;
        }

        public Boolean Create(ExaminationTaskTemplate model)
        {
            try
            {

                Int32 rowCount;
                Int32 id;

                rowCount = olsEni.ExaminationTaskTemplates.Count();
                id = 0 == rowCount ? 0 : olsEni.ExaminationTaskTemplates.Max(m => m.ETT_AutoId);

                model.ETT_Id = id + 1;
                olsEni.ExaminationTaskTemplates.Add(model);
                olsEni.SaveChanges();

                return true;
            }
            catch (Exception ex)
            {

                throw;
            }
        }

        public Boolean Edit(ExaminationTaskTemplate model)
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
                ExaminationTaskTemplate model;

                model = olsEni.ExaminationTaskTemplates.SingleOrDefault(m => m.ETT_Id == id);

                if (null == model)
                {
                    resJson.message = "数据不存在！";
                    return resJson;
                }

                model.ETT_Status = (Byte)status;
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