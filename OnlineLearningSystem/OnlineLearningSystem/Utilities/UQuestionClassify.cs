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
            UModel<QuestionClassify> umodel;

            umodel = new UModel<QuestionClassify>(dtRequest, "QuestionClassifies", "QC_Id");
            dtResponse = umodel.GetList("QC_Status");

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

        public String GetZTreeJson(Status status)
        {
            return GetZTreeJson((Byte)status);
        }

        public String GetZTreeJson(Byte status)
        {

            List<QuestionClassify> qcs;
            StringBuilder zTreeJson;

            if (status == (Byte)Status.Unset)
            {
                qcs = olsEni
                    .QuestionClassifies
                    .Where(m => 
                        m.QC_Status != (Byte)Status.Recycle 
                        && m.QC_Status != (Byte)Status.Delete)
                    .ToList();
            }
            else
            {
                qcs = olsEni.QuestionClassifies.Where(m => m.QC_Status == status).ToList();
            }

            zTreeJson = new StringBuilder();
            zTreeJson.Append("[");

            foreach (var qc in qcs)
            {

                zTreeJson.Append("{");
                zTreeJson.Append(
                    "\"questionClassifyId\":" + qc.QC_Id + ", " +
                    "\"name\":\"" + qc.QC_Name + "\"");
                zTreeJson.Append("},");
            }

            if (zTreeJson.Length > 1)
            {
                zTreeJson.Remove(zTreeJson.Length - 1, 1);
            }
            zTreeJson.Append("]");

            return zTreeJson.ToString();
        }
    }
}