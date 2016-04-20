using System;
using System.Collections.Generic;
using System.Linq;
using System.Data;
using System.Web;
using System.Web.Mvc;
using OnlineLearningSystem.Models;

namespace OnlineLearningSystem.Utilities
{
    public class UDuty : Utility
    {
        public DataTablesResponse ListDataTablesAjax(DataTablesRequest dtRequest)
        {

            DataTablesResponse dtResponse;
            UModel<Duty> umodel;

            umodel = new UModel<Duty>(dtRequest, "Duties", "Du_Id");
            dtResponse = umodel.GetList("Du_Status", "Du_Sort");

            return dtResponse;
        }

        public Duty GetNew()
        {

            Duty model;

            model = new Duty()
            {
                Du_Name = "",
                Du_Remark = "",
                Du_AddTime = DateTime.Now,
                Du_Status = (Byte)Status.Available
            };

            return model;
        }

        public Duty Get(Int32 id)
        {
            Duty model;

            model = olsEni.Duties.Single(m => m.Du_Id == id && m.Du_Status == (Byte)Status.Available);

            return model;
        }

        public ResponseJson Create(Duty model)
        {

            ResponseJson resJson;

            resJson = new ResponseJson(ResponseStatus.Success, now);

            try
            {
                
                Int32 id;

                id = GetDuId();

                model.Du_Id = id;
                model.Du_Sort = id;
                olsEni.Duties.Add(model);
                olsEni.SaveChanges();

            }
            catch (Exception ex)
            {
                resJson.status = ResponseStatus.Error;
                resJson.message = ex.Message;
                resJson.detail = StaticHelper.GetExceptionMessageAndRecord(ex);
            }

            return resJson;
        }

        public Boolean Edit(Duty model)
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
                Duty model;
                List<User> us;

                model = olsEni.Duties.SingleOrDefault(m => m.Du_Id == id);

                if (null == model)
                {
                    resJson.message = "数据不存在！";
                    return resJson;
                }

                // 处理职务中的用户状态
                if (status != Status.Available)
                {
                    us = olsEni.Users.Where(m => m.Du_Id == model.Du_Id).ToList();
                    foreach (var u in us)
                    {
                        u.U_Status = (Byte)status;
                    }
                }

                model.Du_Status = (Byte)status;
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

                count = olsEni.Duties.Where(m => m.Du_Id != id && m.Du_Name == name).Count();

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
                Duty originModel, destModel, adjustModel;
                Duty[] modelAry;
                List<Duty> us;

                name = "职务";
                modelAry = new Duty[2];

                originModel = olsEni.Duties.Single(m => m.Du_Id == originId);
                originSort = originModel.Du_Sort;

                // 置顶
                if (1 == sortFlag)
                {

                    destSort = olsEni.Duties.Min(m => m.Du_Sort);
                    destModel = olsEni.Duties.Single(m => m.Du_Sort == destSort);

                    if (destSort == originSort)
                    {
                        resJson.status = ResponseStatus.Error;
                        resJson.message = "该" + name + "已置顶。";
                        return resJson;
                    }

                    originSort = destSort - 1;
                    originModel.Du_Sort = originSort;
                }
                else if (2 == sortFlag)
                {

                    us = olsEni.Duties
                        .Where(m => m.Du_Sort < originSort)
                        .OrderByDescending(m => m.Du_Sort).Take(2).ToList();

                    if (us.Count == 0)
                    {
                        resJson.status = ResponseStatus.Error;
                        resJson.message = "该" + name + "已处于顶部。";
                        return resJson;
                    }
                    else if (us.Count == 1)
                    {
                        destModel = us[0];
                        originSort = destModel.Du_Sort;
                        destSort = originModel.Du_Sort;
                        originModel.Du_Sort = originSort;
                        destModel.Du_Sort = destSort;
                    }
                    else
                    {
                        destModel = us[1];
                        destSort = destModel.Du_Sort;
                        originSort = Math.Round(destSort + 0.00001, 5, MidpointRounding.AwayFromZero);
                        originModel.Du_Sort = originSort;
                    }

                }
                else// if (3 == sortFlag)
                {

                    us = olsEni.Duties
                        .Where(m => m.Du_Sort > originSort)
                        .OrderBy(m => m.Du_Sort).Take(1).ToList();

                    if (us.Count == 0)
                    {
                        resJson.status = ResponseStatus.Error;
                        resJson.message = "该" + name + "已处于底部。";
                        return resJson;
                    }

                    destModel = us[0];
                    destSort = destModel.Du_Sort;

                    originSort = Math.Round(destSort + 0.00001, 5, MidpointRounding.AwayFromZero);
                    originModel.Du_Sort = originSort;
                }

                adjustModel = olsEni.Duties.SingleOrDefault(m => m.Du_Sort == originSort);
                if (adjustModel != null)
                {
                    adjustModel.Du_Sort = Math.Round(originSort + 0.00001, 5, MidpointRounding.AwayFromZero);
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