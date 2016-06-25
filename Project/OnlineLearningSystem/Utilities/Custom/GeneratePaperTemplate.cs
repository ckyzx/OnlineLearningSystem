using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using OnlineLearningSystem.Models;
using Newtonsoft.Json;
using System.Data;

namespace OnlineLearningSystem.Utilities
{
    public class GeneratePaperTemplate : Utility
    {

        private Int32 totalTimeout = 1000; // 选题时，超过重复次数，则选题失败

        public ResponseJson Generate()
        {

            ResponseJson resJson;

            resJson = new ResponseJson(ResponseStatus.Success, now);

            try
            {

                Int32 success;
                String tmpMessage;
                List<ExaminationTask> ets;
                List<Question> readyQs;

                success = 0;

                ets =
                    olsEni
                    .ExaminationTasks
                    .Where(m =>
                        m.ET_Mode == (Byte)ExaminationTaskMode.Auto
                        && m.ET_Enabled == (Byte)ExaminationTaskStatus.Enabled
                        && m.ET_Status == (Byte)Status.Available)
                    .ToList();

                foreach (var et in ets)
                {


                    if (!WhetherGenerate(et))
                    {
                        resJson.message += et.ET_Name + "：未执行。\r\n";
                        continue;
                    }

                    try
                    {

                        readyQs = Generate(et);
                        if (CreatePaperTemplate(et, readyQs))
                        {
                            success += 1;
                        }
                    }
                    catch (Exception ex)
                    {
                        // 生成试卷模板的过程中发生异常，将考试任务状态设为“关闭”
                        et.ET_Enabled = (Byte)ExaminationTaskStatus.Disabled;

                        resJson.status = ResponseStatus.Error;
                        tmpMessage = et.ET_Name + "：" + ex.Message + "\\r\\n";

                        if (ex.Data != null && ex.Data["Info"] != null)
                        {
                            tmpMessage += "\\r\\n" + ex.Data["Info"];
                        }

                        et.ET_ErrorMessage = ex.Message;
                        if (et.ET_ErrorMessage.Length > 1000)
                        {
                            et.ET_ErrorMessage = et.ET_ErrorMessage.Substring(0, 1000);
                        }

                        if (0 == olsEni.SaveChanges())
                        {
                            tmpMessage += ResponseMessage.SaveChangesError + "\\r\\n";
                        }

                        resJson.message += tmpMessage;

                        StaticHelper.RecordSystemLog(SystemLogType.Exception, ex.Message, tmpMessage);
                    }

                }

                resJson.addition = "成功处理 " + success + "个考试任务。";
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
        /// 判断是否需要生成试卷模板
        /// </summary>
        /// <param name="et"></param>
        /// <returns></returns>
        private Boolean WhetherGenerate(ExaminationTask et)
        {

            Int32 eptCount, dayOfWeek, dayOfMonth;
            Boolean whether;
            DateTime startTime;

            whether = true;

            startTime = et.ET_StartTime;
            startTime = new DateTime(nowDate.Year, nowDate.Month, nowDate.Day, startTime.Hour, startTime.Minute, startTime.Second);

            // 当前时间已超过开始时间，则当次不生成
            if (now > startTime)
            {
                return false;
            }

            switch (et.ET_AutoType)
            {
                case (Byte)AutoType.Day:

                    break;
                case (Byte)AutoType.Week:

                    dayOfWeek = (Int32)now.DayOfWeek;
                    if (0 == dayOfWeek)
                    {
                        dayOfWeek = 7;
                    }

                    if (et.ET_AutoOffsetDay != dayOfWeek)
                    {
                        whether = false;
                    }

                    break;
                case (Byte)AutoType.Month:

                    dayOfMonth = now.Day;

                    if (et.ET_AutoOffsetDay != dayOfMonth)
                    {
                        whether = false;
                    }

                    break;
                default:
                    break;
            }

            if (whether)
            {

                eptCount =
                    olsEni
                    .ExaminationPaperTemplates
                    .Where(m =>
                        m.EPT_StartDate == nowDate
                        && m.ET_Id == et.ET_Id
                        && (m.EPT_PaperTemplateStatus == (Byte)PaperTemplateStatus.Undone
                        || m.EPT_PaperTemplateStatus == (Byte)PaperTemplateStatus.Doing))
                    .Count();

                if (0 != eptCount)
                {
                    whether = false;
                }

            }

            return whether;
        }

        public ResponseJson Generate(Int32 etId)
        {

            ExaminationTask et;
            List<Question> qs;

            et = olsEni.ExaminationTasks.SingleOrDefault(m => m.ET_Id == etId);

            if (null == et)
            {
                return new ResponseJson(ResponseStatus.Error, "任务不存在。");
            }

            try 
	        {
                qs = Generate(et);
	        }
	        catch (Exception ex)
	        {
                return new ResponseJson(ResponseStatus.Error, ex.Message);
	        }

            return new ResponseJson(ResponseStatus.Success, "自动出题运行正常。");
        }

        private List<Question> Generate(ExaminationTask et)
        {

            Byte statisticType;
            List<Question> readyQs;

            statisticType = et.ET_StatisticType;

            if ((Byte)StatisticType.Score == statisticType)
            {
                readyQs = GenerateWithScore(et);
            }
            else if ((Byte)StatisticType.Number == statisticType)
            {
                readyQs = GenerateWithNumber(et);
            }
            else
            {
                var e = new Exception("未设置成绩计算方式。");
                e.Data.Add("Info", "任务Id：" + et.ET_Id);
                throw e;
            }

            return readyQs;
        }

        private List<Question> GenerateWithScore(ExaminationTask et)
        {

            Int32 diffCoef, optionTotalScore, totalScore;
            String[] classifies;
            List<Question> qs, readyQs;
            List<AutoRatio> ratios;

            diffCoef = et.ET_DifficultyCoefficient;
            classifies = JsonConvert.DeserializeObject<String[]>(et.ET_AutoClassifies);

            qs = GetQuestions(classifies, diffCoef, true);
            qs = removeQuestionDone(et, qs);
            optionTotalScore = GetTotalScore(qs);

            totalScore = et.ET_TotalScore;

            // “备选试题总分”必须大于等于“出题总分”，才能保证有足够试题可供选择
            if (optionTotalScore >= totalScore)
            {

                // 选题
                ratios = JsonConvert.DeserializeObject<List<AutoRatio>>(et.ET_AutoRatio);
                ratios = AdjustRatios(ratios);
                readyQs = SelectQuestionsWithScore(ratios, totalScore, qs);
            }
            else// if (optionTotalScore < totalScore)
            {

                // 退出
                throw new Exception("备选试题总分小于出题总分。");
            }

            return readyQs;
        }

        // 获取可选试题
        private List<Question> GetQuestions(String[] classifies, Int32 diffCoef, Boolean hasScore)
        {

            Int32 qcId;
            QuestionClassify qc;
            List<Question> qs, tmpQs;

            qs = new List<Question>();

            foreach (var c in classifies)
            {

                qc = olsEni.QuestionClassifies.SingleOrDefault(m => m.QC_Name == c);

                if (null == qc)
                {
                    continue;
                }

                qcId = qc.QC_Id;

                // 不限制“难度系数”、限制“分数”
                if (0 == diffCoef && hasScore)
                {
                    tmpQs =
                        olsEni
                        .Questions
                        .Where(m =>
                            m.QC_Id == qcId
                            && m.Q_Score > 0
                            && m.Q_Status == (Byte)Status.Available)
                        .ToList();
                } // 未限制“难度系数”、未限制“分数”
                else if (0 == diffCoef && !hasScore)
                {
                    tmpQs =
                        olsEni
                        .Questions
                        .Where(m =>
                            m.QC_Id == qcId
                            && m.Q_Status == (Byte)Status.Available)
                        .ToList();
                } // 限制“难度系数”、限制“分数”
                else if (0 != diffCoef && hasScore)
                {
                    tmpQs =
                        olsEni
                        .Questions
                        .Where(m =>
                            m.QC_Id == qcId
                            && m.Q_Score > 0
                            && m.Q_DifficultyCoefficient == diffCoef
                            && m.Q_Status == (Byte)Status.Available)
                        .ToList();
                } // 未限制“难度系数”、未限制“分数”
                else// if (0 != diffCoef && !hasScore)
                {
                    tmpQs =
                        olsEni
                        .Questions
                        .Where(m =>
                            m.QC_Id == qcId
                            && m.Q_DifficultyCoefficient == diffCoef
                            && m.Q_Status == (Byte)Status.Available)
                        .ToList();
                }

                qs.AddRange(tmpQs);
            }

            return qs;
        }

        // 去除已出试题
        private List<Question> removeQuestionDone(ExaminationTask et, List<Question> qs)
        {

            List<ExaminationQuestionDone> eqds;
            List<Question> filteredQs;
            Int32 count;

            eqds = olsEni.ExaminationQuestionDones.Where(m => m.ET_Id == et.ET_Id).ToList();

            filteredQs = new List<Question>();

            foreach (var q in qs)
            {

                count = eqds.Where(m => m.Q_Id == q.Q_Id).Count();

                if (count == 0)
                {
                    filteredQs.Add(q);
                }
            }

            return filteredQs;
        }

        private Int32 GetTotalScore(List<Question> qs)
        {
            return qs.Select(m => m.Q_Score).Sum();
        }

        /// <summary>
        /// 去除比例值为 0 的元素，并重新调整比例
        /// </summary>
        /// <param name="ratios"></param>
        /// <returns></returns>
        private List<AutoRatio> AdjustRatios(List<AutoRatio> ratios)
        {

            Decimal totalRatio, tmpRatio;
            List<AutoRatio> tmpRatios;

            totalRatio = 0;
            tmpRatios = new List<AutoRatio>();

            foreach (var r in ratios)
            {
                if (0 != r.percent)
                {
                    tmpRatios.Add(r);
                    totalRatio += r.percent;
                }
            }

            if (tmpRatios.Count == 0)
            {
                throw new Exception("未设置出题比例。");
            }
            else if ((Double)totalRatio < 0.5)
            {
                throw new Exception("出题比例小于 50% 。");
            }
            else if (totalRatio > 1)
            {
                throw new Exception("出题比例大于 100% 。");
            }

            tmpRatio = 0;
            ratios = tmpRatios;
            foreach (var r in ratios)
            {
                // 重新计算比例，且舍为较小的数
                r.percent = StaticHelper.MathRound((Double)r.percent / (Double)totalRatio, 2);
                tmpRatio += r.percent;
            }

            // 当调整后的百分比仍小于 1 时，将差值累加至最后一个元素
            if (tmpRatio < 1)
            {
                ratios[ratios.Count - 1].percent += 1 - tmpRatio;
            }

            return ratios;
        }

        // 以设定的总分限制选题
        private List<Question> SelectQuestionsWithScore(List<AutoRatio> ratios, Int32 totalScore, List<Question> qs)
        {

            Int32 typeScore, tmpScore, overflowScore, maxValue, qId, timeout, readyTotalScore;
            Random random;
            Question q;
            Int32[] qIds;
            List<Question> readyQs, tmpQs;

            random = new Random((Int32)DateTime.Now.Ticks);
            readyQs = new List<Question>();
            overflowScore = 0;

            foreach (var r in ratios)
            {

                qIds =
                    qs
                    .Where(m => m.Q_Type == r.type)
                    .Select(m => m.Q_Id)
                    .ToArray();

                if (qIds.Length == 0)
                {
                    throw new Exception("“" + r.type + "”没有备选试题。");
                }

                tmpQs = new List<Question>();
                typeScore = (Int32)(totalScore * r.percent);

                // 判断试题总分是否足够选题
                tmpScore = qs.Where(m => m.Q_Type == r.type).Sum(m => m.Q_Score);
                if (tmpScore < typeScore)
                {
                    throw new Exception("“" + r.type + "”备选试题总分小于类型总分。");
                }

                tmpScore = 0;

                //随机选取试题，直至分数大于题型总分
                maxValue = qIds.Length;
                timeout = 0;
                while (tmpScore < typeScore)
                {

                    qId = qIds[random.Next(0, maxValue)];
                    q = qs.Single(m => m.Q_Id == qId);

                    // 避免重复
                    if (tmpQs.Where(m => m.Q_Id == q.Q_Id).Count() == 0)
                    {
                        olsEni.Entry(q).State = EntityState.Detached;
                        tmpQs.Add(q);
                        tmpScore += q.Q_Score;
                    }
                    else
                    {
                        timeout += 1;
                    }

                    if (totalTimeout == timeout)
                    {
                        throw new Exception("随机选取试题失败。失败原因：可选试题不足。");
                    }
                }

                overflowScore += tmpScore - typeScore;

                readyQs.AddRange(tmpQs);
            }

            // 确保每条试题分数大于等于 1分
            readyTotalScore = readyQs.Select(m => m.Q_Score).Sum();
            if (readyTotalScore - overflowScore < readyQs.Count)
            {
                var e = new Exception("无法减去溢出分数。");
                e.Data.Add("Info", "已选题总分：" + readyTotalScore + "；溢出分数：" + overflowScore + "；已选题总数：" + readyQs.Count + "。");
                throw e;
            }

            while (0 != overflowScore)
            {
                foreach (var q1 in readyQs)
                {
                    if (q1.Q_Score > 1)
                    {
                        q1.Q_Score = q1.Q_Score - 1;
                        overflowScore -= 1;
                    }
                    if (0 == overflowScore)
                    {
                        break;
                    }
                }
            }

            return readyQs;
        }

        public List<Question> GenerateWithNumber(ExaminationTask et)
        {

            Int32 diffCoef, optionTotalNumber, totalNumber;
            String[] classifies;
            List<Question> qs, readyQs;
            List<AutoRatio> ratios;

            diffCoef = et.ET_DifficultyCoefficient;
            classifies = JsonConvert.DeserializeObject<String[]>(et.ET_AutoClassifies);

            qs = GetQuestions(classifies, diffCoef, true);
            qs = removeQuestionDone(et, qs);
            optionTotalNumber = GetTotalNumber(qs);

            totalNumber = et.ET_TotalNumber;

            // “备选试题总数”必须大于等于“出题总数”，才能保证有足够试题可供选择
            if (optionTotalNumber >= totalNumber)
            {

                // 选题
                ratios = JsonConvert.DeserializeObject<List<AutoRatio>>(et.ET_AutoRatio);
                ratios = AdjustRatios(ratios);
                readyQs = SelectQuestionsWithNumber(ratios, totalNumber, qs);
            }
            else// if (optionTotalNumber < totalNumber)
            {

                // 退出
                throw new Exception("备选试题总数小于出题总数。");
            }

            return readyQs;
        }

        private int GetTotalNumber(List<Question> qs)
        {
            return qs.Count;
        }

        // 以设定的总数限制选题
        private List<Question> SelectQuestionsWithNumber(List<AutoRatio> ratios, int totalNumber, List<Question> qs)
        {

            Int32 typeNumber, absence;
            String type;
            Random random;
            List<Question> readyQs, tmpQs;

            random = new Random((Int32)DateTime.Now.Ticks);
            readyQs = new List<Question>();

            foreach (var r in ratios)
            {

                typeNumber = (Int32)(totalNumber * r.percent); // 取较小的整数
                tmpQs = SelectQuestionsWithNumber(qs, r.type, typeNumber, totalTimeout);
                readyQs.AddRange(tmpQs);
            }

            // 选择的试题数量不足时，用最后一个类型补足
            absence = totalNumber - readyQs.Count;
            if (absence > 0)
            {
                type = ratios[ratios.Count - 1].type;
                tmpQs = SelectQuestionsWithNumber(qs, type, absence, totalTimeout);
                readyQs.AddRange(tmpQs);
            } // 试题数量溢出时，从后边减去
            /*else if (absence < 0)
            {

                readyQs.RemoveRange(readyQs.Count + absence, Math.Abs(absence));
            }*/

            return readyQs;
        }

        private List<Question> SelectQuestionsWithNumber(List<Question> qs, String type, Int32 typeNumber, Int32 totalTimeout)
        {

            Int32 maxValue, timeout, increment, qId;
            Random random;
            Question q;
            Int32[] qIds;
            List<Question> tmpQs;

            qIds =
                qs
                .Where(m => m.Q_Type == type)
                .Select(m => m.Q_Id)
                .ToArray();

            tmpQs = new List<Question>();

            if (qIds.Length == 0)
            {
                throw new Exception("“" + type + "”没有备选试题。");
            }
            else if (qIds.Length < typeNumber)
            {
                var e = new Exception("“" + type + "”备选试题总数小于类型总数。");
                e.Data.Add("Info", "试题类型：" + type + "；现有数量：" + qIds.Count() + "；需要数量：" + typeNumber + "。");
                throw e;
            }
            else if (qIds.Length == typeNumber)
            {
                foreach (var id in qIds)
                {
                    var q1 = qs.Single(m => m.Q_Id == id);
                    olsEni.Entry(q1).State = EntityState.Detached;
                    tmpQs.Add(q1);
                }

                return tmpQs;
            }

            maxValue = qIds.Length - 1;
            timeout = 0;
            increment = 0;
            random = new Random((Int32)DateTime.Now.Ticks);



            while (increment < typeNumber)
            {

                qId = qIds[random.Next(maxValue)];
                q = qs.Single(m => m.Q_Id == qId);

                // 避免重复
                if (tmpQs.Where(m => m.Q_Id == q.Q_Id).Count() == 0)
                {
                    olsEni.Entry(q).State = EntityState.Detached;
                    tmpQs.Add(q);
                    increment += 1;
                }
                else
                {
                    timeout += 1;
                }

                if (totalTimeout == timeout)
                {
                    var e = new Exception("随机选取试题失败。失败原因：可选试题不足。");
                    e.Data.Add("Info", "试题类型：" + type + "；现有数量：" + qIds.Count() + "；需要数量：" + typeNumber + "；重复次数：" + totalTimeout + "。");
                    throw e;
                }
            }

            return tmpQs;
        }

        private Boolean CreatePaperTemplate(ExaminationTask et, List<Question> readyQs)
        {

            Int32 eptId, eptqId;
            String eptQs;
            DateTime startTime, endTime;
            Int32[] eptQsAry;
            ExaminationPaperTemplate ept;
            ExaminationPaperTemplateQuestion eptq;
            ExaminationQuestionDone eqd;

            List<ExaminationPaperTemplateQuestion> tmpEPTQ = new List<ExaminationPaperTemplateQuestion>();

            eptId = GetEPTId();

            eptQsAry = readyQs.Select(m => m.Q_Id).ToArray();
            eptQs = JsonConvert.SerializeObject(eptQsAry);

            startTime = et.ET_StartTime;
            startTime = new DateTime(nowDate.Year, nowDate.Month, nowDate.Day, startTime.Hour, startTime.Minute, startTime.Second);

            endTime = et.ET_EndTime;
            endTime = new DateTime(nowDate.Year, nowDate.Month, nowDate.Day, endTime.Hour, endTime.Minute, endTime.Second);

            ept = new ExaminationPaperTemplate
            {
                EPT_Id = eptId,
                ET_Id = et.ET_Id,
                ET_Type = et.ET_Type,
                EPT_PaperTemplateStatus = (Byte)PaperTemplateStatus.Undone,
                EPT_StartDate = nowDate,
                EPT_StartTime = startTime,
                EPT_EndTime = endTime,
                EPT_TimeSpan = et.ET_TimeSpan,
                EPT_Questions = eptQs,
                EPT_Remark = "本试卷模板由系统于" + now.ToString("yyyy年MM月dd日") + "自动生成。",
                EPT_AddTime = now,
                EPT_Status = 1
            };
            olsEni.Entry(ept).State = EntityState.Added;

            if (0 == olsEni.SaveChanges())
            {
                throw new Exception(ResponseMessage.SaveChangesError);
            }

            eptqId = GetEPTQId();

            foreach (var q in readyQs)
            {

                eptq = new ExaminationPaperTemplateQuestion
                {
                    EPTQ_Id = eptqId,
                    EPT_Id = eptId,
                    EPTQ_Type = q.Q_Type,
                    EPTQ_Classify = q.QC_Id,
                    EPTQ_Score = q.Q_Score,
                    EPTQ_Content = q.Q_Content,
                    EPTQ_OptionalAnswer = q.Q_OptionalAnswer,
                    EPTQ_ModelAnswer = q.Q_ModelAnswer,
                    EPTQ_Remark = q.Q_Remark,
                    EPTQ_AddTime = now,
                    EPTQ_Status = 1
                };
                tmpEPTQ.Add(eptq);
                olsEni.Entry(eptq).State = EntityState.Added;

                // 添加已出题记录
                eqd = new ExaminationQuestionDone { ET_Id = et.ET_Id, EPT_Id = ept.EPT_Id, Q_Id = q.Q_Id };
                olsEni.Entry(eqd).State = EntityState.Added;

                eptqId += 1;
            }

            if (0 == olsEni.SaveChanges())
            {
                throw new Exception(ResponseMessage.SaveChangesError);
            }

            return true;
        }

        public Int32 CreatePaperTemplateOfExercise(ExaminationTask et, List<Question> readyQs)
        {

            Int32 eptId, eptqId;
            String eptQs;
            Int32[] eptQsAry;
            ExaminationPaperTemplate ept;
            ExaminationPaperTemplateQuestion eptq;
            ExaminationQuestionDone eqd;

            eptId = GetEPTId();

            eptQsAry = readyQs.Select(m => m.Q_Id).ToArray();
            eptQs = JsonConvert.SerializeObject(eptQsAry);

            ept = new ExaminationPaperTemplate
            {
                EPT_Id = eptId,
                ET_Id = et.ET_Id,
                ET_Type = et.ET_Type,
                EPT_PaperTemplateStatus = (Byte)PaperTemplateStatus.Undone,
                EPT_StartDate = et.ET_StartTime.Date,
                EPT_StartTime = et.ET_StartTime, // 练习试卷模板，无需开启，故“开始时间”设置为任务定义的“开始时间”。
                EPT_EndTime = et.ET_StartTime, // 同上
                EPT_TimeSpan = et.ET_TimeSpan,
                EPT_Questions = eptQs,
                EPT_Remark = "本试卷模板由系统于" + now.ToString("yyyy年MM月dd日") + "自动生成。",
                EPT_AddTime = now,
                EPT_Status = 1
            };
            olsEni.Entry(ept).State = EntityState.Added;

            if (0 == olsEni.SaveChanges())
            {
                throw new Exception(ResponseMessage.SaveChangesError);
            }

            eptqId = GetEPTQId();

            foreach (var q in readyQs)
            {

                eptq = new ExaminationPaperTemplateQuestion
                {
                    EPTQ_Id = eptqId,
                    EPT_Id = eptId,
                    EPTQ_Type = q.Q_Type,
                    EPTQ_Classify = q.QC_Id,
                    EPTQ_Score = q.Q_Score,
                    EPTQ_Content = q.Q_Content,
                    EPTQ_OptionalAnswer = q.Q_OptionalAnswer,
                    EPTQ_ModelAnswer = q.Q_ModelAnswer,
                    EPTQ_Remark = q.Q_Remark,
                    EPTQ_AddTime = now,
                    EPTQ_Status = 1
                };
                olsEni.Entry(eptq).State = EntityState.Added;

                // 添加已出题记录
                eqd = new ExaminationQuestionDone { ET_Id = et.ET_Id, EPT_Id = ept.EPT_Id, Q_Id = q.Q_Id };
                olsEni.Entry(eqd).State = EntityState.Added;

                eptqId += 1;
            }

            if (0 == olsEni.SaveChanges())
            {
                throw new Exception(ResponseMessage.SaveChangesError);
            }

            return eptId;
        }
    }
}