using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Timers;

namespace OnlineLearningSystem.Utilities
{
    public static class TimerTask
    {

        public static void Run(Int32 interval, ElapsedEventHandler eventHandler)
        {
            Timer timer;

            timer = new Timer(interval);
            timer.Elapsed += new ElapsedEventHandler(eventHandler);
            timer.Enabled = true;
            timer.AutoReset = true;
        }

        public static void GeneratePaperTemplate(object source, ElapsedEventArgs e)
        {

            GeneratePaperTemplate gpt;
            ResponseJson resJson;

            gpt = new GeneratePaperTemplate();
            resJson = gpt.Generate();

            //TODO: 记录错误日志
        }

        public static void ChangePaperStatus(object source, ElapsedEventArgs e)
        {

            ChangePaperStatus cps;
            ResponseJson resJson;

            cps = new ChangePaperStatus();
            resJson = cps.Change();

            //TODO: 记录错误日志
        }

        public static void ChangePaperTemplateStatus(object source, ElapsedEventArgs e)
        {

            ChangePaperTemplateStatus cpts;
            ResponseJson resJson;

            cpts = new ChangePaperTemplateStatus();
            resJson = cpts.Change();

            //TODO: 记录错误日志
        }
    }
}