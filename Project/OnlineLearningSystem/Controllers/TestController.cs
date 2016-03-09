using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using OnlineLearningSystem.Utilities;
using Newtonsoft.Json;

namespace OnlineLearningSystem.Controllers
{
    public class TestController : Controller
    {
        //
        // GET: /Test/

        public ActionResult Index()
        {
            return View();
        }

        //
        // GET: /Test/RunGeneratePaperTemplate

        public String RunGeneratePaperTemplate()
        {
            return JsonConvert.SerializeObject(new GeneratePaperTemplate().Generate());
        }

        //
        // GET: /Test/RunChangePaperStatus

        public String RunChangePaperStatus()
        {
            return JsonConvert.SerializeObject(new ChangePaperStatus().Change());
        }

        //
        // GET: /Test/RunChangePaperTemplateStatus

        public String RunChangePaperTemplateStatus()
        {
            return JsonConvert.SerializeObject(new ChangePaperTemplateStatus().Change());
        }

    }
}
