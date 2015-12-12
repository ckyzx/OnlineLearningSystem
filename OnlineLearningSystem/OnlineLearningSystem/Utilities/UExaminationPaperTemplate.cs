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

            var tmpMs =
                olsEni
                .ExaminationPaperTemplates
                .OrderBy(model => model.EPT_Id)
                .Where(model =>
                    model.EPT_Status != (Byte)Status.Delete
                    && model.ET_Id == etId)
                .Select(model => new
                {
                    EPT_Id = model.EPT_Id,
                    EPT_StartTime = model.EPT_StartTime,
                    EPT_TimeSpan = model.EPT_TimeSpan,
                    EPT_Remark = model.EPT_Remark,
                    EPT_AddTime = model.EPT_AddTime,
                    EPT_Status = model.EPT_Status
                })
                .ToList();

            // 获取分类名称
            ms = new List<ExaminationPaperTemplate>();

            foreach (var model in tmpMs)
            {

                ms.Add(new ExaminationPaperTemplate()
                {
                    EPT_Id = model.EPT_Id,
                    EPT_StartTime = model.EPT_StartTime,
                    EPT_TimeSpan = model.EPT_TimeSpan,
                    EPT_Remark = model.EPT_Remark,
                    EPT_AddTime = model.EPT_AddTime,
                    EPT_Status = model.EPT_Status
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

        public DataTablesResponse ListDataTablesAjax(DataTablesRequest dtRequest, Byte type, Byte paperTemplateStatus)
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
                    && model.ET_Type == type
                    && model.EPT_PaperTemplateStatus == paperTemplateStatus)
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
                        if (ep.EP_PaperStatus == 0)
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
    }
}