using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace OnlineLearningSystem.Utilities
{
    public class ResponseJson
    {
        public ResponseStatus status { get; set; }
        public Object data { get; set; }
        public String message { get; set; }
        public String detail { get; set; }
        public Object addition { get; set; }
        public DateTime time { get; set; }
        public String remark { get; set; }

        public ResponseJson()
        {
            status = ResponseStatus.Error;
            data = "{}";
            message = "";
            time = DateTime.Now;
            remark = "";
        }

        public ResponseJson(ResponseStatus status)
        {
            this.status = status;
            data = "{}";
            message = "";
            time = DateTime.Now;
            remark = "";
        }

        public ResponseJson(ResponseStatus status, DateTime time)
        {
            this.status = status;
            data = "{}";
            message = "";
            this.time = time;
            remark = "";
        }

        public ResponseJson(ResponseStatus status, String message)
        {
            this.status = status;
            data = "{}";
            this.message = message;
            time = DateTime.Now;
            remark = "";
        }

    }
}