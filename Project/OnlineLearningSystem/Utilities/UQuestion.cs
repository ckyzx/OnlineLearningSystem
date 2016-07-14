using System;
using System.Collections.Generic;
using System.Linq;
using System.Data;
using System.Web;
using System.Web.Mvc;
using OnlineLearningSystem.Models;

using System.Text.RegularExpressions;
using Newtonsoft.Json;
using System.Text;
using System.Data.SqlClient;

namespace OnlineLearningSystem.Utilities
{
    public class UQuestion : Utility
    {

        public Dictionary<String, String> ImportDocx(String filePath)
        {

            Dictionary<String, String> dic;

            dic = new Dictionary<String, String>();
            dic.Add("Status", "0");
            dic.Add("Data", "");
            dic.Add("Message", "");

            try
            {

                List<DocxParagraph> docxPara;
                const String qTypes = "单选题；多选题；判断题；公文改错题；计算题；案例分析题；问答题；";
                DateTime now;
                Regex commentRegex, typeRegex, contentRegex1, contentRegex2, optionalAnswerRegex, modelAnswerRegex,
                    difficultyCoefficientRegex, scoreRegex, digitRegex;
                String text, qType, qClassify, qContent, qOptionalAnswer, qModelAnswer;
                Int32 i1, i2, len, qId, qcId, currentQCId, score, duplicate;
                Byte difficultyCoefficient;
                Boolean isContent, existsFlag;
                List<Question> qs, tmpQs;
                List<QuestionClassify> qcs;
                QuestionClassify qc;
                StringBuilder errorIds;

                errorIds = new StringBuilder();

                docxPara = OpenXmlDocHelper.GetDocxParagraphs(filePath);

                now = DateTime.Now;

                commentRegex = new Regex(@"^\/\/");
                typeRegex = new Regex(@"^题型[:：]{1}");
                contentRegex1 = new Regex(@"^\s*\d+[\.．、]"); // 示例：1.
                contentRegex2 = new Regex(@"^\s*\(.+\)|^\s*（.+）"); // 示例：(一) （一）
                optionalAnswerRegex = new Regex(@"^\s*[a-zA-Z]{1}[\.．、]{1}"); // 示例：A. B. C.
                modelAnswerRegex = new Regex(@"^\s*((答案|参考答案){1}[:：]{1})|【答】");
                difficultyCoefficientRegex = new Regex(@"^难度系数[：:]{1}\d{1}");
                scoreRegex = new Regex(@"^分数[：:]{1}\d+$");
                digitRegex = new Regex(@"\d+");

                qType = "";
                qClassify = "";
                qContent = "";
                qOptionalAnswer = "";
                qModelAnswer = "";
                isContent = true;

                qs = new List<Question>();
                qcs = new List<QuestionClassify>();

                // 获取数据编号
                qcId = GetQCId();
                currentQCId = qcId;

                difficultyCoefficient = 0;
                score = 0;

                foreach (var para in docxPara)
                {

                    text = para.Text;

                    // 忽略“备注行”
                    if (commentRegex.IsMatch(text))
                    {
                        continue;
                    }

                    #region 添加试题数据

                    switch (qType)
                    {
                        case "单选题":
                        case "多选题":
                        case "判断题":
                        case "计算题":
                        case "案例分析题":
                        case "问答题":

                            if ((contentRegex1.IsMatch(text) || typeRegex.IsMatch(text))
                                && qModelAnswer != "")
                            {

                                // 格式化单选题/多选题的答案
                                if (qType == "单选题" || qType == "多选题")
                                {
                                    qOptionalAnswer = FormatOptionalAnswer(qOptionalAnswer);
                                    qModelAnswer = FormatModelAnswer(qModelAnswer);

                                }

                                qs.Add(new Question()
                                {
                                    Q_Id = 0,
                                    Q_Type = qType,
                                    QC_Id = currentQCId,
                                    Q_DifficultyCoefficient = difficultyCoefficient,
                                    Q_Score = SetDefaultScore(qType, score),
                                    Q_Content = qContent,
                                    Q_OptionalAnswer = qOptionalAnswer,
                                    Q_ModelAnswer = qModelAnswer,
                                    Q_AddTime = now,
                                    Q_Status = 4
                                });

                                difficultyCoefficient = 0;
                                score = 0;
                                qContent = "";
                                qOptionalAnswer = "";
                                qModelAnswer = "";
                                isContent = true;
                            }

                            break;

                        case "公文改错题":

                            if ((contentRegex2.IsMatch(text) || typeRegex.IsMatch(text))
                                && qModelAnswer != "")
                            {

                                qs.Add(new Question()
                                {
                                    Q_Id = 0,
                                    Q_Type = qType,
                                    QC_Id = currentQCId,
                                    Q_DifficultyCoefficient = difficultyCoefficient,
                                    Q_Score = SetDefaultScore(qType, score),
                                    Q_Content = qContent,
                                    Q_OptionalAnswer = qOptionalAnswer,
                                    Q_ModelAnswer = qModelAnswer,
                                    Q_AddTime = now,
                                    Q_Status = 4
                                });

                                difficultyCoefficient = 0;
                                score = 0;
                                qContent = "";
                                qOptionalAnswer = "";
                                qModelAnswer = "";
                                isContent = true;
                            }

                            break;

                        default:
                            break;
                    }
                    #endregion

                    #region 判断是否为分类行

                    // 此行为分类行
                    if (text.IndexOf("分类：") == 0)
                    {
                        // 添加分类数据，记录分类编号
                        qClassify = text.Substring(3);

                        // 判断分类是否存在
                        qc =
                            olsEni.QuestionClassifies
                            .SingleOrDefault(m =>
                                m.QC_Name == qClassify);

                        // 如果不存在，则新增
                        if (null == qc)
                        {

                            currentQCId = qcId;

                            qcs.Add(new QuestionClassify()
                            {
                                QC_Id = qcId,
                                QC_Name = qClassify,
                                QC_Level = "000" + qcId.ToString(),
                                QC_AddTime = now,
                                QC_Status = (Byte)Status.Cache
                            });
                            qcId += 1;
                        }
                        // 如果存在，但状态非“正常”，则新增同名分类加编号后缀
                        else if (qc.QC_Status != (Byte)Status.Available)
                        {

                            currentQCId = qcId;

                            qcs.Add(new QuestionClassify()
                            {
                                QC_Id = qcId,
                                QC_Name = qClassify + qcId,
                                QC_Level = "000" + qcId.ToString(),
                                QC_AddTime = now,
                                QC_Status = (Byte)Status.Cache
                            });
                            qcId += 1;
                        }
                        // 如果存在，设置当前分类编号
                        else
                        {
                            currentQCId = qc.QC_Id;
                        }

                        continue;
                    }

                    #endregion

                    #region 判断是否为题型行

                    // 此行为题型行
                    if (typeRegex.IsMatch(text))
                    {

                        qType = text.Substring(3);
                        qType = qType.Replace("单项选择题", "单选题");
                        qType = qType.Replace("多项选择题", "多选题");

                        if (qTypes.IndexOf(qType) == -1)
                        {
                            //TODO:返回，提示“当前题型不支持导入”
                            dic["Message"] = "题型“" + qType + "”不支持导入。";
                            return dic;
                        }

                        continue;
                    }

                    #endregion

                    #region 判断是否为难度系数行

                    if (difficultyCoefficientRegex.IsMatch(text))
                    {
                        difficultyCoefficient = Convert.ToByte(digitRegex.Match(text).Value);
                        continue;
                    }

                    #endregion

                    #region 判断是否为分数行

                    if (scoreRegex.IsMatch(text))
                    {
                        score = Convert.ToInt32(digitRegex.Match(text).Value);
                        continue;
                    }

                    #endregion

                    #region 判断是否为试题内容行

                    //TODO:记录试题内容
                    switch (qType)
                    {
                        case "单选题":
                        case "多选题":
                        case "判断题":

                            if (contentRegex1.IsMatch(text))
                            {

                                // 提取标准答案
                                text = contentRegex1.Replace(text, "");
                                qContent = text;
                                qContent = qContent.Replace("（", "(");
                                qContent = qContent.Replace("）", ")");

                                i1 = qContent.LastIndexOf("(");
                                i2 = qContent.LastIndexOf(")");

                                if (i1 == -1 || i2 == -1)
                                {
                                    //TODO:返回提示格式错误
                                    dic["Message"] = "题型格式有误。";
                                    return dic;
                                }

                                len = i2 - i1 - 1;
                                qModelAnswer = qContent.Substring(i1 + 1, len);
                                if (qModelAnswer != "")
                                {
                                    qContent = qContent.Replace(qModelAnswer, "  ");
                                    qModelAnswer = qModelAnswer.Trim();

                                    // 处理判断题答案
                                    if ("判断题" == qType && qModelAnswer.ToLower() == "x")
                                    {
                                        qModelAnswer = "×";
                                    }

                                    // 当判断题答案有误时的处理
                                    if ("判断题" == qType && "×" != qModelAnswer && "√" != qModelAnswer)
                                    {
                                        qModelAnswer = "O";
                                    }
                                }
                                else // 避免模板中没有设置答案时不添加试题
                                {
                                    qModelAnswer = " ";
                                }

                                continue;

                            }

                            break;

                        case "公文改错题":
                        case "计算题":
                        case "案例分析题":
                        case "问答题":

                            // 公文改错题；计算题；案例分析题；问答题；
                            // 判断是否为标准答案行
                            if (modelAnswerRegex.IsMatch(text))
                            {

                                isContent = false;

                                text = modelAnswerRegex.Replace(text, "");
                            }

                            if (isContent)
                            {

                                if ("公文改错题" == qType)
                                {
                                    text = contentRegex2.Replace(text, "");
                                }
                                else
                                {
                                    text = contentRegex1.Replace(text, "");
                                }
                                qContent += text + "\\r\\n";
                            }

                            break;

                        default:

                            break;
                    }

                    #endregion

                    #region 判断是否为试题答案行

                    switch (qType)
                    {

                        case "单选题":
                        case "多选题":

                            // 单选题；多选题；
                            // 判断是否为备选答案行
                            if (optionalAnswerRegex.IsMatch(text))
                            {

                                qOptionalAnswer += text + " ";
                            }

                            break;

                        case "公文改错题":
                        case "计算题":
                        case "案例分析题":
                        case "问答题":

                            if (!isContent)
                            {
                                //TODO:记录试题答案
                                qModelAnswer += text + "\\r\\n";
                            }

                            break;

                        default:
                            break;
                    }

                    #endregion

                }

                if (qModelAnswer != "")
                {

                    // 格式化单选题/多选题的答案
                    if (qType == "单选题" || qType == "多选题")
                    {
                        qOptionalAnswer = FormatOptionalAnswer(qOptionalAnswer);
                        qModelAnswer = FormatModelAnswer(qModelAnswer);

                    }

                    qs.Add(new Question()
                    {
                        Q_Id = 0,
                        Q_Type = qType,
                        QC_Id = currentQCId,
                        Q_DifficultyCoefficient = difficultyCoefficient,
                        Q_Score = SetDefaultScore(qType, score),
                        Q_Content = qContent,
                        Q_OptionalAnswer = qOptionalAnswer,
                        Q_ModelAnswer = qModelAnswer,
                        Q_AddTime = now,
                        Q_Status = 4
                    });

                    difficultyCoefficient = 0;
                    score = 0;
                    qContent = "";
                    qOptionalAnswer = "";
                    qModelAnswer = "";
                    isContent = true;
                }

                foreach (var qc1 in qcs)
                {
                    olsEni.QuestionClassifies.Add(qc1);
                }

                olsEni.SaveChanges();

                // 获取试题初始编号
                qId = GetQId();
                duplicate = 0;
                foreach (var m1 in qs)
                {

                    tmpQs =
                        olsEni.Questions
                        .Where(m =>
                            m.Q_Content.Contains(m1.Q_Content)
                            && (m.Q_Status == (Byte)Status.Available 
                                || m.Q_Status == (Byte)Status.Cache))
                        .ToList();

                    existsFlag = false;
                    foreach (var m2 in tmpQs)
                    {
                        if (m2.Q_Content == m1.Q_Content)
                        {
                            existsFlag = true;
                            break;
                        }
                    }

                    if (!existsFlag)
                    {
                        m1.Q_Id = qId;
                        olsEni.Questions.Add(m1);
                        qId += 1;

                        // 标识数据错误
                        if (("单选题" == m1.Q_Type
                            || "多选题" == m1.Q_Type)
                            && ("{}" == m1.Q_ModelAnswer
                            || "[]" == m1.Q_ModelAnswer))
                        {
                            errorIds.Append(qId + ", ");
                        }

                        if ("判断题" == m1.Q_Type && "O" == m1.Q_ModelAnswer)
                        {
                            errorIds.Append(qId + ", ");
                        }

                    }
                    else
                    {
                        duplicate += 1;
                    }
                }

                if (duplicate > 0)
                {
                    dic["Message"] = "发现重复试题 " + duplicate + " 条\r\n";
                }

                if (olsEni.SaveChanges() == 0)
                {
                    dic["Message"] += ResponseMessage.SaveChangesError;
                    return dic;
                }

                if (errorIds.Length > 0)
                {
                    dic["Message"] += "试题模板数据存在错误（" + errorIds.Remove(errorIds.Length - 2, 2).ToString() + "）";
                }

                dic["Status"] = "1";
                return dic;
            }
            catch (Exception ex)
            {
                dic["Message"] = StaticHelper.GetExceptionMessageAndRecord(ex);
                return dic;
            }
        }

