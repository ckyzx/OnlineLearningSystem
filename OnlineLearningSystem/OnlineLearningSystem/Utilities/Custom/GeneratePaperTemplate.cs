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

        private DateTime nowDate;

        public ResponseJson Generate()
        {

            ResponseJson resJson;

            resJson = new ResponseJson(ResponseStatus.Success, now);

            try
            {

                List<ExaminationTask> ets;

                ets =
                    olsEni
                    .ExaminationTasks
                    .Where(m =>
                        m.ET_AutoType != (Byte)AutoType.Manual
                        && m.ET_Enabled == (Byte)ExaminationTaskStatus.Enabled
                        && m.ET_Status == (Byte)Status.Available)
                    .ToList();

                nowDate = now.Date;

                foreach (var et in ets)
                {


                    if (!WhetherGenerate(et))
                    {
                        continue;
                    }

                    try
                    {

                        Generate(et);

                    }
                    catch (Exception ex)
                    {
                        // 生成试卷模板的过程中发生异常，将考试任务状态设为“关闭”
                        et.ET_Enabled = (Byte)ExaminationTaskStatus.Disabled;
                        resJson.message += et.ET_Name + "：" + ex.Message + "\r\n";

                        if (0 == olsEni.SaveChanges())
                        {
                            resJson.status = ResponseStatus.Error;
                            resJson.message += ResponseMessage.SaveChangesError + "\r\n";
                        }

                        StaticHelper.RecordSystemLog(SystemLogType.Exception, ex.Message, resJson.message);
                    }

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

        // 判断是否需要生成试卷模板
        private Boolean WhetherGenerate(ExaminationTask et)
        {

            Int32 eptCount, dayOfWeek, dayOfMonth;
            Boolean whether;
            DateTime startTime;

            whether = true;

            startTime = et.ET_StartTime;
            startTime = new DateTime(nowDate.Year, nowDate.Month, nowDate.Day, startTime.Hour, startTime.Minute, startTime.Second);

            // 当前时间已超过开始时间
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
                        && m.ET_Id == et.ET_Id)
                    .Count();

                if (0 != eptCount)
                {
                    whether = false;
                }

            }

            return whether;
        }

        public void Generate(ExaminationTask et)
        {

            Byte statisticType;
            
            statisticType = et.ET_StatisticType;

            if ((Byte)StatisticType.Score == statisticType)
            {
                GenerateWithScore(et);
            }
            else if ((Byte)StatisticType.Number == statisticType)
            {
                GenerateWithNumber(et);
            }
        }

        private void GenerateWithScore(ExaminationTask et)
        {

            Int32 diffCoef, optionTotalScore, totalScore;
            String[] classifies;
            List<Question> qs, readyQs;
            List<AutoRatio> ratios;

            diffCoef = et.ET_DifficultyCoefficient;
            classifies = JsonConvert.DeserializeObject<String[]>(et.ET_AutoClassifies);

            qs = GetQuestions(classifies, diffCoef, true);
            optionTotalScore = GetTotalScore(qs);

            totalScore = et.ET_TotalScore;

            // “备选试题总分”必须大于“出题总分”，才能保证有足够试题可供选择
            if (optionTotalScore > totalScore)
            {

                // 选题
                ratios = JsonConvert.DeserializeObject<List<AutoRatio>>(et.ET_AutoRatio);
                ratios = AdjustRatios(ratios);
                readyQs = SelectQuestionsWithScore(ratios, totalScore, qs);
            }
            else if (optionTotalScore == totalScore)
            {

                // 取所有试题
                readyQs = qs.ToList();
            }
            else if (optionTotalScore < totalScore)
            {

                // 退出
                throw new Exception("备选试题总分小于出题总分。");
            }
            else
            {
                return;
            }

            SaveQuestions(et, readyQs);
        }

        private List<Question> GetQuestions(string[] classifies, int diffCoef, Boolean hasScore)
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
                }
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
                }
                else if (0 == diffCoef && !hasScore)
                {
                    tmpQs =
                        olsEni
                        .Questions
                        .Where(m =>
                            m.QC_Id == qcId
                            && m.Q_Status == (Byte)Status.Available)
                        .ToList();
                }
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

        private Int32 GetTotalScore(List<Question> qs)
        {
            return qs.Select(m => m.Q_Score).Sum();
        }

        // 去除比例值为 0 的元素，并重新调整比例
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

            tmpRatio = 0;
            ratios = tmpRatios;
            foreach (var r in ratios)
            {
                r.percent = Math.Round(r.percent / totalRatio, 2, MidpointRounding.AwayFromZero); // 取较小的数
                tmpRatio += r.percent;
            }
            // 当调整后的百分比仍小于 1 时，将差值累加至最后一个元素
            if (tmpRatio < 1)
            {
                ratios[ratios.Count - 1].percent += 1 - tmpRatio;
            }

            return ratios;
        }

        private List<Question> SelectQuestionsWithScore(List<AutoRatio> ratios, Int32 totalScore, List<Question> qs)
        {

            Int32 typeScore, tmpScore, overflowScore, maxValue, qId, totalTimeout, timeout;
            Random random;
            Question q;
            Int32[] qIds;
            List<Question> readyQs, tmpQs;

            random = new Random((Int32)DateTime.Now.Ticks);
            readyQs = new List<Question>();
            overflowScore = 0;
            totalTimeout = 100;

            foreach (var r in ratios)
            {

                tmpQs = new List<Question>();

                typeScore = (Int32)(totalScore * r.percent);
                tmpScore = 0;

                qIds =
                    qs
                    .Where(m =>
                        m.Q_Type == r.type 
                        && m.Q_Status == (Byte)Status.Available)
                    .Select(m => m.Q_Id)
                    .ToArray();

                if (qIds.Length == 0)
                {
                    throw new Exception("“" + r.type + "”没有备选试题。");
                }

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
                    else {
                        timeout += 1;
                    }

                    if (totalTimeout == timeout)
                    {
                        throw new Exception("随机选取试题失败。");
                    }
                }

                /*if (tmpScore - typeScore > typeScore)
                {
                    throw new Exception("“" + r.type + "”溢出分数大于题型总分。");
                }

                // 去除“溢出分数”
                if (tmpScore > typeScore)
                {

                    tmpScore = tmpScore - typeScore;

                    // 必须保证减去“溢出分数”后的单个“备选试题”的分数大于 1
                    // “备选试题总分”减去“溢出分数”后大于等于“备选试题总数”，属异常情况
                    if (tmpScore - tmpQs.Select(m => m.Q_Score).Sum() >= tmpQs.Count)
                    {
                        throw new Exception("“" + r.type + "”无法减去溢出分数。");
                    }

                    while (0 != tmpScore)
                    {
                        foreach (var q1 in tmpQs)
                        {
                            if (q1.Q_Score > 1)
                            {
                                q1.Q_Score = q1.Q_Score - 1;
                                tmpScore -= 1;
                            }
                            if (0 == tmpScore)
                            {
                                break;
                            }
                        }
                    }
                }*/

                overflowScore += tmpScore - typeScore;

                readyQs.AddRange(tmpQs);
            }

            if (overflowScore - readyQs.Select(m => m.Q_Score).Sum() >= readyQs.Count)
            {
                throw new Exception("无法减去溢出分数。");
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

        private void GenerateWithNumber(ExaminationTask et)
        {

            Int32 diffCoef, optionTotalNumber, totalNumber;
            String[] classifies;
            List<Question> qs, readyQs;
            List<AutoRatio> ratios;

            diffCoef = et.ET_DifficultyCoefficient;
            classifies = JsonConvert.DeserializeObject<String[]>(et.ET_AutoClassifies);

            qs = GetQuestions(classifies, diffCoef, true);
            optionTotalNumber = GetTotalNumber(qs);

            totalNumber = et.ET_TotalNumber;

            // “备选试题总数”必须大于“出题总数”，才能保证有足够试题可供选择
            if (optionTotalNumber > totalNumber)
            {

                // 选题
                ratios = JsonConvert.DeserializeObject<List<AutoRatio>>(et.ET_AutoRatio);
                ratios = AdjustRatios(ratios);
                readyQs = SelectQuestionsWithNumber(ratios, totalNumber, qs);
            }
            else if (optionTotalNumber == totalNumber)
            {

                // 取所有试题
                readyQs = qs.ToList();
            }
            else if (optionTotalNumber < totalNumber)
            {

                // 退出
                throw new Exception("备选试题总数小于出题总数。");
            }
            else
            {
                return;
            }

            SaveQuestions(et, readyQs);
        }

        private int GetTotalNumber(List<Question> qs)
        {
            return qs.Count;
        }

        private List<Question> SelectQuestionsWithNumber(List<AutoRatio> ratios, int totalNumber, List<Question> qs)
        {
            
            Int32 typeNumber, tmpNumber, maxValue, qId;
            String type;
            Random random;
            Question q;
            Int32[] qIds;
            List<Question> readyQs, tmpQs;

            random = new Random((Int32)DateTime.Now.Ticks);
            readyQs = new List<Question>();

            foreach (var r in ratios)
            {

                tmpQs = new List<Question>();

                typeNumber = (Int32)(totalNumber * r.percent);
                tmpNumber = 0;

                qIds =
                    qs
                    .Where(m => m.Q_Type == r.type)
                    .Select(m => m.Q_Id)
                    .ToArray();

                if (qIds.Length == 0)
                {
                    throw new Exception("“" + r.type + "”没有备选试题。");
                }

                maxValue = qIds.Length - 1;

                while (tmpNumber < typeNumber)
                {

                    qId = qIds[random.Next(maxValue)];
                    q = qs.Single(m => m.Q_Id == qId);

                    // 避免重复
                    if (tmpQs.Where(m => m.Q_Id == q.Q_Id).Count() == 0)
                    {
                        tmpQs.Add(q);
                        tmpNumber += 1;
                    }
                }

                readyQs.AddRange(tmpQs);
            }

            // 选择的试题数量不足时，用最后一个类型补足
            typeNumber = totalNumber - readyQs.Count;
            if (typeNumber > 0)
            {

                tmpQs = new List<Question>();

                tmpNumber = 0;

                type = ratios[ratios.Count - 1].type;
                qIds =
                    qs
                    .Where(m => m.Q_Type == type)
                    .Select(m => m.Q_Id)
                    .ToArray();

                if (qIds.Length == 0)
                {
                    throw new Exception("“" + type + "”没有备选试题。");
                }

                maxValue = qIds.Length - 1;

                while (tmpNumber < typeNumber)
                {

                    qId = qIds[random.Next(maxValue)];
                    q = qs.Single(m => m.Q_Id == qId);

                    // 避免重复
                    if (tmpQs.Where(m => m.Q_Id == q.Q_Id).Count() == 0
                        && readyQs.Where(m=>m.Q_Id == q.Q_Id).Count() == 0)
                    {
                        tmpQs.Add(q);
                        tmpNumber += 1;
                    }
                }

                readyQs.AddRange(tmpQs);
            }else if(typeNumber < 0){

                readyQs.RemoveRange(readyQs.Count + typeNumber, Math.Abs(typeNumber));
            }

            return readyQs;
        }

        private void SaveQuestions(ExaminationTask et, List<Question> readyQs)
        {

            Int32 eptId, eptqId;
            String eptQs;
            DateTime startTime;
            Int32[] eptQsAry;
            ExaminationPaperTemplate ept;
            ExaminationPaperTemplateQuestion eptq;

            eptId = olsEni.ExaminationPaperTemplates.Count();
            eptId = 0 == eptId ? 1 : olsEni.ExaminationPaperTemplates.Max(m => m.EPT_AutoId) + 1;

            eptQsAry = readyQs.Select(m => m.Q_Id).ToArray();
            eptQs = JsonConvert.SerializeObject(eptQsAry);

            startTime = et.ET_StartTime;
            startTime = new DateTime(nowDate.Year, nowDate.Month, nowDate.Day, startTime.Hour, startTime.Minute, startTime.Second);

            ept = new ExaminationPaperTemplate
            {
                EPT_Id = eptId,
                ET_Id = et.ET_Id,
                ET_Type = et.ET_Type,
                EPT_PaperTemplateStatus = (Byte)PaperTemplateStatus.Undone,
                EPT_StartDate = nowDate,
                EPT_StartTime = startTime,
                EPT_EndTime = startTime.AddMinutes(et.ET_TimeSpan),
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

            eptqId = olsEni.ExaminationPaperTemplateQuestions.Count();
            eptqId = 0 == eptqId ? 1 : olsEni.ExaminationPaperTemplateQuestions.Max(m => m.EPTQ_AutoId) + 1;

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

                eptqId += 1;
            }

            if (0 == olsEni.SaveChanges())
            {
                throw new Exception(ResponseMessage.SaveChangesError);
            }
        }

        private String GenerateResult(Int32 result)
        {

            String prompt;

            switch (result)
            {
                case 1:
                    prompt = "正常。";
                    break;
                case 0:
                    prompt = "未设置的异常。";
                    break;
                case -1:
                    prompt = "数据保存错误。";
                    break;
                case -2:
                    prompt = "备选试题总分小于出题总分。";
                    break;
                default:
                    prompt = "未定义的错误。";
                    break;
            }

            return prompt;
        }
    }
}