using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using OnlineLearningSystem.ViewModels;
using System.Data;
using System.Data.SqlClient;

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
            Object[] sqlConditions;
            List<VMExaminationTaskStatistic> ms;
            List<SqlParameter> sps;

            sql = "SELECT * FROM ExaminationTaskStatistic ";
            sqlConditions = GetSqlCondition(sql, dtRequest);
            sql = (String)sqlConditions[0];
            sps = (List<SqlParameter>)sqlConditions[1];

            dataTable = olsDBO.GetDataTableWithStart(sql, sps, dtRequest.Length, dtRequest.Start);
            ms = (List<VMExaminationTaskStatistic>)ModelConvert<VMExaminationTaskStatistic>.ConvertToModel(dataTable);

            total = Convert.ToInt32(olsDBO.ExecuteSqlScalar(sql, sps));
            filter = Convert.ToInt32(olsDBO.ExecuteSqlScalar(sql, sps));

            return new Object[]{ms, total, filter};
        }

        public DataTablesResponse ListUserDataTablesAjax(DataTablesRequest dtRequest, Int32 eptId)
        {

            DataTablesResponse dtResponse;
            Int32 recordsTotal, recordsFiltered;
            Object[] modelData;
            List<VMExaminationTaskUserStatistic> ms;

            modelData = GetUserStatistics(dtRequest, eptId);
            ms = (List<VMExaminationTaskUserStatistic>)modelData[0];
            recordsTotal = (Int32)modelData[1];
            recordsFiltered = (Int32)modelData[2];

            dtResponse = new DataTablesResponse();
            dtResponse.draw = dtRequest.Draw;
            dtResponse.recordsTotal = recordsTotal;
            dtResponse.recordsFiltered = recordsFiltered;
            dtResponse.data = ms;

            return dtResponse;
        }

        private Object[] GetUserStatistics(DataTablesRequest dtRequest, Int32 eptId)
        {

            Int32 total, filter;
            String sql;
            DataTable dataTable;
            Object[] sqlConditions;
            List<VMExaminationTaskUserStatistic> ms;
            List<SqlParameter> sps;

            sql = "SELECT * FROM ExaminationTaskUserStatistic WHERE ETUS_PaperTemplateId = @eptId ";
            sqlConditions = GetSqlCondition(sql, dtRequest);
            sql = (String)sqlConditions[0];
            sps = (List<SqlParameter>)sqlConditions[1];
            sps.Add(new SqlParameter("@eptid", eptId));

            dataTable = olsDBO.GetDataTableWithStart(sql, sps, dtRequest.Length, dtRequest.Start);
            ms = (List<VMExaminationTaskUserStatistic>)ModelConvert<VMExaminationTaskUserStatistic>.ConvertToModel(dataTable);

            total = Convert.ToInt32(olsDBO.ExecuteSqlScalar(sql, sps));
            filter = Convert.ToInt32(olsDBO.ExecuteSqlScalar(sql, sps));

            return new Object[] { ms, total, filter };
        }

    }
}