        private Int32 SetDefaultScore(String qType, Int32 score)
        {
            if (0 != score)
            {
                return score;
            }

            // 暂时禁用，使用数据库触发器设置，防止后期变更频繁
            /*switch (qType)
            {
                case "单选题":
                    score = 5;
                    break;
                case "多选题":
                    score = 8;
                    break;
                case "判断题":
                    score = 5;
                    break;
                case "公文改错题":
                    score = 10;
                    break;
                case "计算题":
                    score = 20;
                    break;
                case "案例分析题":
                    score = 25;
                    break;
                case "问答题":
                    score = 15;
                    break;
                default:
                    score = 0;
                    break;
            }*/

            return score;
        }

        private String FormatOptionalAnswer(String qOptionalAnswer)
        {

            Regex spaceRegex, dotRegex, suffixRegex, formatRegex;
            String[] qoas;
            Int32 count;

            spaceRegex = new Regex(@"\s+");
            dotRegex = new Regex(@"\s*[\.．、]+\s*");
            suffixRegex = new Regex(", \"$");
            formatRegex = new Regex("^(\"[a-zA-Z]{1}\":\"[^:\"]*\"){1}$");

            qOptionalAnswer = qOptionalAnswer.Trim();
            qOptionalAnswer = dotRegex.Replace(qOptionalAnswer, "\":\"");
            qOptionalAnswer = spaceRegex.Replace(qOptionalAnswer, "\",\"");
            qOptionalAnswer = "\"" + qOptionalAnswer + "\"";

            count = 0;
            qoas = qOptionalAnswer.Split(',');
            foreach (String qoa in qoas)
            {
                if (formatRegex.IsMatch(qoa))
                {
                    count += qoa.Length;
                }
            }

            count = count + qoas.Length - 1;

            // 格式化后的字符串不合符规则
            if (count != qOptionalAnswer.Length)
            {
                qOptionalAnswer = "";
            }

            qOptionalAnswer = "{" + qOptionalAnswer;
            qOptionalAnswer = qOptionalAnswer + "}";

            return qOptionalAnswer;
        }

