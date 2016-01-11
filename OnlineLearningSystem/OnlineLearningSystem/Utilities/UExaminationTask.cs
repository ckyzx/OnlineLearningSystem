﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Data;
using System.Web;
using System.Web.Mvc;
using OnlineLearningSystem.Models;
using Newtonsoft.Json;

namespace OnlineLearningSystem.Utilities
{
    public class UExaminationTask : Utility
    {
        public DataTablesResponse ListDataTablesAjax(DataTablesRequest dtRequest)
        {

            DataTablesResponse dtResponse;
            UModel<ExaminationTask> umodel;

            umodel = new UModel<ExaminationTask>(dtRequest, "ExaminationTasks", "ET_Id");
            dtResponse = umodel.GetList("ET_Status");

            return dtResponse;
        }

        public List<SelectListItem> GetTemplateList()
        {

            List<SelectListItem> list;

            var items =
                olsEni.
                ExaminationTaskTemplates.
                Where(m => m.ETT_Status == (Byte)Status.Available)
                .ToList();

            list = new List<SelectListItem>();
            list.Add(new SelectListItem() { Text = "[未设置]", Value = "", Selected = true });

            foreach (var i in items)
            {
                list.Add(new SelectListItem
                {
                    Text = i.ETT_Name,
                    Value = JsonConvert.SerializeObject(i)
                });
            }

            return list;
        }

        public ExaminationTask GetNew()
        {

            DateTime initDateTime;
            ExaminationTask model;

            initDateTime = new DateTime(1970, 1, 1);

            model = new ExaminationTask()
            {
                ET_Id = 0,
                ET_Name = "",
                ET_Enabled = (Byte)ExaminationTaskStatus.Disabled,
                ET_Type = (Byte)ExaminationTaskType.Examination,
                ET_ParticipatingDepartment = "[]",
                ET_Attendee = "[]",
                ET_StatisticType = (Byte)StatisticType.Unset,
                ET_TotalScore = 100,
                ET_TotalNumber = 10,
                ET_Mode = (Byte)ExaminationTaskMode.Manual,
                ET_AutoType = (Byte)AutoType.Manual,
                ET_AutoOffsetDay = 0,
                ET_DifficultyCoefficient = 0, 
                ET_AutoClassifies = "[]",
                ET_AutoRatio = "[]",
                ET_StartTime = initDateTime,
                ET_EndTime = initDateTime,
                ET_TimeSpan = 0,
                ET_PaperTemplates = "[]",
                ET_Questions = "[]",
                ET_Remark = "",
                ET_AddTime = now,
                ET_Status = (Byte)Status.Available
            };

            return model;
        }

        public ExaminationTask Get(Int32 id)
        {
            ExaminationTask model;

            model = olsEni.ExaminationTasks.SingleOrDefault(m => m.ET_Id == id);

            if (null == model)
            {
                throw new NotImplementedException();
            }

            return model;
        }

        public ResponseJson Create(ExaminationTask model)
        {

            ResponseJson resJson;

            resJson = new ResponseJson(ResponseStatus.Success, now);

            try
            {

                Int32 id;

                id = GetId();

                model.ET_Id = id;
                olsEni.ExaminationTasks.Add(model);
                olsEni.SaveChanges();

                // 添加参与人员
                AddAttendees(model);

                // 添加试卷模板与试题模板
                AddPaperTemplateAndQuestionTemplate(model);

                return resJson;
            }
            catch (Exception ex)
            {
                resJson.status = ResponseStatus.Error;
                resJson.message = StaticHelper.GetExceptionMessageAndRecord(ex);
                return resJson;
            }
        }

        public Int32 GetId()
        {

            Int32 id;

            id = olsEni.ExaminationTasks.Count();
            id = 0 == id ? 1 : olsEni.ExaminationTasks.Max(m => m.ET_AutoId) + 1;

            return id;
        }

        public Int32 GetEPTId()
        {

            Int32 id;

            id = olsEni.ExaminationPaperTemplates.Count();
            id = 0 == id ? 1 : olsEni.ExaminationPaperTemplates.Max(m => m.EPT_AutoId) + 1;

            return id;
        }

        private Int32 GetEPTQId()
        {

            Int32 id;

            id = olsEni.ExaminationPaperTemplateQuestions.Count();
            id = 0 == id ? 1 : olsEni.ExaminationPaperTemplateQuestions.Max(m => m.EPTQ_AutoId) + 1;

            return id;
        }

