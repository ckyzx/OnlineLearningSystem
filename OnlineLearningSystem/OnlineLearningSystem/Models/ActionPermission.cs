using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace OnlineLearningSystem.Models
{
    public class ActionPermission
    {
        public String ControllerName { get; set; }
        public String ActionName { get; set; }
        public String Description { get; set; }
    }
}