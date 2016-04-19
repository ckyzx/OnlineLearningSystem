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

                Int32 id;

                id = GetQCId();

                model.QC_Id = id;
                model.QC_Level = String.Format("{0:D4}", id);
                olsEni.QuestionClassifies.Add(model);
                olsEni.SaveChanges();

                return true;
            }
            catch (Exception ex)
            {
                StaticHelper.RecordSystemLog(ex);
                return false;
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
                QuestionClassify model;

                model = olsEni.QuestionClassifies.SingleOrDefault(m => m.QC_Id == id);

                if (null == model)
                {
                    resJson.message = "数据不存在！";
                    return resJson;
                }

                model.QC_Status = (Byte)status;
                olsEni.Entry(model).State = EntityState.Modified;

                // 批量处理分类所属试题
                // 只处理“回收”或“删除”操作
                setQuestionStatus(id, status);

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

        private void setQuestionStatus(int qcId, Status status)
        {
            List<Question> qs;

            if (status == Status.Recycle || status == Status.Delete)
            {
                qs = olsEni.Questions.Where(m => m.QC_Id == qcId).ToList();
                foreach (var q in qs)
                {
                    if (q.Q_Status != (Byte)status)
                    {
                        q.Q_Status = (Byte)status;
                        DeleteErrorQuestion(q);
                    }
                }
            }
        }

        private void DeleteErrorQuestion(Question q)
        {
            if (q.Q_Type == "判断题" || q.Q_Type == "公文改错题" || q.Q_Type == "计算题" 
                || q.Q_Type == "案例分析题" || q.Q_Type == "问答题")
            {
                return;
            }

            if (q.Q_OptionalAnswer == "" || q.Q_OptionalAnswer == "{}" || q.Q_OptionalAnswer == "[]"
                || q.Q_ModelAnswer == "" || q.Q_ModelAnswer == "{}" || q.Q_ModelAnswer == "[]")
            {
                q.Q_Status = (Byte)Status.Delete;
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
                StaticHelper.RecordSystemLog(ex);
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
                // 当状态为“[未设置]”，显示除“删除”以外分类
                qcs = olsEni.QuestionClassifies.Where(m => m.QC_Status != (Byte)Status.Delete).ToList();
            }
            // 当状态为“缓存”或“回收”，需同时获取“正常”分类
            // 因为“缓存”或“回收”试题的分类可能是“正常”的
            else if (status != (Byte)Status.Delete)
            {
                qcs =
                    olsEni.QuestionClassifies
                    .Where(m =>
                        m.QC_Status == status
                        || m.QC_Status == (Byte)Status.Available)
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

        public ResponseJson GetZTreeResJson(Byte status)
        {

            ResponseJson resJson;

            resJson = new ResponseJson(ResponseStatus.Success, now);
            resJson.data = GetZTreeJson(status);

            return resJson;
        }
    }
}