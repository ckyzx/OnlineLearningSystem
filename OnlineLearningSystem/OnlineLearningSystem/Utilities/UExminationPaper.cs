using System;
using System.Collections.Generic;
using System.Linq;
using System.Data;
using System.Web;
using System.Web.Mvc;
using OnlineLearningSystem.Models;

namespace OnlineLearningSystem.Utilities
{
    public class UExaminationPaper : Utility
    {
        public DataTablesResponse ListDataTablesAjax(DataTablesRequest dtRequest)
        {

            DataTablesResponse dtResponse;
            Int32 recordsTotal, recordsFiltered;
            String whereSql, orderColumn;
            List<ExaminationPaper> ms;


            dtResponse = new DataTablesResponse();

            dtResponse.draw = dtRequest.Draw;

            recordsTotal = olsEni.ExaminationPapers.Count();
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

            ms =
                olsEni
                .ExaminationPapers
                .OrderBy(model => model.EP_Id)
                .Where(model =>
                    model.EP_UserName.Contains(dtRequest.SearchValue)
                    && model.EP_Status != (Byte)Status.Delete)
                .ToList();

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

        public ExaminationPaper GetNew(Int32 userId)
        {

            ExaminationPaper model;
            User u;

            u = olsEni.Users.SingleOrDefault(m => m.U_Id == userId);

            model = new ExaminationPaper()
            {
                EP_Id = 0,
                EP_UserId = userId,
                EP_UserName = u.U_Name,
                EP_Remark = "",
                EP_AddTime = DateTime.Now,
                EP_Status = (Byte)Status.Available
            };

            return model;
        }

        public ExaminationPaper Get(Int32 id)
        {
            ExaminationPaper model;

            model = olsEni.ExaminationPapers.SingleOrDefault(m => m.EP_Id == id);

            if (null == model)
            {
                throw new NotImplementedException();
            }

            return model;
        }

        public Boolean Create(ExaminationPaper model)
        {
            try
            {

                Int32 rowCount;
                Int32 id;

                rowCount = olsEni.ExaminationPapers.Count();
                id = 0 == rowCount ? 0 : olsEni.ExaminationPapers.Max(m => m.EP_AutoId);

                model.EP_Id = id + 1;
                olsEni.ExaminationPapers.Add(model);
                olsEni.SaveChanges();

                return true;
            }
            catch (Exception ex)
            {

                throw;
            }
        }

        public Boolean Edit(ExaminationPaper model)
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
                ExaminationPaper model;

                model = olsEni.ExaminationPapers.SingleOrDefault(m => m.EP_Id == id);

                if (null == model)
                {
                    resJson.message = "数据不存在！";
                    return resJson;
                }

                model.EP_Status = (Byte)status;
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