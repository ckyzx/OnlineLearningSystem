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
    public class UExaminationPaperTemplate : Utility
    {
        public DataTablesResponse ListDataTablesAjax(DataTablesRequest dtRequest, Int32 etId)
        {

            DataTablesResponse dtResponse;
            Int32 recordsTotal, recordsFiltered;
            String whereSql, orderColumn;
            List<ExaminationPaperTemplate> ms;


            dtResponse = new DataTablesResponse();

            dtResponse.draw = dtRequest.Draw;

            recordsTotal = olsEni.ExaminationPaperTemplates.Count();
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
                .ExaminationPaperTemplates
                .OrderBy(model => model.EPT_Id)
                .Where(model =>
                    model.EPT_Status != (Byte)Status.Delete
                    && model.ET_Id == etId)
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

            foreach (var m1 in ms)
            {
                m1.ET_Name = olsEni.ExaminationTasks.Single(m => m.ET_Id == m1.ET_Id).ET_Name;
            }

            dtResponse.data = ms;

            return dtResponse;
        }

        public DataTablesResponse ListDataTablesAjax(DataTablesRequest dtRequest, Int32 uId, Byte type, Byte paperTemplateStatus)
        {

            DataTablesResponse dtResponse;
            Int32 recordsTotal, recordsFiltered;
            String whereSql, orderColumn;
            Object[] modelData;


            dtResponse = new DataTablesResponse();

            dtResponse.draw = dtRequest.Draw;

            recordsTotal = olsEni.ExaminationPaperTemplates.Count();
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

            modelData = GetModels(dtRequest, uId, type, paperTemplateStatus);

            recordsFiltered = (Int32)modelData[0];
            dtResponse.recordsFiltered = recordsFiltered;

            dtResponse.data = (List<ExaminationPaperTemplate>)modelData[1];

            return dtResponse;
        }

        public Object[] GetModels(DataTablesRequest dtRequest, Int32 uId, Byte type, Byte paperTemplateStatus)
        {

            Int32 count;
            Int32[] userIds;
            List<Int32> usableEtIds;
            List<ExaminationTask> ets;
            List<ExaminationPaperTemplate> ms;

            usableEtIds = new List<Int32>();

            ets = olsEni
                .ExaminationTasks
                .Where(m => 
                    m.ET_Status == (Byte)Status.Available)
                .ToList();
            foreach (var et in ets)
            {

                userIds = JsonConvert.DeserializeObject<Int32[]>(et.ET_Attendee);
                if (userIds.Contains(uId))
                {
                    usableEtIds.Add(et.ET_Id);
                }
            }

            count =
                olsEni
                .ExaminationPaperTemplates
                .OrderBy(model => model.EPT_Id)
                .Where(model =>
                    model.EPT_Status != (Byte)Status.Delete
                    && usableEtIds.Contains(model.ET_Id)
                    && model.ET_Type == type
                    && model.EPT_PaperTemplateStatus == paperTemplateStatus)
                .Count();

            ms =
                olsEni
                .ExaminationPaperTemplates
                .OrderBy(model => model.EPT_Id)
                .Where(model =>
                    model.EPT_Status != (Byte)Status.Delete
                    && usableEtIds.Contains(model.ET_Id)
                    && model.ET_Type == type
                    && model.EPT_PaperTemplateStatus == paperTemplateStatus)
                .Skip(dtRequest.Start).Take(dtRequest.Length)
                .ToList();

            foreach (var m1 in ms)
            {
                m1.ET_Name = olsEni.ExaminationTasks.Single(m => m.ET_Id == m1.ET_Id).ET_Name;
            }

            return new Object[] { count, ms };
        }

        public ExaminationPaperTemplate GetNew(Int32 etId)
        {

            ExaminationTask et;
            ExaminationPaperTemplate model;

            et = olsEni.ExaminationTasks.SingleOrDefault(m => m.ET_Id == etId);

            model = new ExaminationPaperTemplate()
            {
                EPT_Id = 0,
                ET_Id = etId,
                ET_Type = et.ET_Type,
                EPT_StartTime = et.ET_StartTime,
                EPT_EndTime = et.ET_EndTime,
                EPT_TimeSpan = et.ET_TimeSpan,
                EPT_Questions = "[]",
                EPT_AddTime = DateTime.Now,
                EPT_Status = (Byte)Status.Available
            };

            return model;
        }

        public ExaminationPaperTemplate Get(Int32 id)
        {
            ExaminationPaperTemplate model;

            model = olsEni.ExaminationPaperTemplates.SingleOrDefault(m => m.EPT_Id == id);

            if (null == model)
            {
                throw new NotImplementedException();
            }

            return model;
        }

        public Boolean Create(ExaminationPaperTemplate model)
        {

            throw new NotImplementedException();

            try
            {

                Int32 rowCount;
                Int32 id;

                rowCount = olsEni.ExaminationPaperTemplates.Count();
                id = 0 == rowCount ? 0 : olsEni.ExaminationPaperTemplates.Max(m => m.EPT_AutoId);

                model.EPT_Id = id + 1;
                olsEni.ExaminationPaperTemplates.Add(model);
                olsEni.SaveChanges();

                AddQuestionTemplate(model);

                return true;
            }
            catch (Exception ex)
            {

                throw;
            }
        }

        private void AddQuestionTemplate(ExaminationPaperTemplate model)
        {

            DateTime now;
            Int32 rowCount;
            Int32 id, tmp;
            Int32[] qs;
            Question q;
            List<ExaminationPaperTemplateQuestion> eptqs;

            now = DateTime.Now;

            // 删除原有试题模板
            eptqs = olsEni.ExaminationPaperTemplateQuestions.Where(m => m.EPT_Id == model.EPT_Id).ToList();

            foreach (var eptq in eptqs)
            {
                olsEni.Entry(eptq).State = EntityState.Deleted;
            }
            olsEni.SaveChanges();

            qs = JsonConvert.DeserializeObject<Int32[]>(model.EPT_Questions);

            // 获取试题模板Id
            rowCount = olsEni.ExaminationPaperTemplateQuestions.Count();
            id = 0 == rowCount ? 0 : olsEni.ExaminationPaperTemplateQuestions.Max(m => m.EPTQ_AutoId);

            for (var i = 0; i < qs.Length; i++)
            {

                tmp = qs[i];
                q = olsEni.Questions.SingleOrDefault(m => m.Q_Id == tmp);

                if (null != q)
                {

                    id += 1;

                    olsEni.ExaminationPaperTemplateQuestions.Add(new ExaminationPaperTemplateQuestion
                    {
                        EPTQ_Id = id,
                        EPT_Id = model.EPT_Id,
                        EPTQ_Type = q.Q_Type,
                        EPTQ_Classify = q.QC_Id,
                        EPTQ_DifficultyCoefficient = q.Q_DifficultyCoefficient,
                        EPTQ_Content = q.Q_Content,
                        EPTQ_OptionalAnswer = q.Q_OptionalAnswer,
                        EPTQ_ModelAnswer = q.Q_ModelAnswer,
                        EPTQ_Remark = q.Q_Remark,
                        EPTQ_AddTime = now,
                        EPTQ_Status = q.Q_Status
                    });
                }
            }
            olsEni.SaveChanges();

        }

        public Boolean Edit(ExaminationPaperTemplate model)
        {

            throw new NotImplementedException();

            try
            {

                // 已过考试开始时间/已经手动开始，不可修改模板
                if (model.EPT_PaperTemplateStatus >= 2)
                {
                    return false;
                }

                olsEni.Entry(model).State = EntityState.Modified;
                olsEni.SaveChanges();

                AddQuestionTemplate(model);

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

            throw new NotImplementedException();

            ResponseJson resJson;

            resJson = new ResponseJson();

            try
            {
                ExaminationPaperTemplate model;

                model = olsEni.ExaminationPaperTemplates.SingleOrDefault(m => m.EPT_Id == id);

                if (null == model)
                {
                    resJson.message = "数据不存在！";
                    return resJson;
                }

                model.EPT_Status = (Byte)status;
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

        // 进入考试
        public ResponseJson EnterExamination(Int32 id, Int32 userId)
        {

            ResponseJson resJson;

            resJson = new ResponseJson();

            try
            {

                Int32 epId;
                ExaminationPaperTemplate ept;
                ExaminationPaper ep;


                ept = Get(id);

                switch (ept.EPT_PaperTemplateStatus)
                {
                    case 0: // 考试未开始

                        resJson.message = "考试未开始。";
                        break;
                    case 1: // 考试进行中

                        ep =
                            olsEni
                            .ExaminationPapers
                            .SingleOrDefault(m =>
                            m.EPT_Id == ept.EPT_Id
                            && m.EP_UserId == userId);

                        // 试卷不存在
                        if (null == ep)
                        {

                            //TODO: 添加试卷
                            epId = olsEni.ExaminationPapers.Count();
                            epId = 0 == epId ? 1 : olsEni.ExaminationPapers.Max(m => m.EP_AutoId) + 1;

                            ep = new ExaminationPaper
                            {
                                EP_Id = epId,
                                EPT_Id = ept.EPT_Id,
                                EP_PaperStatus = (Byte)PaperStatus.Doing,
                                EP_EndTime = ept.EPT_EndTime,
                                EP_TimeSpan = ept.EPT_TimeSpan,
                                EP_UserId = userId,
                                EP_UserName = "",
                                EP_Score = 0,
                                EP_Remark = "",
                                EP_AddTime = now,
                                EP_Status = (Byte)Status.Available
                            };

                            olsEni.Entry(ep).State = EntityState.Added;
                            olsEni.SaveChanges();

                            resJson.status = ResponseStatus.Success;
                            resJson.addition = epId;
                            break;
                        }

                        // 试卷已存在
                        // 考试未结束
                        if (ep.EP_PaperStatus != (Byte)PaperStatus.Done)
                        {
                            resJson.status = ResponseStatus.Success;
                            resJson.addition = ep.EP_Id;
                            break;
                        }

                        // 考试已结束
                        resJson.message = "考试已结束。";

                        break;
                    //case 2:// 考试已结束
                    default:

                        resJson.message = "考试已结束。";
                        break;
                }

                return resJson;
            }
            catch (Exception ex)
            {

                resJson.status = ResponseStatus.Error;
                resJson.message = StaticHelper.GetExceptionMessage(ex);
                return resJson;
            }
        }

        // 终止考试
        public ResponseJson Terminate(Int32 id)
        {

            ResponseJson resJson;

            resJson = new ResponseJson();

            try
            {
                ExaminationPaperTemplate model;
                ExaminationTask et;
                List<ExaminationPaper> eps;

                model = olsEni.ExaminationPaperTemplates.Single(m => m.EPT_Id == id);

                // 终止“手动”试卷模板时，应同时结束任务
                et = olsEni.ExaminationTasks.Single(m => m.ET_Id == model.ET_Id);
                if ((Byte)AutoType.Manual == et.ET_AutoType)
                {
                    et.ET_Enabled = (Byte)ExaminationTaskStatus.Disabled;
                }

                model.EPT_PaperTemplateStatus = (Byte)PaperTemplateStatus.Done;
                olsEni.Entry(model).State = EntityState.Modified;

                eps = olsEni.ExaminationPapers.Where(m => m.EPT_Id == id).ToList();
                foreach (var ep in eps)
                {
                    ep.EP_PaperStatus = (Byte)PaperStatus.Done;
                }

                if (0 == olsEni.SaveChanges())
                {
                    resJson.status = ResponseStatus.Error;
                    resJson.message = ResponseMessage.SaveChangeError;
                    return resJson;
                }

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

        public ResponseJson GetUsers(Int32 id)
        {
            ResponseJson resJson;

            resJson = new ResponseJson(ResponseStatus.Success, now);

            try
            {

                Int32 etId;
                String users;
                Int32[] userAry;
                ExaminationPaperTemplate ept;
                ExaminationTask et;
                User u;
                List<User> userModels;

                userModels = new List<User>();

                ept = Get(id);
                etId = ept.ET_Id;
                et = olsEni.ExaminationTasks.Single(m => m.ET_Id == etId);
                users = et.ET_Attendee;
                userAry = JsonConvert.DeserializeObject<Int32[]>(users);

                foreach (var uId in userAry)
                {
                    u = olsEni.Users.SingleOrDefault(m => m.U_Id == uId);

                    if (null != u)
                    {
                        u.U_Password = "**********";
                        userModels.Add(u);
                    }
                }

                if (userModels.Count == 0)
                {
                    resJson.status = ResponseStatus.Error;
                    resJson.message = "没有参与人员。";
                    return resJson;
                }

                resJson.data = JsonConvert.SerializeObject(userModels);
                return resJson;
            }
            catch (Exception ex)
            {

                resJson.status = ResponseStatus.Error;
                resJson.message = StaticHelper.GetExceptionMessage(ex);
                return resJson;
            }
        }

        public ResponseJson GetQuestions(Int32 id, Int32 uId)
        {

            ResponseJson resJson;

            resJson = new ResponseJson();

            try
            {

                Int32 epId;
                ExaminationPaper ep;
                List<ExaminationPaperQuestion> epqs;
                List<ExaminationPaperTemplateQuestion> eptqs;

                ep = olsEni.ExaminationPapers.SingleOrDefault(m => m.EPT_Id == id && m.EP_UserId == uId);

                if (null == ep)
                {
                    resJson.status = ResponseStatus.Error;
                    resJson.message = "试卷不存在。";
                    return resJson;
                }

                if (ep.EP_PaperStatus != (Byte)PaperStatus.Done)
                {
                    resJson.status = ResponseStatus.Error;
                    resJson.message = "考试未结束。";
                    return resJson;
                }

                epId = ep.EP_Id;

                eptqs =
                    olsEni
                    .ExaminationPaperTemplateQuestions
                    .Where(m => m.EPT_Id == id)
                    .ToList();
                epqs = olsEni.ExaminationPaperQuestions.Where(m => m.EP_Id == epId).ToList();

                resJson.status = ResponseStatus.Success;
                resJson.data = JsonConvert.SerializeObject(new Object[] { eptqs, epqs, epId });
                return resJson;
            }
            catch (Exception ex)
            {
                resJson.status = ResponseStatus.Error;
                resJson.message = StaticHelper.GetExceptionMessage(ex);
                return resJson;
            }
        }

        public ResponseJson Grade(String gradeJson)
        {

            ResponseJson resJson;

            resJson = new ResponseJson();

            try
            {

                Int32 score, exactnessNumber, totalNumber;
                ExaminationTask et;
                ExaminationPaper ep;
                ExaminationPaperTemplate ept;
                ExaminationPaperQuestion epq1;
                List<ExaminationPaper> eps;
                List<ExaminationPaperTemplateQuestion> eptqs;
                List<ExaminationPaperQuestion> epqs;

                eps = new List<ExaminationPaper>();

                epqs = JsonConvert.DeserializeObject<List<ExaminationPaperQuestion>>(gradeJson);

                foreach (var epq in epqs)
                {

                    // 检查是否在考试时间内
                    ep = olsEni.ExaminationPapers.SingleOrDefault(m => m.EP_Id == epq.EP_Id);
                    if (null == ep || ep.EP_PaperStatus != (Byte)PaperStatus.Done)
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

                        epq1.EPQ_Exactness = epq.EPQ_Exactness;
                        olsEni.Entry(epq1).State = EntityState.Modified;

                        if (eps.Where(m => m.EP_Id == ep.EP_Id).Count() == 0)
                        {
                            eps.Add(ep);
                        }
                    }
                }

                epqs = null;

                // 计算成绩
                foreach (var ep1 in eps)
                {

                    ept = olsEni.ExaminationPaperTemplates.SingleOrDefault(m => m.EPT_Id == ep1.EPT_Id);

                    if (null == ept || ept.EPT_PaperTemplateStatus != (Byte)PaperTemplateStatus.Done)
                    {
                        continue;
                    }

                    et = olsEni.ExaminationTasks.SingleOrDefault(m => m.ET_Id == ept.ET_Id);

                    if (null == et)
                    {
                        continue;
                    }

                    score = 0;

                    if (et.ET_StatisticType == (Byte)StatisticType.Score)
                    {
                        // 计算分数

                        epqs = olsEni.ExaminationPaperQuestions.Where(m => m.EP_Id == ep1.EP_Id).ToList();
                        eptqs = olsEni.ExaminationPaperTemplateQuestions.Where(m => m.EPT_Id == ep1.EPT_Id).ToList();

                        foreach (var epq in epqs)
                        {
                            if (epq.EPQ_Exactness == (Byte)AnswerStatus.Exactness)
                            {
                                score += eptqs.Single(m => m.EPTQ_Id == epq.EPTQ_Id).EPTQ_Score;
                            }
                        }

                    }
                    else if (et.ET_StatisticType == (Byte)StatisticType.Number)
                    {
                        // 计算正确率

                        exactnessNumber = olsEni.ExaminationPaperQuestions.Where(m => m.EP_Id == ep1.EP_Id && m.EPQ_Exactness == (Byte)AnswerStatus.Exactness).Count();
                        totalNumber = olsEni.ExaminationPaperTemplateQuestions.Where(m => m.EPT_Id == ep1.EPT_Id).Count();

                        score = (Int32)Math.Round((double)exactnessNumber / (double)totalNumber * 100, MidpointRounding.AwayFromZero);
                    }

                    ep1.EP_Score = score;
                    olsEni.Entry(ep1).State = EntityState.Modified;
                }

                if (0 == olsEni.SaveChanges())
                {

                    resJson.status = ResponseStatus.Error;
                    resJson.message = ResponseMessage.SaveChangeError;
                    return resJson;
                }

                resJson.data = JsonConvert.SerializeObject(eps);
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