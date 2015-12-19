using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace OnlineLearningSystem.Utilities
{
    public class Utility
    {
        public OLSEntities olsEni = new OLSEntities();
        protected DbOperator olsDBO = new DbOperator("OLSDBO");
        public DateTime now = DateTime.Now;
    }
}