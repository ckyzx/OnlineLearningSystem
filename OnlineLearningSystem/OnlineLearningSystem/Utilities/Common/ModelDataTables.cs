using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Data.SqlClient;

namespace OnlineLearningSystem.Utilities
{
    public class ModelDataTables<T> where T : new()
    {

        private DbOperator olsDBO = new DbOperator("OLSDBO");
        private DataTablesRequest dtRequest;
        private String tableName;
        private String idFieldName;

        public ModelDataTables(DataTablesRequest dtRequest, String tableName, String idFieldName)
        {
            this.dtRequest = dtRequest;
            this.tableName = tableName;
            this.idFieldName = idFieldName;
        }

        public DataTablesResponse GetList()
        {

            DataTablesResponse dtResponse;
            Int32 recordsTotal, recordsFiltered;
            Object[] modelData;
            List<T> ms;

            modelData = GetModels(dtRequest);
            ms = (List<T>)modelData[0];
            recordsTotal = (Int32)modelData[1];
            recordsFiltered = (Int32)modelData[2];

            dtResponse = new DataTablesResponse();
            dtResponse.draw = dtRequest.Draw;
            dtResponse.recordsTotal = recordsTotal;
            dtResponse.recordsFiltered = recordsFiltered;
            dtResponse.data = ms;

            return dtResponse;
        }

        public DataTablesResponse GetList(String statusFieldName)
        {

            DataTablesResponse dtResponse;
            Int32 recordsTotal, recordsFiltered;
            Object[] modelData;
            List<T> ms;

            modelData = GetModels(dtRequest, statusFieldName);
            ms = (List<T>)modelData[0];
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
            List<T> ms;
            List<SqlParameter> sps;

            sql = "SELECT * FROM " + tableName + " ";
            sqlConditions = GetSqlCondition(sql, dtRequest);
            sql = (String)sqlConditions[0];
            sps = (List<SqlParameter>)sqlConditions[1];

            dataTable = olsDBO.GetDataTableWithStart(sql, sps, dtRequest.Length, dtRequest.Start);
            ms = (List<T>)ModelConvert<T>.ConvertToModel(dataTable);

            countSql = sql.Replace("SELECT * FROM ", "SELECT COUNT(" + idFieldName + ") FROM ");
            total = Convert.ToInt32(olsDBO.ExecuteSqlScalar(countSql, sps));
            filter = Convert.ToInt32(olsDBO.ExecuteSqlScalar(countSql, sps));

            return new Object[] { ms, total, filter };
        }

        private Object[] GetModels(DataTablesRequest dtRequest, String statusFieldName)
        {

            Int32 total, filter;
            String sql, countSql;
            DataTable dataTable;
            Object[] sqlConditions;
            List<T> ms;
            List<SqlParameter> sps;

            sql = "SELECT * FROM " + tableName + " ";
            sqlConditions = GetSqlCondition(sql, dtRequest, statusFieldName);
            sql = (String)sqlConditions[0];
            sps = (List<SqlParameter>)sqlConditions[1];

            dataTable = olsDBO.GetDataTableWithStart(sql, sps, dtRequest.Length, dtRequest.Start);
            ms = (List<T>)ModelConvert<T>.ConvertToModel(dataTable);

            countSql = sql.Replace("SELECT * FROM ", "SELECT COUNT(" + idFieldName + ") FROM ");
            total = Convert.ToInt32(olsDBO.ExecuteSqlScalar(countSql, sps));
            filter = Convert.ToInt32(olsDBO.ExecuteSqlScalar(countSql, sps));

            return new Object[] { ms, total, filter };
        }

        private Object[] GetSqlCondition(String sql, DataTablesRequest dtRequest)
        {

            String whereSql, orderSql;
            List<SqlParameter> sps;

            whereSql = "";
            sps = new List<SqlParameter>();

            //TODO:指定筛选条件
            if ("" != dtRequest.SearchValue)
            {

                foreach (var col in dtRequest.Columns)
                {

                    if ("" != col.Name)
                    {

                        whereSql += col.Name + " LIKE @" + col.Name + " OR ";
                        sps.Add(new SqlParameter("@" + col.Name, "%" + dtRequest.SearchValue + "%"));
                    }
                }
            }

            if ("" != whereSql)
            {
                whereSql = whereSql.Substring(0, whereSql.Length - 3);

                sql += sql.IndexOf("WHERE ") == -1 ? "WHERE " + whereSql : "AND (" + whereSql + ")";
            }

            //TODO:指定排序列
            orderSql = dtRequest.Columns[dtRequest.OrderColumn].Name;
            if ("" != orderSql)
            {
                orderSql += dtRequest.OrderDir == 0 ? " ASC" : " DESC";

                sql += "ORDER BY " + orderSql;
            }

            return new Object[] { sql, sps };
        }

        private Object[] GetSqlCondition(String sql, DataTablesRequest dtRequest, String statusFieldName)
        {

            String whereSql, orderSql;
            List<SqlParameter> sps;

            whereSql = "";
            sps = new List<SqlParameter>();

            //TODO:指定筛选条件
            if ("" != dtRequest.SearchValue)
            {

                foreach (var col in dtRequest.Columns)
                {

                    if ("" != col.Name)
                    {

                        whereSql += col.Name + " LIKE @" + col.Name + " OR ";
                        sps.Add(new SqlParameter("@" + col.Name, "%" + dtRequest.SearchValue + "%"));
                    }
                }
            }

            if ("" != whereSql)
            {
                whereSql = whereSql.Substring(0, whereSql.Length - 3);

                sql += sql.IndexOf("WHERE ") == -1 ? "WHERE " + whereSql : "AND (" + whereSql + ")";
            }

            sql += sql.IndexOf("WHERE ") == -1 ? "WHERE " : "AND ";
            sql += statusFieldName + " = @status ";
            sps.Add(new SqlParameter("@status", (Byte)dtRequest.Status));

            //TODO:指定排序列
            orderSql = dtRequest.Columns[dtRequest.OrderColumn].Name;
            if ("" != orderSql)
            {
                orderSql += dtRequest.OrderDir == 0 ? " ASC" : " DESC";

                sql += "ORDER BY " + orderSql;
            }

            return new Object[] { sql, sps };
        }
    }
}