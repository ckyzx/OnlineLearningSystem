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

                Int32 success, operate;
                Boolean changed;
                ExaminationTask et;
                Dictionary<String, String> data;
                List<ExaminationPaperTemplate> epts;

                success = 0;
                operate = 0;
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

                    // 不处理练习任务
                    if (et.ET_Type == (Byte)ExaminationTaskType.Exercise)
                        continue;

                    if ((Byte)ExaminationTaskStatus.Enabled != et.ET_Enabled
                        && et.ET_Mode != (Byte)ExaminationTaskMode.Auto
                        && ept.EPT_PaperTemplateStatus == (Byte)PaperTemplateStatus.Undone)
                    {
                        // 当任务状态为“关闭”，出题类型为“手动”、“预定”，模板状态为“未开始”。
                        // 符合条件时，不处理。
                        continue;
                    }else if ((Byte)ExaminationTaskStatus.Enabled != et.ET_Enabled)
                    {
                        // 当任务状态为“关闭”，出题类型为“自动”。
                        // 符合条件时，关闭考试（将模板设为“关闭”）。
                        ept.EPT_PaperTemplateStatus = (Byte)PaperTemplateStatus.Done;
                        changed = true;
                        success += 1;
                        operate += 1;
                    }
                    else if (ept.EPT_PaperTemplateStatus == (Byte)PaperTemplateStatus.Undone
                       && now > ept.EPT_StartTime)
                    {
                        // 当模板状态为“未开始”，已到“考试开始时间”。
                        // 符合条件时，开始考试（将模板设为“进行中”）。
                        ept.EPT_PaperTemplateStatus = (Byte)PaperTemplateStatus.Doing;
                        changed = true;
                        success += 1;
                    }
                    else if (ept.EPT_PaperTemplateStatus == (Byte)PaperTemplateStatus.Doing
                        && ept.EPT_TimeSpan != 0
                        && now > ept.EPT_EndTime)
                    {
                        // 当模板状态为“进行中”，考试时长非零，已到“考试结束时间”。
                        // 符合条件时，关闭考试（将模板设为“关闭”）。
                        ept.EPT_PaperTemplateStatus = (Byte)PaperTemplateStatus.Done;

                        // 当出题方式为“手动”、“预定”时，同时将任务设为“关闭”。
                        if (et.ET_AutoType != (Byte)ExaminationTaskMode.Auto)
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

                data.Add("OperateInfo", "终止已关闭考试任务的试卷模板 " + operate + "条。");
                data.Add("SuccessInfo", "成功处理 " + success + "条记录。");
                resJson.data = data;
                return resJson;
            }
            catch (Exception ex)
            {
                resJson.status = ResponseStatus.Error;
                resJson.message = ex.Message;
                resJson.detail = StaticHelper.GetExceptionMessageAndRecord(ex);
                return resJson;
            }
        }
    }
}