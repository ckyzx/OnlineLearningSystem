using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using OnlineLearningSystem.Utilities;
//using Newtonsoft.Json;

namespace OnlineLearningSystem.Controllers
{
    public class OLSController : Controller
    {

        public OLSEntities olsEni = new OLSEntities();

        protected DataTablesRequest GetDataTablesRequest()
        {

            DataTablesRequest dtRequest;
            Int32 i;
            String data, orderable, searchable, searchRegex, orderDir;
            List<DataTablesColumn> columns;


            dtRequest = new DataTablesRequest();

            dtRequest.Draw = Convert.ToInt32(Request["draw"]);


            i = 0;
            columns = new List<DataTablesColumn>();

            while (null != Request["columns[" + i + "][name]"])
            {

                data = Request["columns[" + i + "][data]"];
                orderable = Request["columns[" + i + "][orderable]"];
                searchable = Request["columns[" + i + "][searchable]"];
                searchRegex = Request["columns[" + i + "][search][regex]"];

                columns.Add(new DataTablesColumn()
                {
                    Data = data,
                    Name = Request["columns[" + i + "][name]"],
                    Orderable = orderable == "true" ? true : false,
                    Searchable = searchable == "true" ? true : false,
                    SearchValue = Request["columns[" + i + "][search][value]"],
                    SearchRegex = searchRegex == "true" ? true : false
                });

                i += 1;
            }

            dtRequest.Columns = columns;


            dtRequest.Start = Convert.ToInt32(Request["start"]);
            dtRequest.Length = Convert.ToInt32(Request["length"]);
            dtRequest.OrderColumn = Convert.ToInt32(Request["order[0][column]"]);
            orderDir = Request["order[0][dir]"];
            dtRequest.OrderDir = "asc" == orderDir ? 0 : 1;
            dtRequest.SearchValue = Request["search[value]"];
            searchRegex = Request["search[regex]"];
            dtRequest.SearchRegex = "true" == searchRegex ? true : false;

            return dtRequest;
        }

    }
}
