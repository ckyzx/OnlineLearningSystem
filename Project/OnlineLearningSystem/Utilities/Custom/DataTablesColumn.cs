using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace OnlineLearningSystem.Utilities
{
    public class DataTablesColumn
    {
        public String Data { get; set; }
        public String Name { get; set; }
        public Boolean Orderable { get; set; }
        public Boolean Searchable { get; set; }
        public String SearchValue { get; set; }
        public Boolean SearchRegex { get; set; }
    }
}