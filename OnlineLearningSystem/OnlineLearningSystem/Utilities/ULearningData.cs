using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using OnlineLearningSystem.Models;

namespace OnlineLearningSystem.Utilities
{
    public class ULearningData : Utility
    {

        public DataTablesResponse ListDataTablesAjax(DataTablesRequest dtRequest)
        {

            DataTablesResponse dtResponse;
            UModel<LearningData> umodel;

            umodel = new UModel<LearningData>(dtRequest, "LearningDatas", "LD_Id");
            dtResponse = umodel.GetList("LD_Status", "LD_Sort");

            return dtResponse;
        }

        public LearningData GetNew()
        {

            LearningData model;

            model = new LearningData()
            {
                LD_Title = "",
                LD_Content = "",
                LD_Remark = "",
                LD_AddTime = DateTime.Now,
                LD_Status = (Byte)Status.Available
            };

            return model;
        }

        public LearningData Get(Int32 id)
        {
            LearningData model;

            model = olsEni.LearningDatas.Single(m => m.LD_Id == id && m.LD_Status == (Byte)Status.Available);

            return model;
        }

        public Boolean Create(LearningData model)
        {
            try
            {

                Int32 id;

                id = GetLDId();

                model.LD_Id = id;
                model.LD_Sort = id;
                olsEni.LearningDatas.Add(model);
                olsEni.SaveChanges();

                return true;
            }
            catch (Exception ex)
            {
                StaticHelper.RecordSystemLog(ex);
                return false;
            }
        }

        public Boolean Edit(LearningData model)
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
                LearningData model;

                model = olsEni.LearningDatas.SingleOrDefault(m => m.LD_Id == id);

                if (null == model)
                {
                    resJson.message = "数据不存在！";
                    return resJson;
                }

                model.LD_Status = (Byte)status;
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

        public Boolean DuplicateName(Int32 id, String name)
        {

            try
            {

                Int32 count;

                count = olsEni.LearningDatas.Where(m => m.LD_Id != id && m.LD_Title == name).Count();

                if (count > 0)
                {
                    return true;
                }

                return false;
            }
            catch (Exception ex)
            {
                StaticHelper.RecordSystemLog(ex);
                return false;
            }
        }

        public ResponseJson Sort(Int32 originId, Byte sortFlag)
        {

            ResponseJson resJson;

            resJson = new ResponseJson();

            try
            {

                String name;
                Double originSort, destSort;
                LearningData originModel, destModel, adjustModel;
                LearningData[] modelAry;
                List<LearningData> us;

                name = "资料";
                modelAry = new LearningData[2];

                originModel = olsEni.LearningDatas.Single(m => m.LD_Id == originId);
                originSort = originModel.LD_Sort;

                // 置顶
                if (1 == sortFlag)
                {

                    destSort = olsEni.LearningDatas.Min(m => m.LD_Sort);
                    destModel = olsEni.LearningDatas.Single(m => m.LD_Sort == destSort);

                    if (destSort == originSort)
                    {
                        resJson.status = ResponseStatus.Error;
                        resJson.message = "该" + name + "已置顶。";
                        return resJson;
                    }

                    originSort = destSort - 1;
                    originModel.LD_Sort = originSort;
                }
                else if (2 == sortFlag)
                {

                    us = olsEni.LearningDatas
                        .Where(m => m.LD_Sort < originSort)
                        .OrderByDescending(m => m.LD_Sort).Take(2).ToList();

                    if (us.Count == 0)
                    {
                        resJson.status = ResponseStatus.Error;
                        resJson.message = "该" + name + "已处于顶部。";
                        return resJson;
                    }
                    else if (us.Count == 1)
                    {
                        destModel = us[0];
                        originSort = destModel.LD_Sort;
                        destSort = originModel.LD_Sort;
                        originModel.LD_Sort = originSort;
                        destModel.LD_Sort = destSort;
                    }
                    else
                    {
                        destModel = us[1];
                        destSort = destModel.LD_Sort;
                        originSort = Math.Round(destSort + 0.00001, 5, MidpointRounding.AwayFromZero);
                        originModel.LD_Sort = originSort;
                    }

                }
                else// if (3 == sortFlag)
                {

                    us = olsEni.LearningDatas
                        .Where(m => m.LD_Sort > originSort)
                        .OrderBy(m => m.LD_Sort).Take(1).ToList();

                    if (us.Count == 0)
                    {
                        resJson.status = ResponseStatus.Error;
                        resJson.message = "该" + name + "已处于底部。";
                        return resJson;
                    }

                    destModel = us[0];
                    destSort = destModel.LD_Sort;

                    originSort = Math.Round(destSort + 0.00001, 5, MidpointRounding.AwayFromZero);
                    originModel.LD_Sort = originSort;
                }

                adjustModel = olsEni.LearningDatas.SingleOrDefault(m => m.LD_Sort == originSort);
                if (adjustModel != null)
                {
                    adjustModel.LD_Sort = Math.Round(originSort + 0.00001, 5, MidpointRounding.AwayFromZero);
                }

                if (0 == olsEni.SaveChanges())
                {
                    resJson.status = ResponseStatus.Error;
                    resJson.message = ResponseMessage.SaveChangesError;
                    return resJson;
                }

                modelAry[0] = originModel;
                modelAry[1] = destModel;

                resJson.addition = modelAry;
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

        internal List<SelectListItem> GetCategoryList(Int32 currentValue)
        {

            List<SelectListItem> list;

            var items = olsEni.LearningDataCategories.Where(m=>m.LDC_Status == (Byte)Status.Available).Select(model => new { model.LDC_Name, model.LDC_Id });

            list = new List<SelectListItem>();
            list.Add(new SelectListItem() { Text = "[未设置]", Value = "" });

            foreach (var i in items)
            {
                list.Add(new SelectListItem
                {
                    Text = i.LDC_Name,
                    Value = i.LDC_Id.ToString(),
                    Selected = i.LDC_Id == currentValue ? true : false
                });
            }

            return list;
        }
    }
}