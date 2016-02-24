using System;
using System.Collections.Generic;
using OnlineLearningSystem.ViewModels;
using System.Data.SqlClient;
using System.Data;
using System.IO;
using System.Text.RegularExpressions;

namespace OnlineLearningSystem.Utilities
{
    public class UUserScore : Utility
    {

        private DatabaseOperator olsDBO = new DatabaseOperator("OLSDBO");

        internal DataTablesResponse ListSummaryDataTablesAjax(Utilities.DataTablesRequest dtRequest)
        {

            DataTablesResponse dtResponse;
            UModel<VMUserScoreSummary> umodel;

            umodel = new UModel<VMUserScoreSummary>(dtRequest, "UserScoreSummaries", "USS_UserId");
            dtResponse = umodel.GetList();

            return dtResponse;
        }

        internal DataTablesResponse ListDetailDataTablesAjax(DataTablesRequest dtRequest, Int32 uId)
        {

            DataTablesResponse dtResponse;
            List<SqlParameter> sps;
            UModel<VMUserScoreDetail> umodel;

            umodel = new UModel<VMUserScoreDetail>(dtRequest, "UserScoreDetails", "USD_UserId");

            sps = new List<SqlParameter>();
            sps.Add(new SqlParameter("@USD_UserId", uId));
            dtResponse = umodel.GetList("SELECT * FROM UserScoreDetails ", sps);

            return dtResponse;
        }

        internal DataTablesResponse ListDetailDataTablesAjax(DataTablesRequest dtRequest, Int32 uId, String taskName, DateTime beginTime, DateTime endTime)
        {

            String sql;
            DataTablesResponse dtResponse;
            List<SqlParameter> sps;
            UModel<VMUserScoreDetail> umodel;

            umodel = new UModel<VMUserScoreDetail>(dtRequest, "UserScoreDetails", "USD_UserId");

            sql = "SELECT * FROM UserScoreDetails ";

            sps = new List<SqlParameter>();
            sps.Add(new SqlParameter("@EQ_USD_UserId", uId));

            if (taskName != "")
            {
                sps.Add(new SqlParameter("@LIKE_USD_TaskName", "%" + taskName + "%"));
            }

            if (beginTime.Year != 1 && endTime.Year != 1)
            {
                sps.Add(new SqlParameter("@LT_USD_StartTime", beginTime));
                sps.Add(new SqlParameter("@GT_USD_StartTime", endTime));
            }

            dtResponse = umodel.GetList(sql, sps);

            return dtResponse;
        }

        internal String DetailExportToExcel(Int32 uId)
        {

            String excelFile;
            DataSet dataSet;
            List<SqlParameter> sps;

            sps = new List<SqlParameter>();
            sps.Add(new SqlParameter("@USD_UserId", uId));
            dataSet = GetDataSet("SELECT * FROM UserScoreDetailToExcel ", sps);

            excelFile = AppDomain.CurrentDomain.BaseDirectory + "Excels\\";

            if (!Directory.Exists(excelFile))
            {
                Directory.CreateDirectory(excelFile);
            }

            excelFile += now.Ticks.ToString() + ".xlsx";

            // 去除第一列
            for (var i = 0; i < dataSet.Tables.Count; i++)
            {
                dataSet.Tables[i].Columns.RemoveAt(0);
            }

            //TODO: 添加用户试卷数据表


            OpenXmlExcelHelper.ExportExcel(excelFile, dataSet);

            return excelFile;
        }

        private DataSet GetDataSet(String sql, List<SqlParameter> sps)
        {

            String whereSql;
            DataSet dataSet;

            whereSql = "";
            foreach (var sp in sps)
            {
                whereSql += "AND " + sp.ParameterName.Replace("@", "") + " = " + sp.ParameterName + " ";
            }
            sql += sql.IndexOf("WHERE ") == -1 ? "WHERE " + whereSql.Substring(4) : whereSql;

            dataSet = olsDBO.GetDataSet(sql, sps);

            return dataSet;
        }

        internal String DetailExportToExcel(Int32 uId, String taskName, DateTime beginTime, DateTime endTime)
        {

            Int32 pId;
            String sql, excelFile, columnName;
            DataSet dataSet;
            DataTable dt;
            DataRow dr;
            List<SqlParameter> sps;
            List<DataTable> dts;

            sps = new List<SqlParameter>();
            sps.Add(new SqlParameter("@uId", uId));

            sql = "SELECT * FROM UserScoreDetailToExcel WHERE USD_UserId = @uId ";

            if (taskName != "")
            {
                sql += "AND USD_TaskName LIKE @taskName ";
                sps.Add(new SqlParameter("@taskName", "%" + taskName + "%"));
            }

            if (beginTime.Year != 1 && endTime.Year != 1)
            {
                sql += "AND USD_StartTime > @beginTime AND USD_StartTime < @endTime ";
                sps.Add(new SqlParameter("@beginTime", beginTime));
                sps.Add(new SqlParameter("@endTime", endTime));
            }

            dataSet = olsDBO.GetDataSet(sql, sps);
            dataSet.Tables[0].TableName = "概览";

            excelFile = AppDomain.CurrentDomain.BaseDirectory + "Excels\\";

            if (!Directory.Exists(excelFile))
            {
                Directory.CreateDirectory(excelFile);
            }

            excelFile += now.Ticks.ToString() + ".xlsx";

            dts = new List<DataTable>();

            for (var i = 0; i < dataSet.Tables.Count; i++)
            {

                // 添加用户试卷数据表
                for (var i1 = 0; i1 < dataSet.Tables[i].Rows.Count; i1++)
                {

                    dr = dataSet.Tables[i].Rows[i1];
                    pId = (Int32)dr["USD_PaperId"];

                    if (pId == 0)
                        continue;

                    sps.Clear();
                    sps.Add(new SqlParameter("@uId", uId));
                    sps.Add(new SqlParameter("@pId", pId));

                    dt = olsDbo.GetDataTable("SELECT * FROM PaperDetailToExcel WHERE PD_UserId = @uId AND PD_PaperId = @pId", sps);
                    dt.TableName = "试卷 " + pId;

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

            OpenXmlExcelHelper.ExportExcel(excelFile, dataSet);

            return excelFile;
        }

        internal String SummaryExportToExcel()
        {

            String sql, excelFile, columnName;
            DataSet dataSet;

            sql = "SELECT * FROM UserScoreSummaryToExcel ";
            dataSet = olsDBO.GetDataSet(sql);

            excelFile = AppDomain.CurrentDomain.BaseDirectory + "Excels\\";

            if (!Directory.Exists(excelFile))
            {
                Directory.CreateDirectory(excelFile);
            }

            excelFile += now.Ticks.ToString() + ".xlsx";

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

            OpenXmlExcelHelper.ExportExcel(excelFile, dataSet);

            return excelFile;
        }
    }
}
