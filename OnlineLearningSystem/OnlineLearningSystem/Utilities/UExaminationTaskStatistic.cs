using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using OnlineLearningSystem.ViewModels;
using System.Data.SqlClient;
using System.IO;
using System.Text.RegularExpressions;
using OpenXmlExcel;

namespace OnlineLearningSystem.Utilities
{
    public class UExaminationTaskStatistic : Utility
    {

        public DataTablesResponse ListDataTablesAjax(DataTablesRequest dtRequest, String taskName, DateTime beginTime, DateTime endTime)
        {

            String sql;
            DataTablesResponse dtResponse;
            UModel<VMExaminationTaskStatistic> umodel;
            List<SqlParameter> sps;

            umodel = new UModel<VMExaminationTaskStatistic>(dtRequest, "ExaminationTaskStatistic", "ETS_PaperTemplateId");

            sql = "SELECT * FROM ExaminationTaskStatistic ";

            sps = new List<SqlParameter>();
            if (taskName != "")
            {
                sps.Add(new SqlParameter("@LIKE_ETS_TaskName", "%" + taskName + "%"));
            }

            if (beginTime.Year != 1 && endTime.Year != 1)
            {
                sps.Add(new SqlParameter("@GT_ETS_PaperTemplateDate", beginTime));
                sps.Add(new SqlParameter("@LT_ETS_PaperTemplateDate", endTime));
            }

            dtResponse = umodel.GetList(sql, sps);


            return dtResponse;
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

        internal String TaskExportToExcel(String taskName, DateTime beginTime, DateTime endTime)
        {

            Int32 eptId;
            String sql, whereSql, excelFile, columnName;
            DataSet dataSet;
            DataTable dt;
            DataRow dr;
            List<SqlParameter> sps;
            List<DataTable> dts;

            sps = new List<SqlParameter>();

            sql = "SELECT * FROM TaskStatisticToExcel ";
            whereSql = "";

            if (taskName != "")
            {
                whereSql += "ETS_TaskName LIKE @taskName ";
                sps.Add(new SqlParameter("@taskName", "%" + taskName + "%"));
            }

            if (beginTime.Year != 1 && endTime.Year != 1)
            {
                whereSql = whereSql == "" ? "" : "AND ";
                whereSql += "ETS_PaperTemplateDate > @beginTime AND ETS_PaperTemplateDate < @endTime ";
                sps.Add(new SqlParameter("@beginTime", beginTime));
                sps.Add(new SqlParameter("@endTime", endTime));
            }

            if (whereSql != "")
            {
                sql += "WHERE " + whereSql;
            }

            dataSet = olsDbo.GetDataSet(sql, sps);
            dataSet.Tables[0].TableName = "考试统计概览";

            excelFile = AppDomain.CurrentDomain.BaseDirectory + "Excels\\";

            if (!Directory.Exists(excelFile))
            {
                Directory.CreateDirectory(excelFile);
            }

            excelFile += now.Ticks.ToString() + ".xlsx";

            dts = new List<DataTable>();

            for (var i = 0; i < dataSet.Tables.Count; i++)
            {

                // 添加统计详情数据表
                for (var i1 = 0; i1 < dataSet.Tables[i].Rows.Count; i1++)
                {

                    dr = dataSet.Tables[i].Rows[i1];
                    eptId = (Int32)dr["ETS_PaperTemplateId"];

                    sps.Clear();
                    sps.Add(new SqlParameter("@eptId", eptId));

                    dt = olsDbo.GetDataTable("SELECT * FROM UserStatisticToExcel WHERE ETUS_PaperTemplateId = @eptId", sps);
                    dt.TableName = "考试 " + eptId;

                    dts.Add(dt);
                }
            }

            dataSet.Tables.AddRange(dts.ToArray());

            for (var i = 0; i < dataSet.Tables.Count; i++)
            {

                // 去除英文数据列
                for (var i1 = 0; i1 < dataSet.Tables[i].Columns.Count; i1++)
                {

                    columnName = dataSet.Tables[i].Columns[i1].ColumnName;

                    if (!Regex.IsMatch(columnName, @"[\u4e00-\u9fbb]+"))
                    {
                        dataSet.Tables[i].Columns.RemoveAt(i1);
                        i1 = -1;
                    }
                }
            }

            OpenXmlExcelStaticHelper.ExportExcel(excelFile, dataSet);

            return excelFile;
        }
    }
}