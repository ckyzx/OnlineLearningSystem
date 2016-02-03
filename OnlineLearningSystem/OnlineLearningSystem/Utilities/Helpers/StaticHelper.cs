using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Reflection;
using OnlineLearningSystem.Controllers;
using OnlineLearningSystem.Models;
using System.Data;
using System.IO;

namespace OnlineLearningSystem.Utilities
{
    public static class StaticHelper
    {
        public static List<SelectListItem> GetStatusList(String currentValue)
        {

            List<SelectListItem> items;

            items = new List<SelectListItem>();
            items.Add(new SelectListItem() { Text = "启用", Value = "1" });
            items.Add(new SelectListItem() { Text = "回收", Value = "2" });
            items.Add(new SelectListItem() { Text = "删除", Value = "3" });
            items.Add(new SelectListItem() { Text = "缓存", Value = "4" });

            foreach (var i in items)
            {
                if (i.Value == currentValue)
                {
                    i.Selected = true;
                }
            }

            return items;
        }

        public static List<SelectListItem> GetExaminationTaskAutoType(String currentValue)
        {

            List<SelectListItem> items;

            items = new List<SelectListItem>();
            items.Add(new SelectListItem() { Text = "手动", Value = "0" });
            items.Add(new SelectListItem() { Text = "每日", Value = "1" });
            items.Add(new SelectListItem() { Text = "每周", Value = "2" });
            items.Add(new SelectListItem() { Text = "每月", Value = "3" });

            foreach (var i in items)
            {
                if (i.Value == currentValue)
                {
                    i.Selected = true;
                }
            }

            return items;
        }

        public static List<SelectListItem> GetExaminationTaskStatisticType(String currentValue)
        {

            List<SelectListItem> items;

            items = new List<SelectListItem>();
            items.Add(new SelectListItem() { Text = "[未设置]", Value = "0" });
            items.Add(new SelectListItem() { Text = "得分", Value = "1" });
            items.Add(new SelectListItem() { Text = "正确率", Value = "2" });

            foreach (var i in items)
            {
                if (i.Value == currentValue)
                {
                    i.Selected = true;
                }
            }

            return items;
        }

        public static List<SelectListItem> GetExaminationTaskType(String currentValue)
        {

            List<SelectListItem> items;

            items = new List<SelectListItem>();
            items.Add(new SelectListItem() { Text = "考试", Value = "0" });
            items.Add(new SelectListItem() { Text = "练习", Value = "1" });

            foreach (var i in items)
            {
                if (i.Value == currentValue)
                {
                    i.Selected = true;
                }
            }

            return items;
        }

        public static List<SelectListItem> GetExaminationTaskMode(String currentValue)
        {

            List<SelectListItem> items;

            items = new List<SelectListItem>();
            items.Add(new SelectListItem() { Text = "手动", Value = "0" });
            items.Add(new SelectListItem() { Text = "自动", Value = "1" });

            foreach (var i in items)
            {
                if (i.Value == currentValue)
                {
                    i.Selected = true;
                }
            }

            return items;
        }

        public static List<SelectListItem> GetExaminationTaskDifficultyCoefficient(String currentValue)
        {

            List<SelectListItem> items;

            items = new List<SelectListItem>();
            items.Add(new SelectListItem() { Text = "0", Value = "0" });
            items.Add(new SelectListItem() { Text = "1", Value = "1" });
            items.Add(new SelectListItem() { Text = "2", Value = "2" });
            items.Add(new SelectListItem() { Text = "3", Value = "3" });
            items.Add(new SelectListItem() { Text = "4", Value = "4" });
            items.Add(new SelectListItem() { Text = "5", Value = "5" });
            items.Add(new SelectListItem() { Text = "6", Value = "6" });
            items.Add(new SelectListItem() { Text = "7", Value = "7" });
            items.Add(new SelectListItem() { Text = "8", Value = "8" });
            items.Add(new SelectListItem() { Text = "9", Value = "9" });

            foreach (var i in items)
            {
                if (i.Value == currentValue)
                {
                    i.Selected = true;
                }
            }

            return items;
        }

        public static String GetExceptionMessageAndRecord(Exception ex)
        {

            String exDetail;
            String[] exMsgAry;

            exMsgAry = GetExceptionMessageWithSplit(ex);
            exDetail = String.Join("", exMsgAry);
            RecordSystemLog(SystemLogType.Exception, ex.Message, exDetail);

            return exDetail;
        }

