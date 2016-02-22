using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using OnlineLearningSystem.ViewModels;
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
            String sql, countSql;
            DataTable dataTable;
            Object[] sqlConditions;
            List<VMExaminationTaskStatistic> ms;
            List<SqlParameter> sps;

            sql = "SELECT * FROM ExaminationTaskStatistic ";
            sqlConditions = GetSqlCondition(sql, dtRequest);
            sql = (String)sqlConditions[0];
            sps = (List<SqlParameter>)sqlConditions[1];

            dataTable = olsDbo.GetDataTableWithStart(sql, sps, dtRequest.Length, dtRequest.Start);
            ms = (List<VMExaminationTaskStatistic>)ModelConvert<VMExaminationTaskStatistic>.ConvertToModel(dataTable);

            countSql = sql.Replace("SELECT * FROM ", "SELECT COUNT(ETS_TaskId) FROM ");
            total = Convert.ToInt32(olsDbo.ExecuteSqlScalar(countSql, sps));
            filter = Convert.ToInt32(olsDbo.ExecuteSqlScalar(countSql, sps));

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
            String sql, countSql;
            DataTable dataTable;
            Object[] sqlConditions;
            List<VMExaminationTaskUserStatistic> ms;
            List<SqlParameter> sps;

            sql = "SELECT * FROM ExaminationTaskUserStatistic WHERE ETUS_PaperTemplateId = @eptId ";
            sqlConditions = GetSqlCondition(sql, dtRequest);
            sql = (String)sqlConditions[0];
            sps = (List<SqlParameter>)sqlConditions[1];
            sps.Add(new SqlParameter("@eptid", eptId));

            dataTable = olsDbo.GetDataTableWithStart(sql, sps, dtRequest.Length, dtRequest.Start);
            ms = (List<VMExaminationTaskUserStatistic>)ModelConvert<VMExaminationTaskUserStatistic>.ConvertToModel(dataTable);

            countSql = sql.Replace("SELECT * FROM ", "SELECT COUNT(ETUS_TaskId) FROM ");
            total = Convert.ToInt32(olsDbo.ExecuteSqlScalar(countSql, sps));
            filter = Convert.ToInt32(olsDbo.ExecuteSqlScalar(countSql, sps));

            return new Object[] { ms, total, filter };
        }

        public VMExaminationTaskPersonalStatistic GetPersonalStatistic(Int32 uId)
        {
            try
            {

                String sql;
                SqlParameter sp;
                DataTable dataTable;
                List<VMExaminationTaskPersonalStatistic> etpss;

                sql = "SELECT * FROM ExaminationTaskPersonalStatistic WHERE ETPS_UserId = @uId";
                sp = new SqlParameter("@uId", uId);
                dataTable = olsDbo.GetDataTable(sql, sp);

                etpss = (List<VMExaminationTaskPersonalStatistic>)ModelConvert<VMExaminationTaskPersonalStatistic>.ConvertToModel(dataTable);

                if (etpss.Count == 0)
                {
                    return null;
                }

                return etpss[0];
            }
            catch (Exception ex)
            {
                StaticHelper.GetExceptionMessageAndRecord(ex);
                return null;
            }
        }
    }
}