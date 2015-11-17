using System;
using System.Collections.Generic;
using System.Linq;
using System.Data;
using System.Web;
using System.Web.Mvc;
using OnlineLearningSystem.Models;

using System.Text.RegularExpressions;
using Newtonsoft.Json;

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
                Int32 i1, i2, len, rowCount, id, id1;
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
                id = 0 == rowCount ? 0 : olsEni.Questions.Max(model => model.Q_AutoId);
                rowCount = olsEni.QuestionClassifies.Count();
                id1 = 0 == rowCount ? 0 : olsEni.QuestionClassifies.Max(model => model.QC_AutoId);

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

                                // 格式化单选题/多选题的答案
                                if (qType == "单选题" || qType == "多选题")
                                {
                                    qOptionalAnswer = FormatOptionalAnswer(qOptionalAnswer);
                                    qModelAnswer = FormatModelAnswer(qModelAnswer);
                                }

                                id += 1;

                                qs.Add(new Question()
                                {
                                    Q_Id = id,
                                    Q_Type = qType,
                                    QC_Id = id1,
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

                                id += 1;

                                qs.Add(new Question()
                                {
                                    Q_Id = id,
                                    Q_Type = qType,
                                    QC_Id = id1,
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
                        classify = olsEni.QuestionClassifies.SingleOrDefault(model => model.QC_Name == qClassify);

                        // 如果不存在，则新增
                        if (null == classify)
                        {

                            id1 += 1;

                            qcs.Add(new QuestionClassify()
                            {
                                QC_Id = id1,
                                QC_Name = qClassify,
                                QC_Level = "000" + id1.ToString(),
                                QC_AddTime = now,
                                QC_Status = 1
                            });
                        }
                        else
                        {
                            id1 = classify.QC_Id;
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

                    // 格式化单选题/多选题的答案
                    if (qType == "单选题" || qType == "多选题")
                    {
                        qOptionalAnswer = FormatOptionalAnswer(qOptionalAnswer);
                        qModelAnswer = FormatModelAnswer(qModelAnswer);
                    }

                    id += 1;

                    qs.Add(new Question()
                    {
                        Q_Id = id,
                        Q_Type = qType,
                        QC_Id = id1,
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

                foreach (var model in qs)
                {
                    olsEni.Questions.Add(model);
                }

                olsEni.SaveChanges();


                dic["Status"] = "1";

                return dic;
            }
            catch (Exception ex)
            {

                dic["Message"] = StaticHelper.GetExceptionMessage(ex);

                return dic;
            }
        }

        private String FormatOptionalAnswer(String qOptionalAnswer)
        {

            Regex spaceRegex, dotRegex, suffixRegex;

            spaceRegex = new Regex(@"\s+");
            dotRegex = new Regex(@"(\.|．)\s*");
            suffixRegex = new Regex(", \"$");

            qOptionalAnswer = qOptionalAnswer.Trim();
            qOptionalAnswer = dotRegex.Replace(qOptionalAnswer, "\":\"");
            qOptionalAnswer = spaceRegex.Replace(qOptionalAnswer, "\", \"");
            //if (suffixRegex.IsMatch(qOptionalAnswer))
            //{
            //    qOptionalAnswer = qOptionalAnswer.Substring(0, qOptionalAnswer.Length - 3);
            //}
            qOptionalAnswer = "{\"" + qOptionalAnswer;
            qOptionalAnswer = qOptionalAnswer + "\"}";

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

        public DataTablesResponse ListDataTablesAjax(DataTablesRequest dtRequest)
        {

            DataTablesResponse dtResponse;
            Int32 recordsTotal, recordsFiltered;
            String whereSql, orderColumn, classfyName;
            List<Question> ms;


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

            var tmpMs =
                olsEni
                .Questions
                .OrderBy(model => model.Q_Id)
                .Where(model =>
                    (model.Q_Type.Contains(dtRequest.SearchValue)
                    || model.Q_Content.Contains(dtRequest.SearchValue)
                    || model.Q_OptionalAnswer.Contains(dtRequest.SearchValue)
                    || model.Q_ModelAnswer.Contains(dtRequest.SearchValue))
                    && model.Q_Status != (Byte)Status.Delete)
                .Select(model => new
                {
                    Q_Id = model.Q_Id,
                    Q_Type = model.Q_Type,
                    Q_Classify = model.QC_Id,
                    Q_DifficultyCoefficient = model.Q_DifficultyCoefficient,
                    Q_Content = model.Q_Content,
                    Q_OptionalAnswer = model.Q_OptionalAnswer,
                    Q_AddTime = model.Q_AddTime,
                    Q_Status = model.Q_Status,
                    Q_Remark = model.Q_Remark
                })
                .ToList();

            // 获取分类名称
            ms = new List<Question>();

            foreach (var model in tmpMs)
            {

                classfyName = olsEni.QuestionClassifies.SingleOrDefault(m1 => m1.QC_Id == model.Q_Classify).QC_Name;

                ms.Add(new Question()
                {
                    Q_Id = model.Q_Id,
                    Q_Type = model.Q_Type,
                    QC_Id = model.Q_Classify,
                    QC_Name = classfyName,
                    Q_DifficultyCoefficient = model.Q_DifficultyCoefficient,
                    Q_Content = model.Q_Content,
                    Q_OptionalAnswer = model.Q_OptionalAnswer,
                    Q_Remark = model.Q_Remark,
                    Q_AddTime = model.Q_AddTime,
                    Q_Status = model.Q_Status
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

            var items = olsEni.QuestionClassifies.Where(m => m.QC_Status == (Byte)Status.Available).Select(model => new { model.QC_Name, model.QC_Id });

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

                Int32 rowCount;
                Int32 id;

                rowCount = olsEni.Questions.Count();
                id = 0 == rowCount ? 0 : olsEni.Questions.Max(m => m.Q_AutoId);

                model.Q_Id = id + 1;
                olsEni.Questions.Add(model);
                olsEni.SaveChanges();

                return true;
            }
            catch (Exception ex)
            {

                throw;
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
                Question model;

                model = olsEni.Questions.SingleOrDefault(m => m.Q_Id == id);

                if (null == model)
                {
                    resJson.message = "数据不存在！";
                    return resJson;
                }

                model.Q_Status = (Byte)status;
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
                resJson.message = StaticHelper.GetExceptionMessage(ex);
                return resJson;
            }
        }
    }
}