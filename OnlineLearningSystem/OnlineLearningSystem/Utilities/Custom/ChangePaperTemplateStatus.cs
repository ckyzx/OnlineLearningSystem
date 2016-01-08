using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using OnlineLearningSystem.Models;

namespace OnlineLearningSystem.Utilities
{
    public class ChangePaperTemplateStatus : Utility
    {
        public ResponseJson Change()
        {

            ResponseJson resJson;

            resJson = new ResponseJson(ResponseStatus.Success);

            try
            {

                Int32 success;
                Boolean changed;
                ExaminationTask et;
                Dictionary<String, String> data;
                List<ExaminationPaperTemplate> epts;

                success = 0;
                changed = false;
                data = new Dictionary<string, string>();

                epts =
                    olsEni
                    .ExaminationPaperTemplates
                    .Where(m =>
                        (m.EPT_PaperTemplateStatus == (Byte)PaperTemplateStatus.Undone
                        || m.EPT_PaperTemplateStatus == (Byte)PaperTemplateStatus.Doing)
                        && m.EPT_Status == (Byte)Status.Available)
                    .ToList();
                data.Add(
                    "RecordInfo", "共有 " + epts.Count + "条记录。" +
                    "其中“未做” " + epts.Where(m => m.EPT_PaperTemplateStatus == (Byte)PaperTemplateStatus.Undone).Count() + "条；" +
                    "“进行中” " + epts.Where(m => m.EPT_PaperTemplateStatus == (Byte)PaperTemplateStatus.Doing).Count() + "条。");

                foreach (var ept in epts)
                {

                    et = olsEni.ExaminationTasks.Single(m => m.ET_Id == ept.ET_Id);
                    if ((Byte)ExaminationTaskStatus.Enabled != et.ET_Enabled 
                        && ept.EPT_PaperTemplateStatus == (Byte)PaperTemplateStatus.Doing)
                    {
                        ept.EPT_PaperTemplateStatus = (Byte)PaperTemplateStatus.Done;
                        changed = true;
                        continue;
                    }

                    if (ept.EPT_PaperTemplateStatus == (Byte)PaperTemplateStatus.Undone
                        && now > ept.EPT_StartTime)
                    {
                        ept.EPT_PaperTemplateStatus = (Byte)PaperTemplateStatus.Doing;
                        changed = true;
                        success += 1;
                    }
                    else if (ept.EPT_PaperTemplateStatus == (Byte)PaperTemplateStatus.Doing
                        && ept.EPT_TimeSpan != 0
                        && now > ept.EPT_EndTime)
                    {

                        ept.EPT_PaperTemplateStatus = (Byte)PaperTemplateStatus.Done;

                        if ((Byte)AutoType.Manual == et.ET_AutoType)
                        {
                            et.ET_Enabled = (Byte)ExaminationTaskStatus.Disabled;
                        }

                        changed = true;
                        success += 1;
                    }
                }

                if (changed)
                {
                    if (0 == olsEni.SaveChanges())
                    {
                        resJson.status = ResponseStatus.Error;
                        resJson.message = ResponseMessage.SaveChangesError;
                    }
                }

                data.Add("SuccessInfo", "成功处理 " + success + "条记录。");
                resJson.data = data;
                return resJson;
            }
            catch (Exception ex)
            {
                resJson.status = ResponseStatus.Error;
                resJson.message = StaticHelper.GetExceptionMessage(ex);
                return resJson;
            }
        }
    }
}