        private String FormatModelAnswer(String qModelAnswer)
        {

            Regex spaceRegex;
            Char[] ary1;

            spaceRegex = new Regex(@"\s+");
            qModelAnswer = spaceRegex.Replace(qModelAnswer, "");

            ary1 = qModelAnswer.ToCharArray();

            return JsonConvert.SerializeObject(ary1);

        }

        /*private String text, qType, qClassify, qContent, qOptionalAnswer, qModelAnswer;
        private Boolean formatFlag, isContent;
        private Byte difficultyCoefficient;
        private Int32 score;
        private StringBuilder errorIds;
        private List<Question> readyQs;

        public Dictionary<String, String> ImportDocx(String filePath)
        {

            Dictionary<String, String> dic;

            dic = new Dictionary<String, String>();
            dic.Add("Status", "0");
            dic.Add("Data", "");
            dic.Add("Message", "");

            try
            {

                List<DocxParagraph> docxPara;
                const String qTypes = "单选题；多选题；判断题；公文改错题；计算题；案例分析题；问答题；";
                DateTime now;
                Regex typeRegex, contentRegex1, contentRegex2, optionalAnswerRegex, modelAnswerRegex,
                    difficultyCoefficientRegex, scoreRegex, digitRegex;
                Int32 i1, i2, len, qId, qcId;
                List<QuestionClassify> qcs;
                QuestionClassify classify;

                formatFlag = true;
                errorIds = new StringBuilder();

                docxPara = OpenXmlDocHelper.GetDocxParagraphs(filePath);

                now = DateTime.Now;

                typeRegex = new Regex(@"^题型[:：]{1}");
                contentRegex1 = new Regex(@"^\s*\d+[\.．、]"); // 示例：1.
                contentRegex2 = new Regex(@"^\s*\(.+\)|^\s*（.+）"); // 示例：(一) （一）
                optionalAnswerRegex = new Regex(@"^\s*[a-zA-Z]{1}[\.．、]{1}"); // 示例：A. B. C.
                modelAnswerRegex = new Regex(@"^\s*((答案|参考答案){1}[:：]{1})|【答】");
                difficultyCoefficientRegex = new Regex(@"^难度系数[：:]{1}\d{1}");
                scoreRegex = new Regex(@"^分数[：:]{1}\d+$");
                digitRegex = new Regex(@"\d+");

                qType = "";
                qClassify = "";
                qContent = "";
                qOptionalAnswer = "";
                qModelAnswer = "";
                isContent = true;

                readyQs = new List<Question>();
                qcs = new List<QuestionClassify>();

                // 获取数据编号
                qId = GetQId();
                qcId = GetQCId();

                difficultyCoefficient = 0;
                score = 0;

                foreach (var para in docxPara)
                {

                    text = para.Text;

                    #region 添加试题数据

                    switch (qType)
                    {
                        case "单选题":
                        case "多选题":

                            if (qModelAnswer != "")
                            {
                                // 格式化单选题/多选题的答案
                                qOptionalAnswer = FormatOptionalAnswer(qOptionalAnswer);
                                qModelAnswer = FormatModelAnswer(qModelAnswer);

                                AddQuestion(qId, qcId);
                            }
                            break;
                        case "判断题":
                        case "计算题":
                        case "案例分析题":
                        case "问答题":

                            if ((contentRegex1.IsMatch(text) || typeRegex.IsMatch(text))
                                && qModelAnswer != "")
                            {
                                AddQuestion(qId, qcId);
                            }

                            break;

                        case "公文改错题":

                            if ((contentRegex2.IsMatch(text) || typeRegex.IsMatch(text))
                                && qModelAnswer != "")
                            {
                                AddQuestion(qId, qcId);
                            }

                            break;

                        default:
                            break;
                    }
                    #endregion

                    #region 判断是否为分类行

                    // 此行为分类行
                    if (text.IndexOf("分类：") == 0)
                    {
                        //TODO:添加分类数据，记录分类编号
                        qClassify = text.Substring(3);

                        // 判断分类是否存在
                        classify = olsEni.QuestionClassifies.SingleOrDefault(model => model.QC_Name == qClassify);

                        // 如果不存在，则新增
                        if (null == classify)
                        {

                            qcs.Add(new QuestionClassify()
                            {
                                QC_Id = qcId,
                                QC_Name = qClassify,
                                QC_Level = "000" + qcId.ToString(),
                                QC_AddTime = now,
                                QC_Status = 4
                            });
                            qcId += 1;
                        }
                        else
                        {
                            qcId = classify.QC_Id;
                        }

                        continue;
                    }

                    #endregion

                    #region 判断是否为题型行

                    // 此行为题型行
                    if (typeRegex.IsMatch(text))
                    {

                        qType = text.Substring(3);
                        qType = qType.Replace("单项选择题", "单选题");
                        qType = qType.Replace("多项选择题", "多选题");

                        if (qTypes.IndexOf(qType) == -1)
                        {
                            //TODO:返回，提示“当前题型不支持导入”
                            dic["Message"] = "题型“" + qType + "”不支持导入。";
                            return dic;
                        }

                        continue;
                    }

                    #endregion

                    #region 判断是否为难度系数行

                    if (difficultyCoefficientRegex.IsMatch(text))
                    {
                        difficultyCoefficient = Convert.ToByte(digitRegex.Match(text).Value);
                        continue;
                    }

                    #endregion

                    #region 判断是否为分数行

                    if (scoreRegex.IsMatch(text))
                    {
                        score = Convert.ToInt32(digitRegex.Match(text).Value);
                        continue;
                    }

                    #endregion

                    #region 判断是否为试题内容行

                    //TODO:记录试题内容
                    switch (qType)
                    {
                        case "单选题":
                        case "多选题":
                        case "判断题":

                            if (contentRegex1.IsMatch(text))
                            {

                                // 提取标准答案
                                text = contentRegex1.Replace(text, "");
                                qContent = text;
                                qContent = qContent.Replace("（", "(");
                                qContent = qContent.Replace("）", ")");

                                i1 = qContent.LastIndexOf("(");
                                i2 = qContent.LastIndexOf(")");

                                if (i1 == -1 || i2 == -1)
                                {
                                    //TODO:返回提示格式错误
                                    dic["Message"] = "题型格式有误。";
                                    return dic;
                                }

                                len = i2 - i1 - 1;
                                qModelAnswer = qContent.Substring(i1 + 1, len);
                                if (qModelAnswer != "")
                                {
                                    qContent = qContent.Replace(qModelAnswer, "  ");
                                    qModelAnswer = qModelAnswer.Trim();
                                }
                                else // 避免模板中没有设置答案时不添加试题
                                {
                                    qModelAnswer = " ";
                                }

                                continue;

                            }

                            break;

                        case "公文改错题":
                        case "计算题":
                        case "案例分析题":
                        case "问答题":

                            // 公文改错题；计算题；案例分析题；问答题；
                            // 判断是否为标准答案行
                            if (modelAnswerRegex.IsMatch(text))
                            {

                                isContent = false;

                                text = modelAnswerRegex.Replace(text, "");
                            }

                            if (isContent)
                            {

                                if ("公文改错题" == qType)
                                {
                                    text = contentRegex2.Replace(text, "");
                                }
                                else
                                {
                                    text = contentRegex1.Replace(text, "");
                                }
                                qContent += text + "\\r\\n";
                            }

                            break;

                        default:

                            break;
                    }

                    #endregion

                    #region 判断是否为试题答案行

                    switch (qType)
                    {

                        case "单选题":
                        case "多选题":

                            // 单选题；多选题；
                            // 判断是否为备选答案行
                            if (optionalAnswerRegex.IsMatch(text))
                            {

                                qOptionalAnswer += text + " ";
                            }

                            break;

                        case "公文改错题":
                        case "计算题":
                        case "案例分析题":
                        case "问答题":

                            if (!isContent)
                            {
                                //TODO:记录试题答案
                                qModelAnswer += text + "\\r\\n";
                            }

                            break;

                        default:
                            break;
                    }

                    #endregion

                }

                AddQuestion(qId, qcId);

                foreach (var qc in qcs)
                {
                    olsEni.QuestionClassifies.Add(qc);
                }

                olsEni.SaveChanges();

                foreach (var model in readyQs)
                {
                    olsEni.Questions.Add(model);
                }

                olsEni.SaveChanges();


                dic["Status"] = "1";

                if (formatFlag)
                {
                    dic["Message"] = "试题模板数据存在错误（" + errorIds.Remove(errorIds.Length - 2, 2).ToString() + "）。";
                }

                return dic;
            }
            catch (Exception ex)
            {
                dic["Message"] = StaticHelper.GetExceptionMessageAndRecord(ex);
                return dic;
            }
        }

        private void AddQuestion(Int32 qId, Int32 qcId)
        {

            qId += 1;

            readyQs.Add(new Question()
            {
                Q_Id = qId,
                Q_Type = qType,
                QC_Id = qcId,
                Q_DifficultyCoefficient = difficultyCoefficient,
                Q_Score = SetDefaultScore(qType, score),
                Q_Content = qContent,
                Q_OptionalAnswer = qOptionalAnswer,
                Q_ModelAnswer = qModelAnswer,
                Q_AddTime = now,
                Q_Status = 4
            });

            // 标识数据错误
            if (qOptionalAnswer == "{}" || qModelAnswer == "[]")
            {
                formatFlag = true;
                errorIds.Append(qId + ", ");
            }

            difficultyCoefficient = 0;
            score = 0;
            qContent = "";
            qOptionalAnswer = "";
            qModelAnswer = "";
            isContent = true;
        }*/

