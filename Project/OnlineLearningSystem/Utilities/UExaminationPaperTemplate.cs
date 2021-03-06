﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Data;
using System.Web;
using System.Web.Mvc;
using OnlineLearningSystem.Models;
using Newtonsoft.Json;
using System.Data.SqlClient;
using OnlineLearningSystem.ViewModels;

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
            ExaminationTask et;

            // 获取练习模板列表数据
            et = olsEni.ExaminationTasks.Single(m => m.ET_Id == etId);

            if (et.ET_Type == (Byte)ExaminationTaskType.Exercise)
            {
                return ListDataTablesAjaxStudent(etId, dtRequest, (Byte)ExaminationTaskType.Exercise, 2 /* 2:已考完 */);
            }

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
            String orderColumn;
            Object[] modelData;


            dtResponse = new DataTablesResponse();

            dtResponse.draw = dtRequest.Draw;

            recordsTotal = olsEni.ExaminationPaperTemplates.Count();
            dtResponse.recordsTotal = recordsTotal;

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
            ExaminationTask et;
            ExaminationPaper ep;
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
            foreach (var et1 in ets)
            {

                userIds = JsonConvert.DeserializeObject<Int32[]>(et1.ET_Attendee);
                if (userIds.Contains(uId))
                {
                    usableEtIds.Add(et1.ET_Id);
                }
            }

            count =
                olsEni
                .ExaminationPaperTemplates
                .OrderBy(model => model.EPT_Id)
                .Where(model =>
                    model.EPT_Status == (Byte)Status.Available
                    && usableEtIds.Contains(model.ET_Id)
                    && model.ET_Type == type
                    && model.EPT_PaperTemplateStatus == paperTemplateStatus)
                .Count();

            ms =
                olsEni
                .ExaminationPaperTemplates
                .OrderBy(model => model.EPT_Id)
                .Where(model =>
                    model.EPT_Status == (Byte)Status.Available
                    && usableEtIds.Contains(model.ET_Id)
                    && model.ET_Type == type
                    && model.EPT_PaperTemplateStatus == paperTemplateStatus)
                .Skip(dtRequest.Start).Take(dtRequest.Length)
                .ToList();

            foreach (var m1 in ms)
            {

                et = ets.Single(m => m.ET_Id == m1.ET_Id);
                m1.ET_Name = et.ET_Name;
                m1.ET_Type = et.ET_Type;

                // 获取已考试、已评分的试卷成绩
                ep = olsEni.ExaminationPapers.SingleOrDefault(m => m.EPT_Id == m1.EPT_Id && m.EP_UserId == uId);
                if (null == ep)
                {
                    m1.EP_Score = "[未参与]";
                    continue;
                }
                else if (-1 == ep.EP_Score)
                {
                    m1.EP_Score = "[未评分]";
                    m1.EP_PaperStatus = ep.EP_PaperStatus;
                    continue;
                }

                if ((Byte)StatisticType.Score == et.ET_StatisticType)
                {
                    m1.EP_Score = ep.EP_Score + "分";
                }
                else if ((Byte)StatisticType.Number == et.ET_StatisticType)
                {
                    m1.EP_Score = ep.EP_Score + "%";
                }
            }

            return new Object[] { count, ms };
        }

        public DataTablesResponse ListDataTablesAjaxStudent(Int32 etId, DataTablesRequest dtRequest, Byte etType, Byte pageType)
        {

            DataTablesResponse dtResponse;
            UModel<VMExaminationStudentPaperTemplate> umodel;
            List<SqlParameter> sps;

            umodel = new UModel<VMExaminationStudentPaperTemplate>(dtRequest, "ExaminationStudentPaperTemplates", "ESPT_PaperTemplateId");
            sps = new List<SqlParameter>();
            sps.Add(new SqlParameter("@EQ_ESPT_TaskId", etId));
            sps.Add(new SqlParameter("@EQ_ESPT_TaskType", etType));
            sps.Add(new SqlParameter("@EQ_ESPT_PageType", pageType));
            dtResponse = umodel.GetList(sps);

            return dtResponse;
        }

        public DataTablesResponse ListDataTablesAjaxStudent(DataTablesRequest dtRequest, Int32 uId, Byte etType, Byte pageType)
        {

            DataTablesResponse dtResponse;
            UModel<VMExaminationStudentPaperTemplate> umodel;
            List<SqlParameter> sps;

            umodel = new UModel<VMExaminationStudentPaperTemplate>(dtRequest, "ExaminationStudentPaperTemplates", "ESPT_PaperTemplateId");
            sps = new List<SqlParameter>();
            sps.Add(new SqlParameter("@EQ_ESPT_UserId", uId));
            sps.Add(new SqlParameter("@EQ_ESPT_TaskType", etType));
            sps.Add(new SqlParameter("@EQ_ESPT_PageType", pageType));
            dtResponse = umodel.GetList(sps);

            return dtResponse;
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

                Int32 id;

                id = GetEPTId();

                model.EPT_Id = id;
                olsEni.ExaminationPaperTemplates.Add(model);
                olsEni.SaveChanges();

                AddQuestionTemplate(model);

                return true;
            }
            catch (Exception ex)
            {
                StaticHelper.RecordSystemLog(ex);
                return false;
            }
        }

        private void AddQuestionTemplate(ExaminationPaperTemplate model)
        {

            DateTime now;
            Int32 id, tmp;
            Int32[] qs;
            Question q;
            List<ExaminationPaperTemplateQuestion> eptqs;

            now = DateTime.Now;

            // 删除原有试题模板
            eptqs = olsEni.ExaminationPaperTemplateQuestions
                .Where(m =>
                    m.EPT_Id == model.EPT_Id
                    && m.EPTQ_Status == (Byte)Status.Available)
                .ToList();

            foreach (var eptq in eptqs)
            {
                olsEni.Entry(eptq).State = EntityState.Deleted;
            }
            olsEni.SaveChanges();

            qs = JsonConvert.DeserializeObject<Int32[]>(model.EPT_Questions);

            // 获取试题模板Id
            id = GetEPTQId();

            for (var i = 0; i < qs.Length; i++)
            {

                tmp = qs[i];
                q = olsEni.Questions.SingleOrDefault(m => m.Q_Id == tmp);

                if (null != q)
                {

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

                    id += 1;
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
                resJson.message = ex.Message;
                resJson.detail = StaticHelper.GetExceptionMessageAndRecord(ex);
                return resJson;
            }
        }

        /// <summary>
        /// 进入考试
        /// </summary>
        /// <param name="id"></param>
        /// <param name="uId"></param>
        /// <returns></returns>
        public ResponseJson EnterExamination(Int32 id, Int32 uId)
        {

            ResponseJson resJson;

            resJson = new ResponseJson();

            try
            {

                ExaminationTask et;
                ExaminationPaperTemplate ept;
                ExaminationPaper ep;
                ResponseJson addResJson;

                ept = Get(id);
                et = olsEni.ExaminationTasks.Single(m => m.ET_Id == ept.ET_Id);

                // 任务类型非“考试”
                /*if (et.ET_Type != (Byte)ExaminationTaskType.Examination)
                {
                    resJson.message = "此任务类型非“考试”。";
                    return resJson;
                }*/

                switch (ept.EPT_PaperTemplateStatus)
                {
                    case 0: // 任务未开始

                        resJson.message = "任务未开始。";
                        break;
                    case 1: // 任务进行中

                        ep =
                            olsEni
                            .ExaminationPapers
                            .SingleOrDefault(m =>
                                m.EPT_Id == ept.EPT_Id
                                && m.EP_UserId == uId);

                        // 试卷不存在
                        if (null == ep && et.ET_Type == (Byte)ExaminationTaskType.Examination)
                        {
                            addResJson = addExaminationPaper(ept, uId);
                            if (addResJson.status == ResponseStatus.Error)
                            {
                                resJson.message = "试卷不存在。";
                                return addResJson;
                            }

                            resJson.status = ResponseStatus.Success;
                            resJson.addition = addResJson.data;
                            break;
                        }
                        /*else if (null == ep && et.ET_Type == (Byte)ExaminationTaskType.Exercise)
                        {
                            addResJson = addExercisePaper(et, userId);
                            if (addResJson.status == ResponseStatus.Error)
                            {
                                return addResJson;
                            }

                            resJson.status = ResponseStatus.Success;
                            resJson.addition = addResJson.data;
                            break;
                        }*/
                        // 试卷已存在
                        // 任务未结束
                        else if (ep.EP_PaperStatus != (Byte)PaperStatus.Done)
                        {
                            resJson.status = ResponseStatus.Success;
                            resJson.addition = ep.EP_Id;
                            break;
                        }

                        // 任务已结束
                        resJson.message = "任务已结束。";

                        break;
                    //case 2:// 任务已结束
                    default:

                        ep =
                            olsEni
                            .ExaminationPapers
                            .SingleOrDefault(m =>
                            m.EPT_Id == ept.EPT_Id
                            && m.EP_UserId == uId);

                        if (null != ep)
                        {
                            resJson.status = ResponseStatus.Success;
                            resJson.addition = ep.EP_Id;
                            break;
                        }

                        resJson.message = "任务已结束。";
                        break;
                }

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

        public ResponseJson EnterExercise(Int32 etId, Int32 uId)
        {

            ExaminationTask et;
            ExaminationTaskAttendee eta;
            GeneratePaperTemplate generator;
            List<Question> readyQs;
            Int32 eptId;
            ExaminationPaperTemplate ept;

            try
            {

                et = olsEni.ExaminationTasks.SingleOrDefault(m => m.ET_Id == etId);

                if (null == et)
                {
                    return new ResponseJson(ResponseStatus.Error, "任务不存在。");
                }

                if (et.ET_Enabled != (Byte)ExaminationTaskStatus.Enabled)
                {
                    return new ResponseJson(ResponseStatus.Error, "任务已关闭。");
                }

                eta = olsEni.ExaminationTaskAttendees.SingleOrDefault(m => m.ET_Id == et.ET_Id && m.U_Id == uId);

                if (null == eta)
                {
                    return new ResponseJson(ResponseStatus.Error, "您不在此练习的参与人员列表中。");
                }

                generator = new GeneratePaperTemplate(uId);
                readyQs = generator.GenerateWithNumber(et);
                eptId = generator.CreatePaperTemplateOfExercise(et, readyQs);
                ept = Get(eptId);
                ept.EPT_PaperTemplateStatus = (Byte)PaperTemplateStatus.Done;
                SaveChanges();

                return addExaminationPaper(ept, uId);
            }
            catch (Exception ex)
            {
                StaticHelper.RecordSystemLog(ex);
                return new ResponseJson(ResponseStatus.Error, ex.Message);
            }
        }

        private ResponseJson addExaminationPaper(ExaminationPaperTemplate ept, Int32 uId)
        {

            Int32 epId, epqId;
            ExaminationPaper ep;
            ResponseJson resJson;
            List<ExaminationPaperTemplateQuestion> eptqs;

            resJson = new ResponseJson(ResponseStatus.Error, now);

            // 添加试卷
            epId = GetEPId();

            ep = new ExaminationPaper
            {
                EP_Id = epId,
                ET_Id = ept.ET_Id,
                EPT_Id = ept.EPT_Id,
                EP_PaperStatus = (Byte)PaperStatus.Doing,
                EP_EndTime = now.AddMinutes(ept.EPT_TimeSpan), // 进入考试时开始计算考试时间
                EP_TimeSpan = ept.EPT_TimeSpan,
                EP_UserId = uId,
                EP_UserName = "",
                EP_Score = -1,
                EP_Remark = "",
                EP_AddTime = now,
                EP_Status = (Byte)Status.Available
            };

            // 添加试卷试题数据
            eptqs =
                olsEni.ExaminationPaperTemplateQuestions
                .Where(m =>
                    m.EPT_Id == ept.EPT_Id
                    && m.EPTQ_Status == (Byte)Status.Available)
                .ToList();
            epqId = GetEPQId();
            foreach (var eptq in eptqs)
            {
                var epq = new ExaminationPaperQuestion
                {
                    EPQ_Id = epqId,
                    EP_Id = epId,
                    EPTQ_Id = eptq.EPTQ_Id,
                    EPQ_Answer = "",
                    EPQ_Exactness = 0,
                    EPQ_Critique = "",
                    EPQ_AddTime = now
                };
                olsEni.Entry(epq).State = EntityState.Added;
                epqId += 1;
            }

            olsEni.Entry(ep).State = EntityState.Added;
            if (0 == olsEni.SaveChanges())
            {
                resJson.message = ResponseMessage.SaveChangesError;
                return resJson;
            }

            resJson.status = ResponseStatus.Success;
            resJson.data = epId;
            return resJson;
        }

        /// <summary>
        /// 终止考试
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
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

                eps = olsEni.ExaminationPapers
                    .Where(m =>
                        m.EPT_Id == id
                        && m.EP_Status == (Byte)Status.Available)
                    .ToList();
                foreach (var ep in eps)
                {
                    ep.EP_PaperStatus = (Byte)PaperStatus.Done;
                    GradePaper(ep);
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
                ExaminationPaper ep;
                List<User> userModels;

                userModels = new List<User>();

                ept = Get(id);
                etId = ept.ET_Id;
                et = olsEni.ExaminationTasks.Single(m => m.ET_Id == etId);
                users = et.ET_Attendee;
                userAry = JsonConvert.DeserializeObject<Int32[]>(users);

                foreach (var uId in userAry)
                {
                    u = olsEni.Users.SingleOrDefault(m =>
                        m.U_Id == uId
                        && m.U_Status == (Byte)Status.Available);
                    if (null != u)
                    {
                        u.U_Password = "**********";
                        userModels.Add(u);
                    }

                    ep = olsEni.ExaminationPapers.SingleOrDefault(m => m.EPT_Id == id && m.EP_UserId == u.U_Id);
                    if (null == ep)
                    {
                        continue;
                    }

                    u.EP_Id = ep.EP_Id;
                    u.EP_Score = GetScoreString(et.ET_StatisticType, ep.EP_Score);

                }

                if (userModels.Count == 0)
                {
                    resJson.status = ResponseStatus.Error;
                    resJson.message = "没有参与人员。";
                    return resJson;
                }

                resJson.data = JsonConvert.SerializeObject(userModels);
                resJson.addition = et;
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

        private string GetScoreString(Byte statisticType, Int32 score)
        {

            String scoreString;

            if (score == -1)
            {
                scoreString = "";
                return scoreString;
            }

            if (statisticType == (Byte)StatisticType.Score)
            {
                scoreString = score + "分";
            }
            else if (statisticType == (Byte)StatisticType.Number)
            {
                scoreString = score + "%";
            }
            else
            {
                scoreString = "";
            }

            return scoreString;
        }

        /*public ResponseJson GetQuestions(Int32 id, Int32 uId)
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
                    resJson.message = "未考试";
                    return resJson;
                }

                if (ep.EP_PaperStatus != (Byte)PaperStatus.Done)
                {
                    resJson.status = ResponseStatus.Error;
                    resJson.message = "考试未结束";
                    return resJson;
                }

                epId = ep.EP_Id;

                eptqs =
                    olsEni
                    .ExaminationPaperTemplateQuestions
                    .Where(m => 
                        m.EPT_Id == id
                        && m.EPTQ_Status == (Byte)Status.Available)
                    .ToList();
                epqs = olsEni.ExaminationPaperQuestions.Where(m => m.EP_Id == epId).ToList();

                resJson.status = ResponseStatus.Success;
                resJson.data = JsonConvert.SerializeObject(new Object[] { eptqs, epqs, epId });
                return resJson;
            }
            catch (Exception ex)
            {
                resJson.status = ResponseStatus.Error;
                resJson.message = ex.Message;
                resJson.detail = StaticHelper.GetExceptionMessageAndRecord(ex);
                return resJson;
            }
        }*/

        public ResponseJson GetQuestions(Int32 id, Int32 epId, Int32 uId)
        {

            ResponseJson resJson;

            resJson = new ResponseJson();

            try
            {

                ExaminationPaper ep;
                List<ExaminationPaperQuestion> epqs;
                List<ExaminationPaperTemplateQuestion> eptqs;
                ExaminationPaperTemplate ept;
                ExaminationTask et;

                ep = olsEni.ExaminationPapers.SingleOrDefault(m => m.EP_Id == epId && m.EP_UserId == uId);

                if (null == ep)
                {
                    resJson.status = ResponseStatus.Error;
                    resJson.message = "未考试";
                    return resJson;
                }

                if (ep.EP_PaperStatus != (Byte)PaperStatus.Done)
                {
                    resJson.status = ResponseStatus.Error;
                    resJson.message = "考试未结束";
                    return resJson;
                }

                eptqs =
                    olsEni
                    .ExaminationPaperTemplateQuestions
                    .Where(m =>
                        m.EPT_Id == id
                        && m.EPTQ_Status == (Byte)Status.Available)
                    .ToList();
                epqs = olsEni.ExaminationPaperQuestions.Where(m => m.EP_Id == epId).ToList();

                ept = olsEni.ExaminationPaperTemplates.Single(m => m.EPT_Id == id);
                et = olsEni.ExaminationTasks.Single(m => m.ET_Id == ept.ET_Id);

                resJson.status = ResponseStatus.Success;
                resJson.data = JsonConvert.SerializeObject(new Object[] { eptqs, epqs, epId });
                resJson.addition = et;
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
                        epqs =
                            olsEni.ExaminationPaperQuestions
                            .Where(m => m.EP_Id == ep1.EP_Id).ToList();
                        eptqs =
                            olsEni.ExaminationPaperTemplateQuestions
                            .Where(m =>
                                m.EPT_Id == ep1.EPT_Id
                                && m.EPTQ_Status == (Byte)Status.Available)
                            .ToList();

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
                        epqs =
                            olsEni.ExaminationPaperQuestions
                            .Where(m => m.EP_Id == ep1.EP_Id).ToList();
                        exactnessNumber = 0;
                        totalNumber =
                            olsEni.ExaminationPaperTemplateQuestions
                            .Where(m =>
                                m.EPT_Id == ep1.EPT_Id
                                && m.EPTQ_Status == (Byte)Status.Available)
                            .Count();

                        foreach (var epq in epqs)
                        {
                            if (epq.EPQ_Exactness == (Byte)AnswerStatus.Exactness)
                            {
                                exactnessNumber += 1;
                            }
                        }

                        score = (Int32)Math.Round((double)exactnessNumber / (double)totalNumber * 100, MidpointRounding.AwayFromZero);
                    }

                    ep1.EP_Score = score;
                    olsEni.Entry(ep1).State = EntityState.Modified;
                }

                if (0 == olsEni.SaveChanges())
                {

                    resJson.status = ResponseStatus.Error;
                    resJson.message = ResponseMessage.SaveChangesError;
                    return resJson;
                }

                resJson.data = JsonConvert.SerializeObject(eps);
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

        /// <summary>
        /// 计算成绩
        /// </summary>
        /// <param name="ep"></param>
        public String GradePaper(ExaminationPaper ep)
        {

            Int32 score, number, eptqCount;
            Double ratio;
            ExaminationPaperTemplateQuestion eptq;
            ExaminationTask et;
            List<ExaminationPaperQuestion> epqs;
            String scoreString;

            score = 0;
            number = 0;
            scoreString = "";

            epqs = olsEni.ExaminationPaperQuestions.Where(m => m.EP_Id == ep.EP_Id).ToList();
            foreach (var epq in epqs)
            {

                eptq = olsEni.ExaminationPaperTemplateQuestions.Single(m => m.EPTQ_Id == epq.EPTQ_Id);
                switch (eptq.EPTQ_Type)
                {
                    case "单选题":
                    case "多选题":
                    case "判断题":

                        if (eptq.EPTQ_ModelAnswer == epq.EPQ_Answer)
                        {
                            epq.EPQ_Exactness = (Byte)AnswerStatus.Exactness;
                            score += eptq.EPTQ_Score;
                            number += 1;
                        }
                        else
                        {
                            epq.EPQ_Exactness = (Byte)AnswerStatus.Wrong;
                        }
                        break;
                    default:
                        break;
                }
            }

            // 如果试题只有单选题、多选题、判断题，则自动设置分数
            eptqCount =
                olsEni
                .ExaminationPaperTemplateQuestions
                .Where(m =>
                    m.EPT_Id == ep.EPT_Id
                    && m.EPTQ_Type != "单选题"
                    && m.EPTQ_Type != "多选题"
                    && m.EPTQ_Type != "判断题"
                    && m.EPTQ_Status == (Byte)Status.Available)
                .Count();
            et = olsEni.ExaminationTasks.Single(m => m.ET_Id == ep.ET_Id);

            if ((Byte)StatisticType.Score == et.ET_StatisticType && eptqCount == 0)
            {
                ep.EP_Score = score;
                olsEni.Entry(ep).State = EntityState.Modified;
                scoreString = score + "分";
            }
            else if ((Byte)StatisticType.Number == et.ET_StatisticType && eptqCount == 0)
            {
                ratio = Math.Round((Double)number / (Double)et.ET_TotalNumber, 2, MidpointRounding.AwayFromZero);
                ep.EP_Score = (Int32)(ratio * 100);
                olsEni.Entry(ep).State = EntityState.Modified;
                scoreString = score + "%";
            }

            return scoreString;
        }

        public Boolean SaveChanges()
        {

            if (0 == olsEni.SaveChanges())
            {
                return false;
            }

            return true;
        }
    }
}