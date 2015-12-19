using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Reflection;

namespace OnlineLearningSystem.Utilities
{
    public class ModelConvert<T> where T : new()
    {
        public static IList<T> ConvertToModel(DataTable dt)
        {
            // 定义集合
            IList<T> ts = new List<T>();

            // 获得此模型的类型
            Type type = typeof(T);

            string tempName = "";

            foreach (DataRow dr in dt.Rows)
            {
                T t = new T();

                // 获得此模型的公共属性
                PropertyInfo[] properties = t.GetType().GetProperties();

                foreach (PropertyInfo pi in properties)
                {
                    tempName = pi.Name;

                    // 检查DataTable是否包含此列
                    if (dt.Columns.Contains(tempName))
                    {
                        // 判断此属性是否有Setter
                        if (!pi.CanWrite) continue;

                        object value = dr[tempName];
                        if (value != DBNull.Value)
                        {
                            switch (pi.PropertyType.ToString())
                            {
                                case "System.Byte":

                                    pi.SetValue(t, Convert.ToByte(value), null);

                                    break;

                                case "System.DateTime":

                                    pi.SetValue(t, Convert.ToDateTime(value), null);

                                    break;

                                case "System.Int16":

                                    pi.SetValue(t, Convert.ToInt16(value), null);

                                    break;

                                case "System.Int32":

                                    pi.SetValue(t, Convert.ToInt32(value), null);

                                    break;

                                case "System.Decimal":

                                    pi.SetValue(t, Convert.ToDecimal(value), null);

                                    break;

                                default:

                                    pi.SetValue(t, value, null);

                                    break;

                            }

                        }
                    }
                }

                ts.Add(t);
            }

            return ts;

        }

        public static T Fill()
        {
            T t;
            PropertyInfo[] properties;

            t = new T();
            properties = t.GetType().GetProperties();

            foreach (PropertyInfo pi in properties)
            {
                switch (pi.PropertyType.ToString())
                {
                    case "System.String":

                        pi.SetValue(t, "", null);

                        break;

                    case "System.DateTime":

                        pi.SetValue(t, DateTime.Now, null);

                        break;

                    case "System.Int16":

                        pi.SetValue(t, Convert.ToInt16(0), null);

                        break;


                    case "System.Int32":

                        pi.SetValue(t, 0, null);

                        break;

                    case "System.Decimal":

                        pi.SetValue(t, Convert.ToDecimal(0), null);

                        break;

                    case "System.Byte":

                        pi.SetValue(t, Convert.ToByte(0), null);

                        break;

                    case "System.Boolean":

                        pi.SetValue(t, false, null);

                        break;

                    default:

                        break;
                }
            }

            return t;
        }
    }
}