        public DataTablesResponse ListDataTablesAjax(DataTablesRequest dtRequest, Int32 qcId)
        {

            DataTablesResponse dtResponse;
            QuestionClassify qc;
            UModel<Question> umodel;
            List<SqlParameter> sps;
            List<Question> ms;

            umodel = new UModel<Question>(dtRequest, "Questions", "Q_Id");

            sps = new List<SqlParameter>();
            if (0 != qcId)
            {
                sps.Add(new SqlParameter("@QC_Id", qcId));
            }

            dtResponse = umodel.GetList(sps, "Q_Status", new String[] { "QC_Name" });

            ms = (List<Question>)dtResponse.data;
            foreach (var m1 in ms)
            {

                qc = olsEni.QuestionClassifies.SingleOrDefault(m => m.QC_Id == m1.QC_Id);
                if (null == qc)
                {
                    m1.QC_Name = "";
                    continue;
                }

                m1.QC_Name = qc.QC_Name;
            }

            return dtResponse;
        }

        public List<SelectListItem> GetTypeList(String currentValue)
        {

            List<SelectListItem> items;

            items = new List<SelectListItem>()
            {
                new SelectListItem(){ Text = "[未设置]", Value = ""},
                new SelectListItem(){ Text = "单选题", Value = "单选题"},
                new SelectListItem(){ Text = "多选题", Value = "多选题"},
                new SelectListItem(){ Text = "判断题", Value = "判断题"},
                new SelectListItem(){ Text = "公文改错题", Value = "公文改错题"},
                new SelectListItem(){ Text = "计算题", Value = "计算题"},
                new SelectListItem(){ Text = "案例分析题", Value = "案例分析题"},
                new SelectListItem(){ Text = "问答题", Value = "问答题"}
            };

            foreach (var i in items)
            {
                if (i.Value == currentValue)
                {
                    i.Selected = true;
                }
            }

            return items;
        }