        private void AddPaperTemplateAndQuestionTemplate(ExaminationTask model)
        {

            Int32 id, tmpId;
            Question q;
            ExaminationPaperTemplate ept;
            ExaminationPaperTemplateQuestion eptq;
            List<ExaminationPaperTemplateQuestion> eptqs;
            Int32[] qs;

            if ((Byte)AutoType.Manual != model.ET_AutoType)
            {
                return;
            }

            id = GetEPTId();

            ept = new ExaminationPaperTemplate
            {
                EPT_Id = id,
                ET_Id = model.ET_Id,
                ET_Type = model.ET_Type,
                EPT_StartDate = now.Date,
                EPT_StartTime = now,
                EPT_EndTime = now.AddMinutes(model.ET_TimeSpan),
                EPT_TimeSpan = model.ET_TimeSpan,
                EPT_Questions = model.ET_Questions,
                EPT_AddTime = now,
                EPT_Status = (Byte)Status.Available
            };
            olsEni.ExaminationPaperTemplates.Add(ept);

            qs = JsonConvert.DeserializeObject<Int32[]>(model.ET_Questions);
            eptqs = new List<ExaminationPaperTemplateQuestion>();

            // 获取试题模板Id
            id = GetEPTQId();

            for (var i = 0; i < qs.Length; i++)
            {

                tmpId = qs[i];
                q = olsEni.Questions.SingleOrDefault(m => m.Q_Id == tmpId);

                if (null != q)
                {

                    eptq = new ExaminationPaperTemplateQuestion
                    {
                        EPTQ_Id = id,
                        EPT_Id = ept.EPT_Id,
                        EPTQ_Type = q.Q_Type,
                        EPTQ_Classify = q.QC_Id,
                        EPTQ_DifficultyCoefficient = q.Q_DifficultyCoefficient,
                        EPTQ_Score = q.Q_Score,
                        EPTQ_Content = q.Q_Content,
                        EPTQ_OptionalAnswer = q.Q_OptionalAnswer,
                        EPTQ_ModelAnswer = q.Q_ModelAnswer,
                        EPTQ_Remark = q.Q_Remark,
                        EPTQ_AddTime = now,
                        EPTQ_Status = q.Q_Status
                    };

                    eptqs.Add(eptq);

                    id += 1;
                }
            }

            eptqs = AdjustScore(eptqs, model.ET_StatisticType, model.ET_TotalScore);

            if (0 == olsEni.SaveChanges())
            {
                throw new Exception(ResponseMessage.SaveChangesError);
            }

            foreach (var eptq1 in eptqs)
            {
                olsEni.Entry(eptq1).State = EntityState.Added;
            }

            if (0 == olsEni.SaveChanges())
            {
                throw new Exception(ResponseMessage.SaveChangesError);
            }

        }

        private List<ExaminationPaperTemplateQuestion> AdjustScore(List<ExaminationPaperTemplateQuestion> eptqs, Byte statisticType, Int32 totalScore)
        {

            Int32 selectedScore, eptqScore, remainder;
            Double ratio;

            if (statisticType != (Byte)StatisticType.Score)
            {
                return eptqs;
            }

            // 选题数量必须 > 总分的1/10、<= 总分
            if (eptqs.Count < totalScore / 10 || eptqs.Count > totalScore)
            {
                throw new Exception("选题总数不合理。");
            }

            selectedScore = eptqs.Sum(m => m.EPTQ_Score);

            foreach (var eptq in eptqs)
            {

                eptqScore = eptq.EPTQ_Score;
                ratio = Math.Round((Double)eptqScore / (Double)selectedScore, 2, MidpointRounding.AwayFromZero);
                eptq.EPTQ_Score = (Int32)(ratio * totalScore);
            }

            // 调整分数（去除溢出/补足空缺）
            selectedScore = eptqs.Sum(m => m.EPTQ_Score);
            if (selectedScore > totalScore)
            {
                remainder = selectedScore - totalScore;
                while (remainder > 0)
                {
                    foreach (var eptq in eptqs)
                    {
                        eptq.EPTQ_Score -= 1;
                        remainder -= 1;
                        if (0 == remainder)
                        {
                            break;
                        }
                    }
                }
            }
            else if (selectedScore < totalScore)
            {
                remainder = selectedScore - totalScore;
                while (remainder < 0)
                {
                    foreach (var eptq in eptqs)
                    {
                        eptq.EPTQ_Score += 1;
                        remainder += 1;
                        if (0 == remainder)
                        {
                            break;
                        }
                    }
                }
            }

            return eptqs;
        }

        private void AddAttendees(ExaminationTask model)
        {

            User_Department ud;
            ExaminationTaskAttendee eta;
            Int32[] uIds;
            List<ExaminationTaskAttendee> etas;

            etas = olsEni.ExaminationTaskAttendees.Where(m => m.ET_Id == model.ET_Id).ToList();
            foreach (var eta1 in etas)
            {
                olsEni.Entry(eta1).State = EntityState.Deleted;
            }
            olsEni.SaveChanges();

            etas = new List<ExaminationTaskAttendee>();

            uIds = JsonConvert.DeserializeObject<Int32[]>(model.ET_Attendee);
            foreach (var uId in uIds)
            {

                ud = olsEni.User_Department.SingleOrDefault(m => m.U_Id == uId);
                if (null == ud)
                {
                    continue;
                }

                eta = new ExaminationTaskAttendee
                {
                    ET_Id = model.ET_Id,
                    U_Id = uId,
                    D_Id = ud.D_Id
                };

                if (etas.Where(m => m.U_Id == uId).Count() == 0)
                {
                    etas.Add(eta);
                    olsEni.Entry(eta).State = EntityState.Added;
                }
            }
            olsEni.SaveChanges();
        }

