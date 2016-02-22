using System;
using System.Collections.Generic;
using System.Web;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace OnlineLearningSystem.Utilities
{
    public class DatabaseOperator
    {

        private SqlConnection sqlConnection = null;
        private SqlCommand sqlCommand = null;
        private SqlDataAdapter sqlDataAdapter = null;
        private string connectionString = null;
        private DataSet dataSet = null;
        private DataTable dataTable = null;


        /*public SqlDbOperator()
        {

            connectionString = ConfigurationManager.ConnectionStrings["DbHelper"].ConnectionString;
            sqlConnection = new SqlConnection(connectionString);
            sqlConnection.Open();
        }*/

        public DatabaseOperator(string name)
        {

            connectionString = ConfigurationManager.ConnectionStrings[name].ConnectionString;
            sqlConnection = new SqlConnection(connectionString);
        }

        ~DatabaseOperator()
        {
            /*sqlConnection.Close();
            sqlCommand.Dispose();
            sqlDataAdapter.Dispose();
            sqlConnection.Dispose();*/
        }

        public Boolean Open()
        {


            try
            {


                sqlConnection.Open();

            }
            catch (Exception)
            {
                return false;
            }

            return true;
        }

        public void Close()
        {
            if (sqlConnection.State.ToString().ToLower() == "open")
            {
                sqlConnection.Close();
            }
        }

        public Int32 ExecuteSql(string sql)
        {


            Int32 result;


            sqlConnection.Open();

            sqlCommand = new SqlCommand(sql, sqlConnection);
            sqlCommand.CommandType = CommandType.Text;

            result = sqlCommand.ExecuteNonQuery();

            sqlConnection.Close();


            return result;
        }

        public Int32 ExecuteSql(string sql, SqlParameter sqlParameter)
        {


            int result;


            sqlConnection.Open();

            sqlCommand = new SqlCommand(sql, sqlConnection);
            sqlCommand.CommandType = CommandType.Text;
            sqlCommand.Parameters.Add(sqlParameter);

            result = sqlCommand.ExecuteNonQuery();

            sqlCommand.Parameters.Clear();

            sqlConnection.Close();


            return result;
        }

        public Int32 ExecuteSql(string sql, SqlParameter[] sqlParameters)
        {


            int result;


            sqlConnection.Open();

            sqlCommand = new SqlCommand(sql, sqlConnection);
            sqlCommand.CommandType = CommandType.Text;
            sqlCommand.Parameters.Clear();
            sqlCommand.Parameters.AddRange(sqlParameters);

            result = sqlCommand.ExecuteNonQuery();

            sqlCommand.Parameters.Clear();

            sqlConnection.Close();


            return result;
        }

        public string ExecuteSqlScalar(string sql)
        {


            object returnValue;


            sqlConnection.Open();

            sqlCommand = new SqlCommand(sql, sqlConnection);
            sqlCommand.CommandType = CommandType.Text;
            returnValue = sqlCommand.ExecuteScalar();

            sqlConnection.Close();


            return returnValue == null ? null : returnValue.ToString();
        }

        public string ExecuteSqlScalar(string sql, SqlParameter sqlParameter)
        {


            object returnValue;


            sqlConnection.Open();

            sqlCommand = new SqlCommand(sql, sqlConnection);
            sqlCommand.CommandType = CommandType.Text;
            sqlCommand.Parameters.Add(sqlParameter);
            returnValue = sqlCommand.ExecuteScalar();
            sqlCommand.Parameters.Clear();

            sqlConnection.Close();


            return returnValue == null ? null : returnValue.ToString();

        }

        public string ExecuteSqlScalar(string sql, List<SqlParameter> sqlParameters)
        {


            object returnValue;


            sqlConnection.Open();

            sqlCommand = new SqlCommand(sql, sqlConnection);
            sqlCommand.CommandType = CommandType.Text;
            if (sqlParameters.Count != 0)
            {
                sqlCommand.Parameters.AddRange(sqlParameters.ToArray());
            }
            returnValue = sqlCommand.ExecuteScalar();
            sqlCommand.Parameters.Clear();

            sqlConnection.Close();


            return returnValue == null ? null : returnValue.ToString();

        }

        public string ExecuteSqlScalar(string sql, SqlParameter[] sqlParameters)
        {


            object returnValue;


            sqlConnection.Open();

            sqlCommand = new SqlCommand(sql, sqlConnection);
            sqlCommand.CommandType = CommandType.Text;
            sqlCommand.Parameters.AddRange(sqlParameters);
            returnValue = sqlCommand.ExecuteScalar();
            sqlCommand.Parameters.Clear();

            sqlConnection.Close();


            return returnValue == null ? null : returnValue.ToString();

        }

        public string ExecuteSqlScalar(string sql, SqlParameter[] sqlParameters, int timeout)
        {


            object returnValue;


            sqlConnection.Open();

            sqlCommand = new SqlCommand(sql, sqlConnection);
            sqlCommand.CommandTimeout = timeout;
            sqlCommand.CommandType = CommandType.Text;
            sqlCommand.Parameters.AddRange(sqlParameters);
            returnValue = sqlCommand.ExecuteScalar();
            sqlCommand.Parameters.Clear();

            sqlConnection.Close();


            return returnValue == null ? null : returnValue.ToString();
        }

        public Int32 ExecuteProcedure(string sql)
        {


            Int32 result;


            sqlConnection.Open();

            sqlCommand = new SqlCommand(sql, sqlConnection);
            sqlCommand.CommandType = CommandType.StoredProcedure;
            sqlCommand.Parameters.Clear();

            result = sqlCommand.ExecuteNonQuery();

            sqlConnection.Close();


            return result;
        }

        public Int32 ExecuteProcedure(string sql, SqlParameter[] sqlParameters)
        {


            Int32 result;


            sqlConnection.Open();

            sqlCommand = new SqlCommand(sql, sqlConnection);
            sqlCommand.CommandType = CommandType.StoredProcedure;
            sqlCommand.Parameters.AddRange(sqlParameters);

            result = sqlCommand.ExecuteNonQuery();
            sqlCommand.Parameters.Clear();

            sqlConnection.Close();


            return result;
        }

        public DataSet GetDataSet(string sql, SqlParameter[] sqlParameters)
        {


            sqlConnection.Open();

            sqlCommand = new SqlCommand(sql, sqlConnection);
            sqlCommand.CommandType = CommandType.StoredProcedure;
            sqlCommand.Parameters.AddRange(sqlParameters);
            sqlDataAdapter = new SqlDataAdapter(sqlCommand);
            sqlDataAdapter.Fill(dataSet);
            sqlCommand.Parameters.Clear();

            sqlConnection.Close();


            return dataSet;
        }

        public DataTable GetDataTable(string sql)
        {


            sqlConnection.Open();

            sqlCommand = new SqlCommand(sql, sqlConnection);
            dataTable = new DataTable();
            sqlCommand.CommandType = CommandType.Text;
            sqlDataAdapter = new SqlDataAdapter(sqlCommand);
            sqlDataAdapter.Fill(dataTable);
            sqlCommand.Parameters.Clear();

            sqlConnection.Close();


            return dataTable;
        }

        public DataTable GetDataTable(string sql, SqlParameter sqlParameter)
        {


            sqlConnection.Open();

            sqlCommand = new SqlCommand(sql, sqlConnection);
            dataTable = new DataTable();
            sqlCommand.CommandType = CommandType.Text;
            sqlCommand.Parameters.Add(sqlParameter);
            sqlDataAdapter = new SqlDataAdapter(sqlCommand);
            sqlDataAdapter.Fill(dataTable);
            sqlCommand.Parameters.Clear();

            sqlConnection.Close();


            return dataTable;
        }

        public DataTable GetDataTable(string sql, SqlParameter[] sqlParameters)
        {


            sqlConnection.Open();

            sqlCommand = new SqlCommand(sql, sqlConnection);
            dataTable = new DataTable();
            sqlCommand.CommandType = CommandType.Text;
            sqlCommand.Parameters.AddRange(sqlParameters);
            sqlDataAdapter = new SqlDataAdapter(sqlCommand);
            sqlDataAdapter.Fill(dataTable);
            sqlCommand.Parameters.Clear();

            sqlConnection.Close();


            return dataTable;
        }

        public DataTable GetDataTable(string sql, SqlParameter[] sqlParameters, int timeout)
        {


            sqlConnection.Open();

            sqlCommand = new SqlCommand(sql, sqlConnection);
            sqlCommand.CommandTimeout = timeout;
            sqlCommand.CommandType = CommandType.Text;
            sqlCommand.Parameters.AddRange(sqlParameters);
            sqlDataAdapter = new SqlDataAdapter(sqlCommand);
            dataTable = new DataTable();
            sqlDataAdapter.Fill(dataTable);
            sqlCommand.Parameters.Clear();

            sqlConnection.Close();


            return dataTable;
        }

        public DataTable GetDataTable(string sql, int itemsPerPage, int pagination)
        {


            DataSet ds = new DataSet();
            DataTable dt = new DataTable();
            int startRecord;


            sqlConnection.Open();

            sqlCommand = new SqlCommand(sql, sqlConnection);
            sqlDataAdapter = new SqlDataAdapter(sqlCommand);

            if (pagination == 1)
            {
                startRecord = 0;
            }
            else
            {
                startRecord = itemsPerPage * (pagination - 1);
            }
            sqlDataAdapter.Fill(ds, startRecord, itemsPerPage, "Table");
            sqlCommand.Parameters.Clear();
            dt = ds.Tables["Table"];

            sqlConnection.Close();


            return dt;
        }

        public DataTable GetDataTable(string sql, SqlParameter sqlParameter, int itemsPerPage, int pagination)
        {


            DataSet ds = new DataSet();
            DataTable dt = new DataTable();
            int startRecord;


            sqlConnection.Open();

            sqlCommand = new SqlCommand(sql, sqlConnection);
            sqlCommand.Parameters.Add(sqlParameter);
            sqlDataAdapter = new SqlDataAdapter(sqlCommand);

            if (pagination == 1)
            {
                startRecord = 0;
            }
            else
            {
                startRecord = itemsPerPage * (pagination - 1);
            }
            sqlDataAdapter.Fill(ds, startRecord, itemsPerPage, "Table");
            sqlCommand.Parameters.Clear();
            dt = ds.Tables["Table"];

            sqlConnection.Close();


            return dt;
        }

        public DataTable GetDataTable(string sql, SqlParameter[] sqlParameters, int itemsPerPage, int pagination)
        {


            DataSet ds;
            DataTable dt;
            int startRecord;


            ds = new DataSet();
            dt = new DataTable();

            sqlConnection.Open();

            sqlCommand = new SqlCommand(sql, sqlConnection);
            sqlCommand.Parameters.AddRange(sqlParameters);
            sqlDataAdapter = new SqlDataAdapter(sqlCommand);

            if (pagination == 1)
            {
                startRecord = 0;
            }
            else
            {
                startRecord = itemsPerPage * (pagination - 1);
            }

            sqlDataAdapter.Fill(ds, startRecord, itemsPerPage, "Table");
            sqlCommand.Parameters.Clear();
            dt = ds.Tables["Table"];

            sqlConnection.Close();


            return dt;

        }

        public DataTable GetDataTable(string sql, SqlParameter[] sqlParameters, int itemsPerPage, int pagination, int timeout)
        {


            DataSet ds = new DataSet();
            DataTable dt = new DataTable();
            int startRecord;


            sqlConnection.Open();

            sqlCommand = new SqlCommand(sql, sqlConnection);
            sqlCommand.CommandTimeout = timeout;
            sqlCommand.Parameters.AddRange(sqlParameters);
            sqlDataAdapter = new SqlDataAdapter(sqlCommand);

            if (pagination == 1)
            {
                startRecord = 0;
            }
            else
            {
                startRecord = itemsPerPage * (pagination - 1);
            }
            sqlDataAdapter.Fill(ds, startRecord, itemsPerPage, "Table");
            sqlCommand.Parameters.Clear();
            dt = ds.Tables["Table"];

            sqlConnection.Close();


            return dt;
        }

        public DataRow GetDataRow(string sql, SqlParameter sqlParameter)
        {


            sqlConnection.Open();

            sqlCommand = new SqlCommand(sql, sqlConnection);
            dataTable = new DataTable();
            sqlCommand.CommandType = CommandType.Text;
            sqlCommand.Parameters.Add(sqlParameter);
            sqlDataAdapter = new SqlDataAdapter(sqlCommand);
            sqlDataAdapter.Fill(dataTable);
            sqlCommand.Parameters.Clear();

            sqlConnection.Close();

            if (dataTable.Rows.Count == 0)
            {
                return null;
            }


            return dataTable.Rows[0];
        }

        public DataRow GetDataRow(string sql, SqlParameter[] sqlParameters)
        {


            sqlConnection.Open();

            sqlCommand = new SqlCommand(sql, sqlConnection);
            dataTable = new DataTable();
            sqlCommand.CommandType = CommandType.Text;
            sqlCommand.Parameters.AddRange(sqlParameters);
            sqlDataAdapter = new SqlDataAdapter(sqlCommand);
            sqlDataAdapter.Fill(dataTable);
            sqlCommand.Parameters.Clear();

            sqlConnection.Close();

            if (dataTable.Rows.Count == 0)
            {
                return null;
            }


            return dataTable.Rows[0];
        }

        public DataTable GetDataTableWithStart(string sql, int itemsPerPage, int startRecord)
        {


            DataSet ds = new DataSet();
            DataTable dt = new DataTable();


            sqlConnection.Open();

            sqlCommand = new SqlCommand(sql, sqlConnection);
            sqlDataAdapter = new SqlDataAdapter(sqlCommand);

            sqlDataAdapter.Fill(ds, startRecord, itemsPerPage, "Table");
            sqlCommand.Parameters.Clear();
            dt = ds.Tables["Table"];

            sqlConnection.Close();


            return dt;
        }

        public DataTable GetDataTableWithStart(string sql, List<SqlParameter> sqlParameters, int itemsPerPage, int startRecord)
        {


            DataSet ds;
            DataTable dt;


            ds = new DataSet();
            dt = new DataTable();

            sqlConnection.Open();

            sqlCommand = new SqlCommand(sql, sqlConnection);
            if (sqlParameters.Count != 0)
            {
                sqlCommand.Parameters.AddRange(sqlParameters.ToArray());
            }
            sqlDataAdapter = new SqlDataAdapter(sqlCommand);

            sqlDataAdapter.Fill(ds, startRecord, itemsPerPage, "Table");
            sqlCommand.Parameters.Clear();
            dt = ds.Tables["Table"];

            sqlConnection.Close();


            return dt;

        }

    }
}