        public List<SelectListItem> GetClassifyList(Int32 currentValue)
        {

            List<SelectListItem> list;

            // 不能只获取正常状态的记录，因为编辑试题时，其分类可能为“缓存”状态。
            var items = olsEni.QuestionClassifies
                .Select(model => new { model.QC_Name, model.QC_Id });

            list = new List<SelectListItem>();
            list.Add(new SelectListItem() { Text = "[未设置]", Value = "" });

            foreach (var i in items)
            {
                list.Add(new SelectListItem
                {
                    Text = i.QC_Name,
                    Value = i.QC_Id.ToString(),
                    Selected = i.QC_Id == currentValue ? true : false
                });
            }

            return list;
        }

        public List<SelectListItem> GetClassifyList(Byte status, Int32 currentValue)
        {

            List<SelectListItem> list;

            // 获取相应状态的分类
            var items = olsEni.QuestionClassifies
                .Where(m=>m.QC_Status == status)
                .Select(m => new { m.QC_Name, m.QC_Id });

            list = new List<SelectListItem>();
            list.Add(new SelectListItem() { Text = "[未设置]", Value = "" });

            foreach (var i in items)
            {
                list.Add(new SelectListItem
                {
                    Text = i.QC_Name,
                    Value = i.QC_Id.ToString(),
                    Selected = i.QC_Id == currentValue ? true : false
                });
            }

            return list;
        }

