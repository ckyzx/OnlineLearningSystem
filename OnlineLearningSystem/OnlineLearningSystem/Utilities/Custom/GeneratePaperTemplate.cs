using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using OnlineLearningSystem.Models;
using Newtonsoft.Json;

namespace OnlineLearningSystem.Utilities
{
    public class GeneratePaperTemplate : Utility
    {

        private DateTime now, nowDate;

        public ResponseJson Generate()
        {

            ResponseJson resJson;

            resJson = new ResponseJson(ResponseStatus.Success);

            try
            {

                List<ExaminationTask> ets;
                Int32 eptCount, dayOfWeek, dayOfMonth, result;

                ets =
                    olsEni
                    .ExaminationTasks
                    .Where(m =>
                        m.ET_AutoType != (Byte)AutoType.Manual
                        && m.ET_Enabled == (Byte)ExaminationTaskStatus.Enabled)
                    .ToList();

                now = DateTime.Now;
                nowDate = now.Date;

                foreach (var et in ets)
                {

                    #region 判断是否需要生成试卷模板

                    switch (et.ET_AutoType)
                    {
                        case (Byte)AutoType.Day:

                            eptCount =
                                olsEni
                                .ExaminationPaperTemplates
                                .Where(m => m.EPT_StartDate == nowDate)
                                .Count();

                            if (0 != eptCount)
                            {
                                continue;
                            }

                            break;
                        case (Byte)AutoType.Week:

                            dayOfWeek = ((Int32)now.DayOfWeek) + 1;

                            if (et.ET_AutoOffsetDay != dayOfWeek)
                            {
                                continue;
                            }

                            break;
                        case (Byte)AutoType.Month:

                            dayOfMonth = now.Day;

                            if (et.ET_AutoOffsetDay != dayOfMonth)
                            {
                                continue;
                            }

                            break;
                        default:
                            break;
                    }

                    #endregion

                    try
                    {

                        result = Generate(et);
                        if (1 != result)
                        {
                            resJson.status = ResponseStatus.Error;
                            et.ET_Enabled = (Byte)ExaminationTaskStatus.Disabled;
                            resJson.message += et.ET_Name + "：" + GenerateResult(result) + "\r\n";
                        }

                    }
                    catch (Exception ex)
                    {
                        // 生成试卷模板的过程中发生异常，将考试任务状态设为“关闭”
                        et.ET_Enabled = (Byte)ExaminationTaskStatus.Disabled;
                        resJson.message += et.ET_Name + "：" + ex.Message + "\r\n";
                    }

                    if (0 == olsEni.SaveChanges())
                    {
                        resJson.status = ResponseStatus.Error;
                        resJson.message += ResponseMessage.SaveChangeError + "\r\n";
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

        public Int32 Generate(ExaminationTask et)
        {

            Byte statisticType;
            Int32 result;

            statisticType = et.ET_StatisticType;

            if ((Byte)StatisticType.Score == statisticType)
            {
                result = GenerateWithScore(et);
            }
            else if ((Byte)StatisticType.Number == statisticType)
            {
                result = GenerateWithNumber(et);
            }
            else
            {
                result = 0;
            }

            return result;
        }

        private Int32 GenerateWithScore(ExaminationTask et)
        {

            Int32 diffCoef, optionTotalScore, totalScore;
            String[] classifies;
            List<Question> qs, readyQs;
            List<AutoRatio> ratios;

            diffCoef = et.ET_DifficultyCoefficient;
            classifies = JsonConvert.DeserializeObject<String[]>(et.ET_AutoClassifies);

            qs = GetQuestions(classifies, diffCoef);
            optionTotalScore = GetTotalScore(qs);

            totalScore = et.ET_TotalScore;

            // “备选试题总分”必须大于“出题总分”，才能保证有足够试题可供选择
            if (optionTotalScore > totalScore)
            {

                // 选题
                ratios = JsonConvert.DeserializeObject<List<AutoRatio>>(et.ET_AutoRatio);
                readyQs = SelectQuestions(ratios, totalScore, qs);
            }
            else if (optionTotalScore == totalScore)
            {

                // 取所有试题
                readyQs = qs.ToList();
            }
            else if (optionTotalScore < totalScore)
            {

                // 退出
                return -2;
            }
            else
            {
                return 0;
            }

            return SaveQuestions(et.ET_Id, readyQs);
        }

        private List<Question> GetQuestions(string[] classifies, int diffCoef)
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

                if (0 == diffCoef)
                {
                    tmpQs =
                        olsEni
                        .Questions
                        .Where(m =>
                            m.QC_Id == qcId
                            && m.Q_Score > 0)
                        .ToList();
                }
                else
                {
                    tmpQs =
                        olsEni
                        .Questions
                        .Where(m =>
                            m.QC_Id == qcId
                            && m.Q_Score > 0
                            && m.Q_DifficultyCoefficient == diffCoef)
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

        private List<Question> SelectQuestions(List<AutoRatio> ratios, Int32 totalScore, List<Question> qs)
        {

            Int32 typeScore, tmpScore, maxValue, qId;
            Decimal totalRatio, tmpRatio;
            Random random;
            Question q;
            Int32[] qIds;
            List<Question> readyQs;
            List<AutoRatio> tmpRatios;

            totalRatio = 0;
            random = new Random((Int32)DateTime.Now.Ticks);
            readyQs = new List<Question>();
            tmpRatios = new List<AutoRatio>();

            #region 去除比例值为 0 的元素，并重新调整比例

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
                throw new Exception("出题比例未设置。");
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
                ratios[ratios.Count - 1].percent += totalRatio - tmpRatio;
            }

            #endregion

            foreach (var r in ratios)
            {

                typeScore = (Int32)(totalScore * r.percent);
                tmpScore = 0;

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

                while (tmpScore < typeScore)
                {

                    qId = qIds[random.Next(maxValue)];
                    q = qs.Single(m => m.Q_Id == qId);

                    // 避免重复
                    if (readyQs.Where(m => m.Q_Id == q.Q_Id).Count() == 0)
                    {
                        readyQs.Add(q);
                        tmpScore += q.Q_Score;
                    }
                }

                if (tmpScore - typeScore > typeScore)
                {
                    throw new Exception("溢出分数大于题型总分。");
                }

                // 去除“溢出分数”
                if (tmpScore > typeScore)
                {

                    tmpScore = tmpScore - typeScore;

                    // 必须保证减去“溢出分数”后的单个“备选试题”的分数大于 1
                    // “备选试题总分”减去“溢出分数”后大于等于“备选试题总数”，属异常情况
                    if (tmpScore - readyQs.Select(m => m.Q_Score).Sum() >= readyQs.Count)
                    {
                        throw new Exception("无法减去溢出分数。");
                    }

                    while (true)
                    {
                        foreach (var q1 in readyQs)
                        {
                            if (q1.Q_Score > 1)
                            {
                                q1.Q_Score = q1.Q_Score - 1;
                                tmpScore -= 1;
                            }
                            if (1 < tmpScore)
                            {
                                break;
                            }
                        }
                    }
                }
            }

            return readyQs;
        }

        private Int32 GenerateWithNumber(ExaminationTask et)
        {
            throw new NotImplementedException();
        }

        private Int32 SaveQuestions(Int32 etId, List<Question> readyQs)
        {
            throw new NotImplementedException();
        }

        public String GenerateResult(Int32 result)
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