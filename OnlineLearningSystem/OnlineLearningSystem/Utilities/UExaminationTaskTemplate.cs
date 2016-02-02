using System;
using System.Collections.Generic;
using System.Linq;
using System.Data;
using System.Web;
using System.Web.Mvc;
using OnlineLearningSystem.Models;

namespace OnlineLearningSystem.Utilities
{
    public class UExaminationTaskTemplate : Utility
    {

        public DataTablesResponse ListDataTablesAjax(DataTablesRequest dtRequest)
        {

            DataTablesResponse dtResponse;
            UModel<ExaminationTaskTemplate> umodel;

            umodel = new UModel<ExaminationTaskTemplate>(dtRequest, "ExaminationTaskTemplates", "ETT_Id");
            dtResponse = umodel.GetList("ETT_Status");

            return dtResponse;
        }

        public ExaminationTaskTemplate GetNew()
        {

            DateTime initDateTime;
            ExaminationTaskTemplate model;

            initDateTime = new DateTime(1970, 1, 1);

            model = new ExaminationTaskTemplate()
            {
                ETT_Id = 0,
                ETT_Name = "",
                ETT_ParticipatingDepartment = "[]",
                ETT_Attendee = "[]",
                ETT_StatisticType = (Byte)StatisticType.Unset,
                ETT_TotalScore = 100,
                ETT_TotalNumber = 10,
                ETT_AutoType = (Byte)AutoType.Manual,
                ETT_AutoClassifies = "[]",
                ETT_AutoRatio = "[]",
                ETT_StartTime = initDateTime,
                ETT_EndTime = initDateTime,
                ETT_TimeSpan = 30,
                ETT_Remark = "",
                ETT_AddTime = now,
                ETT_Status = (Byte)Status.Available
            };

            return model;
        }

        public ExaminationTaskTemplate Get(Int32 id)
        {
            ExaminationTaskTemplate model;

            model = olsEni.ExaminationTaskTemplates.SingleOrDefault(m => m.ETT_Id == id);

            if (null == model)
            {
                throw new NotImplementedException();
            }

            return model;
        }

        public Boolean Create(ExaminationTaskTemplate model)
        {
            try
            {

                Int32 id;

                id = GetETTId();

                model.ETT_Id = id;
                olsEni.ExaminationTaskTemplates.Add(model);
                olsEni.SaveChanges();

                return true;
            }
            catch (Exception ex)
            {

                throw;
            }
        }

        public Boolean Edit(ExaminationTaskTemplate model)
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
                ExaminationTaskTemplate model;

                model = olsEni.ExaminationTaskTemplates.SingleOrDefault(m => m.ETT_Id == id);

                if (null == model)
                {
                    resJson.message = "数据不存在！";
                    return resJson;
                }

                model.ETT_Status = (Byte)status;
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

        public Boolean DuplicateName(Int32 ettId, String name)
        {
            try
            {

                Int32 count;

                count = olsEni.ExaminationTaskTemplates.Where(m => m.ETT_Id != ettId && m.ETT_Name == name).Count();

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