        public Question GetNew()
        {

            Question model;

            model = new Question()
            {
                Q_Id = 0,
                Q_Type = "",
                QC_Id = 0,
                Q_Content = "",
                Q_OptionalAnswer = "",
                Q_ModelAnswer = "",
                Q_DifficultyCoefficient = 0,
                Q_Score = 0,
                Q_Remark = "",
                Q_AddTime = DateTime.Now,
                Q_Status = (Byte)Status.Available
            };

            return model;
        }

        public Question Get(Int32 id)
        {
            Question model;

            model = olsEni.Questions.SingleOrDefault(m => m.Q_Id == id);

            if (null == model)
            {
                throw new NotImplementedException();
            }

            return model;
        }

        public Boolean Create(Question model)
        {
            try
            {

                Int32 id;

                id = GetQId();

                model.Q_Id = id;
                olsEni.Questions.Add(model);
                olsEni.SaveChanges();

                return true;
            }
            catch (Exception ex)
            {
                StaticHelper.RecordSystemLog(ex);
                return false;
            }
        }

        public Boolean Edit(Question model)
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
                Question q;

                q = olsEni.Questions.SingleOrDefault(m => m.Q_Id == id);

                if (null == q)
                {
                    resJson.message = "数据不存在！";
                    return resJson;
                }

