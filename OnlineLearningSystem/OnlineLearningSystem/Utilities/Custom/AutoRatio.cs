using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace OnlineLearningSystem.Utilities
{
    public class AutoRatio
    {
        public String type { get; set; }
        public Decimal percent { get; set; }

        public AutoRatio() { }

        public AutoRatio(String type, Decimal percent)
        {
            this.type = type;
            this.percent = percent;
        }

        public AutoRatio(String type, Int32 percent)
        {
            this.type = type;
            this.percent = percent;
        }

        public AutoRatio(String type, Double percent)
        {
            this.type = type;
            this.percent = (Decimal)percent;
        }
    }
}