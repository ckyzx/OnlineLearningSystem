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

                Boolean changed;
                List<ExaminationPaperTemplate> epts;

                changed = false;

                epts =
                    olsEni
                    .ExaminationPaperTemplates
                    .Where(m =>
                        (m.EPT_PaperTemplateStatus == (Byte)PaperTemplateStatus.Undone 
                        || m.EPT_PaperTemplateStatus == (Byte)PaperTemplateStatus.Doing)
                        && m.EPT_Status == (Byte)Status.Available)
                    .ToList();

                foreach (var ept in epts)
                {

                    if (ept.EPT_PaperTemplateStatus == (Byte)PaperTemplateStatus.Undone
                        && now > ept.EPT_StartTime)
                    {
                        ept.EPT_PaperTemplateStatus = (Byte)PaperTemplateStatus.Doing;
                        changed = true;
                    }
                    else if (ept.EPT_PaperTemplateStatus == (Byte)PaperTemplateStatus.Doing
                        && ept.EPT_TimeSpan != 0
                        && now > ept.EPT_EndTime)
                    {
                        ept.EPT_PaperTemplateStatus = (Byte)PaperTemplateStatus.Done;
                        changed = true;
                    }
                }

                if (changed)
                {
                    if (0 == olsEni.SaveChanges())
                    {
                        resJson.status = ResponseStatus.Error;
                        resJson.message = ResponseMessage.SaveChangeError;
                    }
                }

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