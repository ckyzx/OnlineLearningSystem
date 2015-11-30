using System;
using System.Collections.Generic;
using System.Linq;
using System.Data;
using System.Web;
using System.Web.Mvc;
using OnlineLearningSystem.Models;
using System.Text;

namespace OnlineLearningSystem.Utilities
{
    public class UQuestionClassify : Utility
    {
        public DataTablesResponse ListDataTablesAjax(DataTablesRequest dtRequest)
        {

            DataTablesResponse dtResponse;
            Int32 recordsTotal, recordsFiltered;
            String whereSql, orderColumn;
            List<QuestionClassify> ms;


            dtResponse = new DataTablesResponse();

            dtResponse.draw = dtRequest.Draw;

            recordsTotal = olsEni.QuestionClassifies.Count();
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
                .QuestionClassifies
                .OrderBy(model => model.QC_Id)
                .Where(model =>
                    model.QC_Name.Contains(dtRequest.SearchValue)
                    && model.QC_Status != (Byte)Status.Delete)
                .Select(model => new
                {
                    QC_Id = model.QC_Id,
                    QC_Name = model.QC_Name,
                    QC_Level = model.QC_Level,
                    QC_Remark = model.QC_Remark,
                    QC_AddTime = model.QC_AddTime,
                    QC_Status = model.QC_Status
                })
                .ToList();

            // 获取分类名称
            ms = new List<QuestionClassify>();

            foreach (var model in tmpMs)
            {

                ms.Add(new QuestionClassify()
                {
                    QC_Id = model.QC_Id,
                    QC_Name = model.QC_Name,
                    QC_Level = model.QC_Level,
                    QC_Remark = model.QC_Remark,
                    QC_AddTime = model.QC_AddTime,
                    QC_Status = model.QC_Status
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

        public QuestionClassify GetNew()
        {

            QuestionClassify model;

            model = new QuestionClassify()
            {
                QC_Id = 0,
                QC_Name = "",
                QC_Level = "",
                QC_Remark = "",
                QC_AddTime = DateTime.Now,
                QC_Status = (Byte)Status.Available
            };

            return model;
        }

        public QuestionClassify Get(Int32 id)
        {
            QuestionClassify model;

            model = olsEni.QuestionClassifies.SingleOrDefault(m => m.QC_Id == id);

            if (null == model)
            {
                throw new NotImplementedException();
            }

            return model;
        }

        public Boolean Create(QuestionClassify model)
        {
            try
            {

                Int32 rowCount;
                Int32 id;

                rowCount = olsEni.QuestionClassifies.Count();
                id = 0 == rowCount ? 1 : olsEni.QuestionClassifies.Max(m => m.QC_AutoId) + 1;

                model.QC_Id = id;
                model.QC_Level = String.Format("{0:D4}", id);
                olsEni.QuestionClassifies.Add(model);
                olsEni.SaveChanges();

                return true;
            }
            catch (Exception ex)
            {

                throw;
            }
        }

        public Boolean Edit(QuestionClassify model)
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
                QuestionClassify model;

                model = olsEni.QuestionClassifies.SingleOrDefault(m => m.QC_Id == id);

                if (null == model)
                {
                    resJson.message = "数据不存在！";
                    return resJson;
                }

                model.QC_Status = (Byte)status;
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

        public Boolean DuplicateName(Int32 id, String name)
        {

            try
            {

                Int32 count;

                count = olsEni.QuestionClassifies.Where(m => m.QC_Id != id && m.QC_Name == name).Count();

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

        public String GetZTreeJson()
        {

            List<QuestionClassify> qcs;
            StringBuilder zTreeJson;

            qcs = olsEni.QuestionClassifies.Where(m => m.QC_Status == (Byte)Status.Available).ToList();

            zTreeJson = new StringBuilder();
            zTreeJson.Append("[");

            foreach (var qc in qcs)
            {

                zTreeJson.Append("{");
                zTreeJson.Append(
                    "\"questionClassifyId\":" + qc.QC_Id + ", " +
                    "\"click\":\"location.href='/Question/List?qcId=" + qc.QC_Id + "'\", " + 
                    "\"name\":\"" + qc.QC_Name + "\"");
                zTreeJson.Append("},");
            }

            zTreeJson.Remove(zTreeJson.Length - 1, 1);
            zTreeJson.Append("]");

            return zTreeJson.ToString();
        }
    }
}