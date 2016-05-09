using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using OnlineLearningSystem.Models;

namespace OnlineLearningSystem.Utilities
{
    public class ChangePaperStatus : Utility
    {
        public ResponseJson Change()
        {

            ResponseJson resJson;

            resJson = new ResponseJson(ResponseStatus.Success);

            try
            {

                Boolean unsaved;
                ExaminationPaperTemplate ept;
                ExaminationTask et;
                UExaminationPaperTemplate uept;
                List<ExaminationPaper> eps;

                unsaved = false;
                uept = new UExaminationPaperTemplate();

                eps =
                    olsEni
                    .ExaminationPapers
                    .Where(m =>
                        m.EP_PaperStatus == (Byte)PaperStatus.Doing
                        && m.EP_Status == (Byte)Status.Available)
                    .ToList();

                foreach (var ep in eps)
                {

                    et = olsEni.ExaminationTasks.Single(m => m.ET_Id == ep.ET_Id);

                    // 不处理练习任务
                    if (et.ET_Type == (Byte)ExaminationTaskType.Exercise)
                        continue;

                    // 考试时长无限制、试卷模板已终止，则关闭试卷、计算成绩
                    if (ep.EP_TimeSpan == 0)
                    {
                        ept = olsEni.ExaminationPaperTemplates.Single(m => m.EPT_Id == ep.EPT_Id);
                        if ((Byte)PaperTemplateStatus.Done == ept.EPT_PaperTemplateStatus)
                        {
                            ep.EP_PaperStatus = (Byte)PaperStatus.Done;
                            if (1 != olsEni.SaveChanges())
                            {
                                unsaved = true;
                            }
                            uept.GradePaper(ep);
                            uept.SaveChanges();
                        }
                    }
                    else if (now > ep.EP_EndTime)
                    {
                        ep.EP_PaperStatus = (Byte)PaperStatus.Done;
                        if (1 != olsEni.SaveChanges())
                        {
                            unsaved = true;
                        }
                        uept.GradePaper(ep);
                        uept.SaveChanges();
                    }
                }

                if (unsaved)
                {
                    resJson.status = ResponseStatus.Error;
                    resJson.message = ResponseMessage.SaveChangesError;
                }

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