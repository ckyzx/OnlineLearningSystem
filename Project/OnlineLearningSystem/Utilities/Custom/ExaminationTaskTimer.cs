using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using OnlineLearningSystem.Models;

namespace OnlineLearningSystem.Utilities
{
    public class ExaminationTaskTimer : Utility
    {
        public void ChangeExerciseTaskEnabled()
        {

            Boolean changed;
            List<ExaminationTask> ets;

            try
            {

                changed = false;

                ets = 
                    olsEni
                    .ExaminationTasks
                    .Where(m => 
                        m.ET_Type == (Byte)ExaminationTaskType.Exercise
                        && m.ET_Enabled != (Byte)ExaminationTaskStatus.Disabled
                        && m.ET_Status == (Byte)Status.Available)
                    .ToList();

                foreach (var et in ets)
                {
                    if (et.ET_Enabled == (Byte)ExaminationTaskStatus.Unset
                        && et.ET_StartTime < now
                        && et.ET_EndTime > now)
                    {
                        et.ET_Enabled = (Byte)ExaminationTaskStatus.Enabled;
                        changed = true;
                    }
                    else if (et.ET_Enabled == (Byte)ExaminationTaskStatus.Enabled
                        && et.ET_EndTime < now)
                    {
                        et.ET_Enabled = (Byte)ExaminationTaskStatus.Disabled;
                        changed = true;
                    }
                }

                if (changed)
                {
                    olsEni.SaveChanges();
                }

            }
            catch (Exception ex)
            {
                StaticHelper.RecordSystemLog(ex);
            }
        }
    }
}