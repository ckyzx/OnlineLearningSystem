using System;
using System.Collections.Generic;
using System.Linq;
using System.Data;
using System.Web;
using System.Web.Mvc;
using OnlineLearningSystem.Models;

namespace OnlineLearningSystem.Utilities
{
    public class ULearningDataCategory : Utility
    {

        public DataTablesResponse ListDataTablesAjax(DataTablesRequest dtRequest)
        {

            DataTablesResponse dtResponse;
            UModel<LearningDataCategory> umodel;

            umodel = new UModel<LearningDataCategory>(dtRequest, "LearningDataCategories", "LDC_Id");
            dtResponse = umodel.GetList("LDC_Status", "LDC_Sort");

            return dtResponse;
        }

        public LearningDataCategory GetNew()
        {

            LearningDataCategory model;

            model = new LearningDataCategory()
            {
                LDC_Name = "",
                LDC_Remark = "",
                LDC_AddTime = DateTime.Now,
                LDC_Status = (Byte)Status.Available
            };

            return model;
        }

        public LearningDataCategory Get(Int32 id)
        {
            LearningDataCategory model;

            model = olsEni.LearningDataCategories.Single(m => m.LDC_Id == id && m.LDC_Status == (Byte)Status.Available);

            return model;
        }

        public Boolean Create(LearningDataCategory model)
        {
            try
            {

                Int32 id;

                id = GetLDCId();

                model.LDC_Id = id;
                model.LDC_Sort = id;
                olsEni.LearningDataCategories.Add(model);
                olsEni.SaveChanges();

                return true;
            }
            catch (Exception ex)
            {
                StaticHelper.RecordSystemLog(ex);
                return false;
            }
        }

        public Boolean Edit(LearningDataCategory model)
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
                LearningDataCategory model;

                model = olsEni.LearningDataCategories.SingleOrDefault(m => m.LDC_Id == id);

                if (null == model)
                {
                    resJson.message = "数据不存在！";
                    return resJson;
                }

                model.LDC_Status = (Byte)status;
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

                count = olsEni.LearningDataCategories.Where(m => m.LDC_Id != id && m.LDC_Name == name).Count();

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
                LearningDataCategory originModel, destModel, adjustModel;
                LearningDataCategory[] modelAry;
                List<LearningDataCategory> us;

                name = "资料目录";
                modelAry = new LearningDataCategory[2];

                originModel = olsEni.LearningDataCategories.Single(m => m.LDC_Id == originId);
                originSort = originModel.LDC_Sort;

                // 置顶
                if (1 == sortFlag)
                {

                    destSort = olsEni.LearningDataCategories.Min(m => m.LDC_Sort);
                    destModel = olsEni.LearningDataCategories.Single(m => m.LDC_Sort == destSort);

                    if (destSort == originSort)
                    {
                        resJson.status = ResponseStatus.Error;
                        resJson.message = "该" + name + "已置顶。";
                        return resJson;
                    }

                    originSort = destSort - 1;
                    originModel.LDC_Sort = originSort;
                }
                else if (2 == sortFlag)
                {

                    us = olsEni.LearningDataCategories
                        .Where(m => m.LDC_Sort < originSort)
                        .OrderByDescending(m => m.LDC_Sort).Take(2).ToList();

                    if (us.Count == 0)
                    {
                        resJson.status = ResponseStatus.Error;
                        resJson.message = "该" + name + "已处于顶部。";
                        return resJson;
                    }
                    else if (us.Count == 1)
                    {
                        destModel = us[0];
                        originSort = destModel.LDC_Sort;
                        destSort = originModel.LDC_Sort;
                        originModel.LDC_Sort = originSort;
                        destModel.LDC_Sort = destSort;
                    }
                    else
                    {
                        destModel = us[1];
                        destSort = destModel.LDC_Sort;
                        originSort = Math.Round(destSort + 0.00001, 5, MidpointRounding.AwayFromZero);
                        originModel.LDC_Sort = originSort;
                    }

                }
                else// if (3 == sortFlag)
                {

                    us = olsEni.LearningDataCategories
                        .Where(m => m.LDC_Sort > originSort)
                        .OrderBy(m => m.LDC_Sort).Take(1).ToList();

                    if (us.Count == 0)
                    {
                        resJson.status = ResponseStatus.Error;
                        resJson.message = "该" + name + "已处于底部。";
                        return resJson;
                    }

                    destModel = us[0];
                    destSort = destModel.LDC_Sort;

                    originSort = Math.Round(destSort + 0.00001, 5, MidpointRounding.AwayFromZero);
                    originModel.LDC_Sort = originSort;
                }

                adjustModel = olsEni.LearningDataCategories.SingleOrDefault(m => m.LDC_Sort == originSort);
                if (adjustModel != null)
                {
                    adjustModel.LDC_Sort = Math.Round(originSort + 0.00001, 5, MidpointRounding.AwayFromZero);
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
                resJson.message = ex.Message;
                resJson.detail = StaticHelper.GetExceptionMessageAndRecord(ex);
                return resJson;
            }
        }
    }
}