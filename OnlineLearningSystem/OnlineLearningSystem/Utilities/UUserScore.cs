using System;
using System.Collections.Generic;
using OnlineLearningSystem.ViewModels;
using System.Data.SqlClient;
using System.Data;
using System.IO;

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

        public DataSet GetDataSet(String sql, List<SqlParameter> sps)
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

    }
}
