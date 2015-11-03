using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace OnlineLearningSystem.Utilities
{
    public static class StaticHelper
    {
        public static List<SelectListItem> GetStatusList(String currentValue){

            List<SelectListItem> items;

            items = new List<SelectListItem>();
            items.Add(new SelectListItem() { Text = "启用", Value = "1" });
            items.Add(new SelectListItem() { Text = "回收", Value = "2" });
            items.Add(new SelectListItem() { Text = "删除", Value = "3" });

            foreach (var i in items)
            {
                if (i.Value == currentValue)
                {
                    i.Selected = true;
                }
            }

            return items;
        }
    }
}