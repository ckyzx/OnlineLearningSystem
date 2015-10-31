using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using OnlineLearningSystem.Models;

namespace OnlineLearningSystem.Utilities
{
    public class DataTablesResponse
    {
        public Int32 draw { get; set; }
        public Int32 recordsTotal { get; set; }
        public Int32 recordsFiltered { get; set; }
        public List<Question> data { get; set; }
    }
}