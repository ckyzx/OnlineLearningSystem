using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using OnlineLearningSystem.Models;

namespace OnlineLearningSystem.Utilities
{
    public class USystemLog : Utility
    {

        public DataTablesResponse ListDataTablesAjax(DataTablesRequest dtRequest)
        {
            DataTablesResponse dtResponse;
            UModel<SystemLog> umodel;
            List<SystemLog> ms;

            umodel = new UModel<SystemLog>(dtRequest, "SystemLogs", "SL_Id");
            dtResponse = umodel.GetList("SL_Status");

            ms = (List<SystemLog>)dtResponse.data;
            dtResponse.data = ms;

            return dtResponse;
        }
    }
}