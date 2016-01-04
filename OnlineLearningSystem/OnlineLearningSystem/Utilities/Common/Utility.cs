using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data.SqlClient;

namespace OnlineLearningSystem.Utilities
{
    public class Utility
    {
        public OLSEntities olsEni = new OLSEntities();
        protected DatabaseOperator olsDBO = new DatabaseOperator("OLSDBO");
        public DateTime now = DateTime.Now;

        protected Object[] GetSqlCondition(String sql, DataTablesRequest dtRequest)
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

    }
}