using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data.SqlClient;

namespace OnlineLearningSystem.Utilities
{
    public class Utility
    {
        protected OLSEntities olsEni = new OLSEntities();
        protected DatabaseOperator olsDbo = new DatabaseOperator("OLSDBO");
        protected DateTime now = DateTime.Now;
        protected DateTime nowDate = DateTime.Now.Date;


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

        public Int32 GetEPId()
        {
            return GetNewId("ExaminationPapers", "EP_");
        }

        public Int32 GetEPQId()
        {
            return GetNewId("ExaminationPaperQuestions", "EPQ_");
        }

        public Int32 GetEPTId()
        {
            return GetNewId("ExaminationPaperTemplates", "EPT_");
        }

        public Int32 GetEPTQId()
        {
            return GetNewId("ExaminationPaperTemplateQuestions", "EPTQ_");
        }

        public Int32 GetDId()
        {
            return GetNewId("Departments", "D_");
        }

        public Int32 GetDuId()
        {
            return GetNewId("Duties", "Du_");
        }

        public Int32 GetETId()
        {
            return GetNewId("ExaminationTasks", "ET_");
        }

        public Int32 GetPCId()
        {
            return GetNewId("PermissionCategories", "PC_");
        }

        public Int32 GetPId()
        {
            return GetNewId("Permissions", "P_");
        }

        public Int32 GetQId()
        {
            return GetNewId("Questions", "Q_");
        }

        public Int32 GetQCId()
        {
            return GetNewId("QuestionClassifies", "QC_");
        }

        public Int32 GetUId()
        {
            return GetNewId("Users", "U_");
        }

        public Int32 GetETTId()
        {
            return GetNewId("ExaminationTaskTemplates", "ETT_");
        }

        public Int32 GetRId()
        {
            return GetNewId("Roles", "R_");
        }

        public Int32 GetNewId(String tableName, String prefix)
        {

            Int32 id, timeout;
            String sql;

            sql = "SELECT COUNT(" + prefix + "AutoId) FROM " + tableName;
            id = Convert.ToInt32(olsDbo.ExecuteSqlScalar(sql));

            if (0 != id)
            {
                sql = "SELECT TOP 1 " + prefix + "AutoId FROM " + tableName + " ORDER BY " + prefix + "AutoId DESC";
                id = Convert.ToInt32(olsDbo.ExecuteSqlScalar(sql));

            }

            // 避免 Id重复
            timeout = 0;
            do
            {
                id += 1;
                sql = "SELECT " + prefix + "Id FROM " + tableName + " WHERE " + prefix + "Id = " + id;
                
                timeout += 1;
                if (timeout == 100)
                {
                    StaticHelper.RecordSystemLog(SystemLogType.Error, "获取编号时超出循环限制次数", sql);
                    throw new Exception("获取编号时超出循环限制次数");
                }
            } while (null != olsDbo.ExecuteSqlScalar(sql));

            return id;
        }
    }
}