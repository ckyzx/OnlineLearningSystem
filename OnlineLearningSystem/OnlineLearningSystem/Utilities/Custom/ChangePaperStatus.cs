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

                Boolean changed;
                List<ExaminationPaper> eps;

                changed = false;

                eps =
                    olsEni
                    .ExaminationPapers
                    .Where(m =>
                        m.EP_PaperStatus == (Byte)PaperStatus.Doing
                        && m.EP_Status == (Byte)Status.Available)
                    .ToList();

                foreach (var ep in eps)
                {

                    if (ep.EP_TimeSpan == 0)
                    {
                        continue;
                    }

                    if (now > ep.EP_EndTime)
                    {
                        ep.EP_PaperStatus = (Byte)PaperStatus.Done;
                        new UExaminationPaperTemplate().GradePaper(ep);
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