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

        public DbSet<User> Users { get; set; }
        public DbSet<Duty> Duties { get; set; }
        public DbSet<Department> Departments { get; set; }
        public DbSet<Role> Roles { get; set; }
        public DbSet<Permission> Permissions { get; set; }
        public DbSet<PermissionCategory> PermissionCategories { get; set; }

        public DbSet<ExaminationTaskTemplate> ExaminationTaskTemplates { get; set; }
        public DbSet<ExaminationTask> ExaminationTasks { get; set; }
        public DbSet<ExaminationPaperTemplate> ExaminationPaperTemplates { get; set; }
        public DbSet<ExaminationPaperTemplateQuestion> ExaminationPaperTemplateQuestions { get; set; }
        public DbSet<ExaminationPaper> ExaminationPapers { get; set; }
        public DbSet<ExaminationPaperQuestion> ExaminationPaperQuestions { get; set; }

        public DbSet<User_Department> User_Department { get; set; }
        public DbSet<User_Role> User_Role { get; set; }
        public DbSet<Role_Permission> Role_Permission { get; set; }
        public DbSet<Department_Role> Department_Role { get; set; }
    }
}