                ResumeClassify(q.QC_Id, status);

                q.Q_Status = (Byte)status;
                olsEni.Entry(q).State = EntityState.Modified;
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

        private void ResumeClassify(Int32 qcId, Status status)
        {

            QuestionClassify qc;

            // 恢复试题时，如果分类状态为“回收”，则设为“正常”
            if (Status.Available == status)
            {
                qc = 
                    olsEni.QuestionClassifies
                    .SingleOrDefault(m => 
                        m.QC_Id == qcId 
                        && m.QC_Status == (Byte)Status.Recycle);
                if (qc != null && qc.QC_Status != (Byte)status)
                {
                    qc.QC_Status = (Byte)status;
                }
            }
        }

        public ResponseJson Recycle(String ids)
        {

            return SetStatus(ids, Status.Recycle);
        }

        public ResponseJson Resume(String ids)
        {

            return SetStatus(ids, Status.Available);
        }

        public ResponseJson Delete(String ids)
        {

            return SetStatus(ids, Status.Delete);
        }

        public ResponseJson SetStatus(String ids, Status status)
        {

            ResponseJson resJson;

            resJson = new ResponseJson();

            try
            {
                Int32 id;
                Question q;
                String[] ids1;

                ids1 = ids.Split(',');

                foreach (var id1 in ids1)
                {

                    id = Convert.ToInt32(id1);
                    q = olsEni.Questions.SingleOrDefault(m => m.Q_Id == id);
                    if (null != q)
                    {
                        q.Q_Status = (Byte)status;
                        ResumeClassify(q.QC_Id, status);
                    }
                }
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

        public ResponseJson SetDifficultyCoefficient(int id, byte coefficient)
        {

            ResponseJson resJson;

            resJson = new ResponseJson();

            try
            {
                Question model;

                model = olsEni.Questions.SingleOrDefault(m => m.Q_Id == id);

                if (null == model)
                {
                    resJson.message = "数据不存在！";
                    return resJson;
                }

                model.Q_DifficultyCoefficient = (Byte)coefficient;
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

        public ResponseJson SetScore(int id, int score)
        {

            ResponseJson resJson;

            resJson = new ResponseJson();

            try
            {
                Question model;

                model = olsEni.Questions.SingleOrDefault(m => m.Q_Id == id);

                if (null == model)
                {
                    resJson.message = "数据不存在！";
                    return resJson;
                }

                model.Q_Score = score;
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

        public ResponseJson CacheImport()
        {

            ResponseJson resJson;

            resJson = new ResponseJson();

            try
            {

                List<Question> qs;
                Boolean errorFlag;
                List<QuestionClassify> qcs;
                String modelAnswer;

                errorFlag = false;

                qs = olsEni.Questions.Where(m => m.Q_Status == (Byte)Status.Cache).ToList();
                foreach (var q in qs)
                {

                    modelAnswer = q.Q_ModelAnswer.Trim();

                    if (("单选题" == q.Q_Type
                        || "多选题" == q.Q_Type)
                        && ("{}" == q.Q_OptionalAnswer
                        || "[]" == modelAnswer))
                    {
                        errorFlag = true;
                        continue;
                    }

                    if ("判断题" == q.Q_Type && "O" == modelAnswer)
                    {
                        errorFlag = true;
                        continue;
                    }

                    q.Q_Status = (Byte)Status.Available;
                    olsEni.Entry(q).State = EntityState.Modified;
                }

                if (olsEni.SaveChanges() == 0)
                {
                    resJson.status = ResponseStatus.Error;
                    resJson.message = "缓存导入失败。";
                    return resJson;
                }

                resJson.status = ResponseStatus.Success;
                if (errorFlag)
                {
                    resJson.message = "未导入部分存在错误的试题模板数据。";
                }

                // 设置分类状态
                qcs = olsEni.QuestionClassifies.Where(m => m.QC_Status == (Byte)Status.Cache).ToList();
                foreach (var qc in qcs)
                {
                    if (olsEni.Questions.Where(m => m.QC_Id == qc.QC_Id).Count() > 0)
                    {
                        qc.QC_Status = (Byte)Status.Available;
                        olsEni.Entry(qc).State = EntityState.Modified;
                    }
                }
                if (olsEni.SaveChanges() == 0)
                {
                    //resJson.status = ResponseStatus.Error;
                    //resJson.message = "设置分类状态失败。";
                    //return resJson;
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

        internal ResponseJson CacheClear()
        {

            ResponseJson resJson;

            resJson = new ResponseJson();

            try
            {

                List<Question> qs;
                List<QuestionClassify> qcs;

                qs = olsEni.Questions.Where(m => m.Q_Status == (Byte)Status.Cache).ToList();
                foreach (var q in qs)
                {
                    olsEni.Entry(q).State = EntityState.Deleted;
                }

                if (olsEni.SaveChanges() == 0)
                {
                    resJson.status = ResponseStatus.Error;
                    resJson.message = "缓存清除失败。";
                    return resJson;
                }

                // 获取状态为“缓存”的分类
                // 状态为“缓存”的分类中没有“正常”的试题，所以，如果其中仍存在试题，状态只可能是“回收”和“删除”两种类型
                qcs = olsEni.QuestionClassifies.Where(m => m.QC_Status == (Byte)Status.Cache).ToList();
                foreach (var qc in qcs)
                {
                    if (olsEni.Questions.Where(m => m.QC_Id == qc.QC_Id).Count() == 0)
                    {
                        olsEni.Entry(qc).State = EntityState.Deleted;
                    }
                    // 如果所有试题状态为“删除”，则将分类状态也设为“删除”
                    else if (olsEni.Questions.Where(m => m.QC_Id == qc.QC_Id).Count() == olsEni.Questions.Where(m => m.QC_Id == qc.QC_Id && m.Q_Status == (Byte)Status.Delete).Count())
                    {
                        qc.QC_Status = (Byte)Status.Delete;
                    }
                    // 否则设为“回收”
                    else
                    {
                        qc.QC_Status = (Byte)Status.Recycle;
                    }
                }
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
    }
}