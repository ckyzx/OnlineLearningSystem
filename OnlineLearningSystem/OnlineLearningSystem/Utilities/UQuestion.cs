using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Text.RegularExpressions;
using OnlineLearningSystem.Models;
using System.Web.Mvc;
//using Newtonsoft.Json;

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
                Regex typeRegex, contentRegex1, contentRegex2, optionalAnswerRegex, modelAnswerRegex;
                String text, qType, qClassify, qContent, qOptionalAnswer, qModelAnswer;
                Int32 i1, i2, len, rowCount, qId, qcId;
                Boolean isContent;
                List<Question> qs;
                List<QuestionClassify> qcs;
                QuestionClassify classify;

                docxPara = OpenXmlHelper.GetDocxParagraphs(filePath);

                now = DateTime.Now;

                typeRegex = new Regex(@"^题型[:：]{1}");
                contentRegex1 = new Regex(@"^\s*\d+[\.．]");
                contentRegex2 = new Regex(@"^\s*\(.+\)|^\s*（.+）");
                optionalAnswerRegex = new Regex(@"^\s*[a-zA-Z]{1}[\.．]{1}");
                modelAnswerRegex = new Regex(@"^\s*答案：|^\s*答案:|^\s*【答】");

                qType = "";
                qClassify = "";
                qContent = "";
                qOptionalAnswer = "";
                qModelAnswer = "";
                isContent = true;

                qs = new List<Question>();
                qcs = new List<QuestionClassify>();

                // 获取数据编号
                rowCount = olsEni.Questions.Count();
                qId = 0 == rowCount ? 1 : olsEni.Questions.Max(m => m.Q_AutoId);
                rowCount = olsEni.QuestionClassifies.Count();
                qcId = 0 == rowCount ? 1 : olsEni.QuestionClassifies.Max(m => m.QC_AutoId);

                foreach (var para in docxPara)
                {

                    text = para.Text;

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

                                qId += 1;

                                qs.Add(new Question()
                                {
                                    Q_Id = qId,
                                    Q_Type = qType,
                                    Q_Classify = qcId,
                                    Q_Content = qContent,
                                    Q_OptionalAnswer = qOptionalAnswer,
                                    Q_ModelAnswer = qModelAnswer,
                                    Q_AddTime = now,
                                    Q_Status = 1
                                });

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

                                qId += 1;

                                qs.Add(new Question()
                                {
                                    Q_Id = qId,
                                    Q_Type = qType,
                                    Q_Classify = qcId,
                                    Q_Content = qContent,
                                    Q_OptionalAnswer = qOptionalAnswer,
                                    Q_ModelAnswer = qModelAnswer,
                                    Q_AddTime = now,
                                    Q_Status = 1
                                });

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
                        //TODO:添加分类数据，记录分类编号
                        qClassify = text.Substring(3);

                        // 判断分类是否存在
                        classify = olsEni.QuestionClassifies.SingleOrDefault(m => m.QC_Name == qClassify);

                        // 如果不存在，则新增
                        if (null == classify)
                        {

                            qcId += 1;

                            qcs.Add(new QuestionClassify()
                            {
                                QC_Id = qcId,
                                QC_Name = qClassify,
                                QC_AddTime = now,
                                QC_Status = 1
                            });
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

                    #region 判断是否为试题内容行

                    //TODO:记录试题内容
                    switch (qType)
                    {
                        case "单选题":
                        case "单项选择题":
                        case "多选题":
                        case "多项选择题":
                        case "判断题":

                            if (contentRegex1.IsMatch(text))
                            {

                                // 提取标准答案
                                text = contentRegex1.Replace(text, "");
                                qContent = text;
                                qContent = qContent.Replace("（", "(");
                                qContent = qContent.Replace("）", ")");

                                i1 = qContent.IndexOf("(");
                                i2 = qContent.IndexOf(")");

                                if (i1 == -1 || i2 == -1)
                                {
                                    //TODO:返回提示格式错误
                                    dic["Message"] = "题型格式有误。";
                                    return dic;
                                }

                                len = i2 - i1 - 1;
                                qModelAnswer = qContent.Substring(i1 + 1, len);
                                qContent = qContent.Replace(qModelAnswer, "  ");
                                qModelAnswer = qModelAnswer.Trim();

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

                    qId += 1;

                    qs.Add(new Question()
                    {
                        Q_Id = qId,
                        Q_Type = qType,
                        Q_Classify = qcId,
                        Q_Content = qContent,
                        Q_OptionalAnswer = qOptionalAnswer,
                        Q_ModelAnswer = qModelAnswer,
                        Q_AddTime = now,
                        Q_Status = 1
                    });

                    qContent = "";
                    qOptionalAnswer = "";
                    qModelAnswer = "";
                    isContent = true;
                }

                foreach (var qc in qcs)
                {
                    olsEni.QuestionClassifies.Add(qc);
                }

                olsEni.SaveChanges();

                foreach (var q in qs)
                {
                    olsEni.Questions.Add(q);
                }

                olsEni.SaveChanges();


                dic["Status"] = "1";

                return dic;
            }
            catch (Exception ex)
            {

                dic["Message"] = ex.Message;

                return dic;
            }
        }

        public DataTablesResponse ListDataTablesAjax(DataTablesRequest dtRequest)
        {

            DataTablesResponse dtResponse;
            Int32 recordsTotal, recordsFiltered;
            String whereSql, orderColumn, classfyName;
            List<Question> qs;


            dtResponse = new DataTablesResponse();

            dtResponse.draw = dtRequest.Draw;

            recordsTotal = olsEni.Questions.Count();
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

            var tmpQs =
                olsEni
                .Questions
                .Where(m => m.Q_Type.Contains(dtRequest.SearchValue))
                .Select(m => new
                {
                    Q_Id = m.Q_Id,
                    Q_Type = m.Q_Type,
                    Q_Classify = m.Q_Classify,
                    Q_DifficultyCoefficient = m.Q_DifficultyCoefficient,
                    Q_Content = m.Q_Content,
                    Q_OptionalAnswer = m.Q_OptionalAnswer,
                    Q_AddTime = m.Q_AddTime,
                    Q_Status = m.Q_Status,
                    Q_Remark = m.Q_Remark
                })
                .OrderBy(m => m.Q_Id)
                .ToList();

            // 获取分类名称
            qs = new List<Question>();

            foreach (var q in tmpQs)
            {

                classfyName = olsEni.QuestionClassifies.SingleOrDefault(m => m.QC_Id == q.Q_Classify).QC_Name;

                qs.Add(new Question()
                {
                    Q_Id = q.Q_Id,
                    Q_Type = q.Q_Type,
                    Q_Classify = q.Q_Classify,
                    Q_ClassifyName = classfyName,
                    Q_DifficultyCoefficient = q.Q_DifficultyCoefficient,
                    Q_Content = q.Q_Content,
                    Q_OptionalAnswer = q.Q_OptionalAnswer,
                    Q_AddTime = q.Q_AddTime,
                    Q_Status = q.Q_Status,
                    Q_Remark = q.Q_Remark
                });
            }

            tmpQs = null;

            recordsFiltered = qs.Count();
            dtResponse.recordsFiltered = recordsFiltered;

            if (-1 != dtRequest.Length)
            {
                qs =
                    qs
                    .Skip(dtRequest.Start).Take(dtRequest.Length)
                    .ToList();
            }

            dtResponse.data = qs;

            return dtResponse;
        }

        public Question GetNew()
        {

            Question q;

            q = new Question()
            {
                Q_Id = 0,
                Q_Type = "",
                Q_Classify = 0,
                Q_Content = "",
                Q_OptionalAnswer = "",
                Q_ModelAnswer = "",
                Q_DifficultyCoefficient = 0,
                Q_Remark = "",
                Q_AddTime = DateTime.Now,
                Q_Status = 1
            };

            return q;
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

            var items = olsEni.QuestionClassifies.Select(m => new { m.QC_Name, m.QC_Id });

            list = new List<SelectListItem>();
            list.Add(new SelectListItem() { Text = "[未设置]", Value = "" });

            foreach (var i in items)
            {
                list.Add(new SelectListItem { 
                    Text = i.QC_Name, 
                    Value = i.QC_Id.ToString(), 
                    Selected = i.QC_Id == currentValue ? true : false 
                });
            }

            return list;
        }

        public Boolean Create(Question q)
        {
            try
            {

                Int32 rowCount;
                Int32 qId;

                rowCount = olsEni.Questions.Count();
                qId = 0 == rowCount ? 0 : olsEni.Questions.Max(m => m.Q_AutoId);

                q.Q_Id = qId + 1;
                olsEni.Questions.Add(q);
                olsEni.SaveChanges();

                return true;
            }
            catch (Exception ex)
            {
                
                throw;
            }
        }
    }
}