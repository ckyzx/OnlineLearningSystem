using System;
using System.Collections.Generic;
using System.Linq;
using System.Data;
using System.Web;
using System.Web.Mvc;
using OnlineLearningSystem.Models;
using Newtonsoft.Json;

namespace OnlineLearningSystem.Utilities
{
    public class UExaminationPaper : Utility
    {
        public DataTablesResponse ListDataTablesAjax(DataTablesRequest dtRequest)
        {

            DataTablesResponse dtResponse;
            Int32 recordsTotal, recordsFiltered;
            String whereSql, orderColumn;
            List<ExaminationPaper> ms;


            dtResponse = new DataTablesResponse();

            dtResponse.draw = dtRequest.Draw;

            recordsTotal = olsEni.ExaminationPapers.Count();
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

            ms =
                olsEni
                .ExaminationPapers
                .OrderBy(model => model.EP_Id)
                .Where(model =>
                    model.EP_UserName.Contains(dtRequest.SearchValue)
                    && model.EP_Status != (Byte)Status.Delete)
                .ToList();

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

        public ExaminationPaper GetNew(Int32 userId)
        {

            ExaminationPaper model;
            User u;

            u = olsEni.Users.Single(m => 
                m.U_Id == userId 
                && m.U_Status == (Byte)Status.Available);

            model = new ExaminationPaper()
            {
                EP_Id = 0,
                EP_UserId = userId,
                EP_UserName = u.U_Name,
                EP_Remark = "",
                EP_AddTime = DateTime.Now,
                EP_Status = (Byte)Status.Available
            };

            return model;
        }

        public ExaminationPaper Get(Int32 id)
        {
            ExaminationPaper model;

            model = olsEni.ExaminationPapers.SingleOrDefault(m => m.EP_Id == id);

            if (null == model)
            {
                throw new NotImplementedException();
            }

            return model;
        }

        public Boolean Create(ExaminationPaper model)
        {
            try
            {

                Int32 id;

                id = GetEPId();

                model.EP_Id = id;
                olsEni.ExaminationPapers.Add(model);
                olsEni.SaveChanges();

                return true;
            }
            catch (Exception ex)
            {
                StaticHelper.RecordSystemLog(ex);
                return false;
            }
        }

        public Boolean Edit(ExaminationPaper model)
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
                ExaminationPaper model;

                model = olsEni.ExaminationPapers.SingleOrDefault(m => m.EP_Id == id);

                if (null == model)
                {
                    resJson.message = "数据不存在！";
                    return resJson;
                }

                model.EP_Status = (Byte)status;
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

        public ResponseJson GetQuestions(Int32 epId, Int32 uId, Boolean hasModelAnswer = false)
        {

            ResponseJson resJson;

            resJson = new ResponseJson();

            try
            {

                ExaminationPaper ep;
                Int32 eptId;
                List<ExaminationPaperQuestion> epqs;
                List<ExaminationPaperTemplateQuestion> eptqs;

                ep = olsEni.ExaminationPapers.SingleOrDefault(m => m.EP_Id == epId && m.EP_UserId == uId);

                if (null == ep)
                {
                    resJson.status = ResponseStatus.Error;
                    resJson.message = "试卷不存在。";
                    return resJson;
                }

                if (ep.EP_PaperStatus == (Byte)PaperStatus.Done)
                {
                    resJson.status = ResponseStatus.Error;
                    resJson.message = "考试已结束。";
                    return resJson;
                }

                eptId = ep.EPT_Id;

                eptqs =
                    olsEni
                    .ExaminationPaperTemplateQuestions
                    .Where(m => m.EPT_Id == eptId)
                    .ToList();
                epqs = olsEni.ExaminationPaperQuestions.Where(m => m.EP_Id == epId).ToList();

                // 清除标准答案
                if (!hasModelAnswer)
                {
                    foreach (var eptq in eptqs)
                    {
                        eptq.EPTQ_ModelAnswer = null;
                    }
                }

                resJson.status = ResponseStatus.Success;
                resJson.data = JsonConvert.SerializeObject(new Object[] { eptqs, epqs });
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

        public ResponseJson SubmitAnswers(String answersJson)
        {

            ResponseJson resJson;

            resJson = new ResponseJson();

            try
            {

                Int32 epqId;
                ExaminationPaperQuestion epq1;
                ExaminationPaper ep;
                List<ExaminationPaperQuestion> epqs;

                epqs = JsonConvert.DeserializeObject<List<ExaminationPaperQuestion>>(answersJson);

                epqId = GetEPQId();

                foreach (var epq in epqs)
                {

                    // 检查是否在考试时间内
                    ep = olsEni.ExaminationPapers.SingleOrDefault(m => m.EP_Id == epq.EP_Id);
                    if (null != ep && ep.EP_PaperStatus != (Byte)PaperStatus.Doing)
                    {
                        continue;
                    }

                    epq1 =
                        olsEni
                        .ExaminationPaperQuestions
                        .SingleOrDefault(m =>
                            m.EP_Id == epq.EP_Id
                            && m.EPTQ_Id == epq.EPTQ_Id);

                    if (null != epq1)
                    {

                        epq1.EPQ_Answer = epq.EPQ_Answer;
                        olsEni.Entry(epq1).State = EntityState.Modified;
                    }
                    else
                    {

                        epq.EPQ_Id = epqId;
                        epq.EPQ_AddTime = now;
                        epq.EPQ_Exactness = (Byte)AnswerStatus.Unset;
                        epq.EPQ_Critique = null;
                        olsEni.Entry(epq).State = EntityState.Added;

                        epqId += 1;
                    }
                }

                if (0 == olsEni.SaveChanges())
                {

                    resJson.status = ResponseStatus.Error;
                    resJson.message = ResponseMessage.SaveChangesError;
                    return resJson;
                }

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
    }
}