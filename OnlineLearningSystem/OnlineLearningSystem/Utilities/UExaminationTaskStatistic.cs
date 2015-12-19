using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using OnlineLearningSystem.ViewModels;
using System.Data;

namespace OnlineLearningSystem.Utilities
{
    public class UExaminationTaskStatistic : Utility
    {

        public DataTablesResponse ListDataTablesAjax(DataTablesRequest dtRequest)
        {

            DataTablesResponse dtResponse;
            Int32 recordsTotal, recordsFiltered;
            Object[] modelData;
            List<VMExaminationTaskStatistic> ms;

            modelData = GetModels(dtRequest);
            ms = (List<VMExaminationTaskStatistic>)modelData[0];
            recordsTotal = (Int32)modelData[1];
            recordsFiltered = (Int32)modelData[2];

            dtResponse = new DataTablesResponse();
            dtResponse.draw = dtRequest.Draw;
            dtResponse.recordsTotal = recordsTotal;
            dtResponse.recordsFiltered = recordsFiltered;
            dtResponse.data = ms;

            return dtResponse;
        }

        private Object[] GetModels(DataTablesRequest dtRequest)
        {

            Int32 total, filter;
            String sql;
            DataTable dataTable;
            List<VMExaminationTaskStatistic> ms;

            sql = "SELECT * FROM ExaminationTaskStatistic";
            dataTable = olsDBO.GetDataTableWithStart(sql, dtRequest.Length, dtRequest.Start);
            ms = (List<VMExaminationTaskStatistic>)ModelConvert<VMExaminationTaskStatistic>.ConvertToModel(dataTable);

            total = Convert.ToInt32(olsDBO.ExecuteSqlScalar(sql));
            filter = Convert.ToInt32(olsDBO.ExecuteSqlScalar(sql));

            return new Object[]{ms, total, filter};
        }
    }
}