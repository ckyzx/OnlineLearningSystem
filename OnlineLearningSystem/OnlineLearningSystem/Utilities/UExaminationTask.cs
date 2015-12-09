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
    public class UExaminationTask : Utility
    {
        public DataTablesResponse ListDataTablesAjax(DataTablesRequest dtRequest)
        {

            DataTablesResponse dtResponse;
            Int32 recordsTotal, recordsFiltered;
            String whereSql, orderColumn;
            List<ExaminationTask> ms;
            List<ExaminationPaperTemplate> epts;


            dtResponse = new DataTablesResponse();

            dtResponse.draw = dtRequest.Draw;

            recordsTotal = olsEni.ExaminationTasks.Count();
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
                .ExaminationTasks
                .OrderBy(model => model.ET_Id)
                .Where(model =>
                    model.ET_Name.Contains(dtRequest.SearchValue)
                    && model.ET_Status != (Byte)Status.Delete)
                .ToList();

            foreach (var model in ms)
            {

                epts = olsEni.ExaminationPaperTemplates.Where(m => m.ET_Id == model.ET_Id).ToList();
                if (epts.Count == 1)
                {
                    model.EPT_PaperTemplateStatus = epts[0].EPT_PaperTemplateStatus;
                }
            }

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
                ET_ParticipatingDepartment = "[]",
                ET_Attendee = "[]",
                ET_AutoType = 0,
                ET_StatisticType = 0,
                ET_TotalScore = 100,
                ET_AutoClassifies = "[]",
                ET_AutoNumber = 10,
                ET_AutoRatio = "[]",
                ET_StartTime = initDateTime,
                ET_EndTime = initDateTime.AddDays(7),
                ET_TimeSpan = 0,
                ET_PaperTemplates = "[]",
                ET_Questions = "[]",
                ET_Remark = "",
                ET_AddTime = DateTime.Now,
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

        public Boolean Create(ExaminationTask model)
        {
            try
            {

                Int32 rowCount;
                Int32 id;

                rowCount = olsEni.ExaminationTasks.Count();
                id = 0 == rowCount ? 0 : olsEni.ExaminationTasks.Max(m => m.ET_AutoId);

                model.ET_Id = id + 1;
                olsEni.ExaminationTasks.Add(model);
                olsEni.SaveChanges();

                // 添加试卷模板与试题模板
                AddPaperTemplateAndQuestionTemplate(model);

                return true;
            }
            catch (Exception ex)
            {

                throw;
            }
        }

        private void AddPaperTemplateAndQuestionTemplate(ExaminationTask model)
        {

            DateTime now, etStartTime, eptStartTime, eptEndTime;
            Int32 rowCount;
            Int32 id, tmp;
            ExaminationPaperTemplate ept;
            Int32[] qs;
            Question q;

            now = DateTime.Now;

            rowCount = olsEni.ExaminationPaperTemplates.Count();
            id = 0 == rowCount ? 0 : olsEni.ExaminationPaperTemplates.Max(m => m.EPT_AutoId);

            // 设置考试开始时间
            etStartTime = model.ET_StartTime;
            switch (model.ET_AutoType)
            {
                case 1: // 每日
                    
                    eptStartTime = new DateTime(now.Year, now.Month, now.Day, etStartTime.Hour, etStartTime.Minute, etStartTime.Second);
                    eptEndTime = eptStartTime.AddDays(7); // 过期日设置在7天后
                    break;
                case 2: // 每周
                    
                    eptStartTime = new DateTime(now.Year, now.Month, now.Day, etStartTime.Hour, etStartTime.Minute, etStartTime.Second);
                    eptStartTime = eptStartTime.AddDays(7 - (Int32)eptStartTime.DayOfWeek + model.ET_AutoOffsetDay);
                    eptEndTime = eptStartTime.AddDays(7); // 过期日设置在7天后
                    break;
                case 3: // 每月
                    
                    eptStartTime = new DateTime(now.Year, now.Month, 1, etStartTime.Hour, etStartTime.Minute, etStartTime.Second);
                    eptStartTime.AddMonths(1).AddDays(model.ET_AutoOffsetDay);
                    eptEndTime = eptStartTime.AddDays(7); // 过期日设置在7天后
                    break;
                //case 0: // 手动
                default:

                    eptStartTime = new DateTime(1970, 1, 1);
                    eptEndTime = eptStartTime;
                    break;
            }

            ept = new ExaminationPaperTemplate
            {
                EPT_Id = id + 1,
                ET_Id = model.ET_Id,
                ET_Type = model.ET_Type,
                EPT_StartTime = eptStartTime,
                EPT_EndTime = eptEndTime,
                EPT_TimeSpan = model.ET_TimeSpan,
                EPT_Questions = model.ET_Questions,
                EPT_AddTime = now,
                EPT_Status = (Byte)Status.Available
            };
            olsEni.ExaminationPaperTemplates.Add(ept);
            olsEni.SaveChanges();

            qs = JsonConvert.DeserializeObject<Int32[]>(model.ET_Questions);

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
                        EPT_Id = ept.EPT_Id,
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

        public Boolean Edit(ExaminationTask model)
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
                ExaminationTask model;

                model = olsEni.ExaminationTasks.SingleOrDefault(m => m.ET_Id == id);

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
                resJson.message = StaticHelper.GetExceptionMessage(ex);
                return resJson;
            }
        }

        public ResponseJson StartTask(Int32 id)
        {
            return SetPaperTemplateStatus(id, PaperTemplateStatus.Doing);
        }

        public ResponseJson StopTask(Int32 id)
        {
            return SetPaperTemplateStatus(id, PaperTemplateStatus.Done);
        }

        public ResponseJson SetPaperTemplateStatus(Int32 etId, PaperTemplateStatus ptStatus)
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

                epts = olsEni.ExaminationPaperTemplates.Where(m => m.ET_Id == model.ET_Id).ToList();
                if (epts.Count != 1)
                {
                    resJson.status = ResponseStatus.Error;
                    resJson.message = "试卷模板不匹配。";
                    return resJson;
                }

                epts[0].EPT_PaperTemplateStatus = (Byte)ptStatus;
                olsEni.Entry(epts[0]).State = EntityState.Modified;
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