        public Boolean Edit(ExaminationTask model)
        {
            try
            {

                ExaminationTask et;

                et = olsEni.ExaminationTasks.SingleOrDefault(m => m.ET_Id == model.ET_Id);
                // 已开始/已结束的手动任务不允许编辑；已开始的自动任务不允许编辑
                if ((et.ET_AutoType == 0 && et.ET_Enabled != 0) || (et.ET_AutoType > 0 && et.ET_Enabled == 1))
                {
                    return false;
                }
                olsEni.Entry(et).State = EntityState.Detached;
                olsEni.Entry(model).State = EntityState.Modified;
                olsEni.SaveChanges();

                // 添加参与人员
                AddAttendees(model);

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
                ExaminationTask model;

                model = olsEni.ExaminationTasks.SingleOrDefault(m => m.ET_Id == id);
                // 已开始/已结束的手动任务不允许编辑；已开始的自动任务不允许编辑
                if ((model.ET_AutoType == 0 && model.ET_Enabled != 0) || (model.ET_AutoType > 0 && model.ET_Enabled == 1))
                {
                    resJson.message = "不允许编辑。";
                    return resJson;
                }

                if (null == model)
                {
                    resJson.message = "数据不存在！";
                    return resJson;
                }

                model.ET_Status = (Byte)status;
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

        public ResponseJson StartTask(Int32 id)
        {
            return SetExaminationTaskStatus(id, ExaminationTaskStatus.Enabled);
        }

        public ResponseJson StopTask(Int32 id)
        {
            return SetExaminationTaskStatus(id, ExaminationTaskStatus.Disabled);
        }

        public ResponseJson SetExaminationTaskStatus(Int32 etId, ExaminationTaskStatus etStatus)
        {

            ResponseJson resJson;

            resJson = new ResponseJson();

            try
            {
                ExaminationTask model;
                List<ExaminationPaperTemplate> epts;

                model = olsEni.ExaminationTasks.SingleOrDefault(m => m.ET_Id == etId);

                if (null == model)
                {
                    resJson.message = "数据不存在！";
                    return resJson;
                }

                // 手动任务处理
                if ((Byte)AutoType.Manual == model.ET_AutoType)
                {

                    epts =
                        olsEni
                        .ExaminationPaperTemplates
                        .Where(m => m.ET_Id == model.ET_Id)
                        .ToList();
                    if (epts.Count != 1)
                    {
                        resJson.status = ResponseStatus.Error;
                        resJson.message = "试卷模板不匹配。";
                        return resJson;
                    }

                    epts[0].EPT_PaperTemplateStatus = (Byte)etStatus;
                    // 开始任务及试卷模板
                    if (ExaminationTaskStatus.Enabled == etStatus)
                    {
                        epts[0].EPT_StartTime = now;
                        epts[0].EPT_StartDate = now.Date;
                        epts[0].EPT_EndTime = now.AddMinutes(epts[0].EPT_TimeSpan);
                    }
                    // 终止任务及试卷模板
                    else if (ExaminationTaskStatus.Disabled == etStatus
                        && epts[0].EPT_TimeSpan == 0)
                    {
                        epts[0].EPT_EndTime = DateTime.Now;
                    }
                    olsEni.Entry(epts[0]).State = EntityState.Modified;
                }
                else
                {

                    // 终止自动任务时，同时终止进行中的试卷模板。
                    if (ExaminationTaskStatus.Disabled == etStatus)
                    {
                        epts =
                            olsEni
                            .ExaminationPaperTemplates
                            .Where(m =>
                                m.ET_Id == etId
                                && m.EPT_PaperTemplateStatus == (Byte)PaperTemplateStatus.Doing)
                            .ToList();

                        foreach (var ept in epts)
                        {
                            ept.EPT_PaperTemplateStatus = (Byte)PaperTemplateStatus.Done;
                        }
                    }
                }

                model.ET_Enabled = (Byte)etStatus;
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
                resJson.message = StaticHelper.GetExceptionMessageAndRecord(ex);
                return resJson;
            }
        }

        public Boolean DuplicateName(Int32 etId, String name)
        {
            try
            {

                Int32 count;

                count = olsEni.ExaminationTasks.Where(m => m.ET_Id != etId && m.ET_Name == name).Count();

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