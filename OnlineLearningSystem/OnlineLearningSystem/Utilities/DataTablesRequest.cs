using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace OnlineLearningSystem.Utilities
{
    public class DataTablesRequest
    {
        public Int32 Draw { get; set; }
        public List<DataTablesColumn> Columns { get; set; }
        public Int32 OrderColumn { get; set; }
        public Int32 OrderDir { get; set; }
        public Int32 Start { get; set; }
        public Int32 Length { get; set; }
        public String SearchValue { get; set; }
        public Boolean SearchRegex { get; set; }
    }
}