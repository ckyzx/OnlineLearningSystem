using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace OnlineLearningSystem.Utilities
{
    public class ResponseJson
    {
        public ResponseStatus status { get; set; }
        public String data { get; set; }
        public String message { get; set; }
        public Object addition { get; set; }
        public String remark { get; set; }

        public ResponseJson()
        {
            status = ResponseStatus.Error;
            data = "{}";
            message = "";
            remark = "";
        }
    }
}