        public static String GetExceptionMessage(Exception ex)
        {

            String exMsg;

            exMsg = "Message: " + ex.Message + "\\r\\n";
            exMsg += "Source: " + ex.Source + "\\r\\n";
            exMsg += "StackTrace: \\r\\n" + ex.StackTrace + "\\r\\n";

            if (null != ex.Data && null != ex.Data["Info"])
            {
                exMsg += "DataInfo: " + ex.Data["Info"] + "\\r\\n";
            }

            if (null != ex.InnerException)
            {
                exMsg += "\\r\\n" + GetExceptionMessage(ex.InnerException);
            }

            return exMsg;
        }

        public static String[] GetExceptionMessageWithSplit(Exception ex)
        {

            String message, stackTrace;
            String[] exMsgAry;

            message = "Message: " + ex.Message + "\\r\\n";
            stackTrace = "Source: " + ex.Source + "\\r\\n";
            stackTrace += "StackTrace: \\r\\n" + ex.StackTrace + "\\r\\n";

            if (null != ex.Data && null != ex.Data["Info"])
            {
                stackTrace += "DataInfo: " + ex.Data["Info"] + "\\r\\n";
            }

            if (null != ex.InnerException)
            {

                exMsgAry = GetExceptionMessageWithSplit(ex.InnerException);

                stackTrace += "Inner Detail: \\r\\n" + exMsgAry[0] + "\\r\\n";
                stackTrace += exMsgAry[1] + "\\r\\n";
            }

            return new String[] { message, stackTrace };
        }

        public static void RecordSystemLog(Exception ex)
        {
            RecordSystemLog(SystemLogType.Exception, ex.Message, GetExceptionMessage(ex), "");
        }

        public static void RecordSystemLog(SystemLogType type, String name, String content)
        {
            RecordSystemLog(type, name, content, "");
        }

        public static void RecordSystemLog(SystemLogType type, String name, String content, String remark)
        {
            try
            {

                SystemLog sl;
                OLSEntities olsEni;

                sl = new SystemLog
                {
                    SL_Name = name,
                    SL_Type = (Byte)type,
                    SL_Content = content,
                    SL_Remark = remark,
                    SL_Status = (Byte)Status.Available,
                    SL_AddTime = DateTime.Now
                };

                olsEni = new OLSEntities();
                olsEni.Entry(sl).State = EntityState.Added;
                if (0 == olsEni.SaveChanges())
                {
                    throw new Exception(ResponseMessage.SaveChangesError);
                }
            }
            catch (Exception ex)
            {
                RecordInnerLog(ex);
            }
        }

        private static void RecordInnerLog(Exception ex)
        {

            String txtFile;
            FileStream fs;
            StreamWriter sw;

            txtFile = AppDomain.CurrentDomain.BaseDirectory + "ErrorLogs\\";
            if (!Directory.Exists(txtFile))
            {
                Directory.CreateDirectory(txtFile);
            }
            txtFile += DateTime.Now.Ticks + ".txt";

            fs = new FileStream(txtFile, FileMode.OpenOrCreate);
            sw = new StreamWriter(fs);

            sw.WriteLine(GetExceptionMessage(ex));
            sw.Close();
        }

        public static List<ActionPermission> GetActionPermission()
        {

            List<ActionPermission> aps;
            Type[] types;

            aps = new List<ActionPermission>();
            types = Assembly.Load("OnlineLearningSystem").GetTypes();

            foreach (var type in types)
            {
                if (type.BaseType.Name == "OLSController")//如果是Controller
                {
                    var members = type.GetMethods();
                    foreach (var member in members)
                    {
                        if (member.ReturnType.Name == "ActionResult"
                            || member.ReturnType.Name == "JsonResult")//如果是Action
                        {

                            var ap = new ActionPermission();

                            ap.ActionName = member.Name;
                            ap.ControllerName = member.DeclaringType.Name.Substring(0, member.DeclaringType.Name.Length - 10); // 去掉“Controller”后缀

                            object[] attrs = member.GetCustomAttributes(typeof(System.ComponentModel.DescriptionAttribute), true);
                            if (attrs.Length > 0)
                            {
                                ap.Description = (attrs[0] as System.ComponentModel.DescriptionAttribute).Description;
                                aps.Add(ap);
                            }
                        }

                    }
                }
            }
            return aps;
        }

        public static Decimal MathRound(Double num, Int32 decimals)
        {

            Int32 dotPos;
            String numString;

            numString = num.ToString();

            dotPos = numString.IndexOf(".");
            decimals += dotPos + 1;

            if (numString.Length < decimals)
            {
                return (Decimal)num;
            }

            return Convert.ToDecimal(num.ToString().Substring(0, decimals));
        }
    }
}