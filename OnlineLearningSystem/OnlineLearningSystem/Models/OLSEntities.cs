using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data.Entity;
using OnlineLearningSystem.Models;

namespace OnlineLearningSystem
{
    public class OLSEntities:DbContext
    {
        public DbSet<Question> Questions { get; set; }
        public DbSet<QuestionClassify> QuestionClassifies { get; set; }
    }
}