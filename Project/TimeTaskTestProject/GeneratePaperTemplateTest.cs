using OnlineLearningSystem.Utilities;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Diagnostics;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Microsoft.VisualStudio.TestTools.UnitTesting.Web;
using OnlineLearningSystem.Models;

namespace TimeTaskTestProject
{

    /// <summary>
    ///这是 GeneratePaperTemplateTest 的测试类，旨在
    ///包含所有 GeneratePaperTemplateTest 单元测试
    ///</summary>
    [TestClass()]
    public class GeneratePaperTemplateTest : Test
    {

        private TestContext testContextInstance;

        /// <summary>
        ///获取或设置测试上下文，上下文提供
        ///有关当前测试运行及其功能的信息。
        ///</summary>
        public TestContext TestContext
        {
            get
            {
                return testContextInstance;
            }
            set
            {
                testContextInstance = value;
            }
        }

        #region 附加测试特性
        // 
        //编写测试时，还可使用以下特性:
        //
        //使用 ClassInitialize 在运行类中的第一个测试前先运行代码
        //[ClassInitialize()]
        //public static void MyClassInitialize(TestContext testContext)
        //{
        //}
        //
        //使用 ClassCleanup 在运行完类中的所有测试后再运行代码
        //[ClassCleanup()]
        //public static void MyClassCleanup()
        //{
        //}
        
        // 使用 TestInitialize 在运行每个测试前先运行代码
        [TestInitialize()]
        public void MyTestInitialize()
        {

            Int32 result;

            result = olsDbo.ExecuteProcedure("dbo.UnitTesting_DeleteExaminationTask", new SqlParameter[] { new SqlParameter("@etName", "单元测试") });

            Debug.WriteLine("“清除考试任务”操作返回 " + result + " 。");
        }

        // 使用 TestCleanup 在运行完每个测试后运行代码
        [TestCleanup()]
        public void MyTestCleanup()
        {

            Int32 result;

            result = olsDbo.ExecuteProcedure("dbo.UnitTesting_DeleteExaminationTask", new SqlParameter[] { new SqlParameter("@etName", "单元测试") });

            Debug.WriteLine("“清除考试任务”操作返回 " + result + " 。");
        }

        #endregion

        /// <summary>
        /// WhetherGenerate 的测试
        ///   Cond1: 当前时间未超过开始时间
        ///     Cond2: 自动类型为“每日”
        ///     Cond3: 不存在相同日期的“试卷模板”
        ///   Expected: true
        ///</summary>
        [TestMethod()]
        [HostType("ASP.NET")]
        [AspNetDevelopmentServerHost("D:\\Cheng\\Workspace\\OnlineLearningSystem\\OnlineLearningSystem\\OnlineLearningSystem", "/")]
        [UrlToTest("http://localhost:7128/Aspxs/Default.aspx")]
        [DeploymentItem("OnlineLearningSystem.dll")]
        public void WhetherGenerateTest1()
        {

            int id;
            bool expected, actual;
            DateTime now, startTime;
            ExaminationTask et;
            UExaminationTask uet;
            GeneratePaperTemplate_Accessor target = new GeneratePaperTemplate_Accessor();


            #region 添加测试数据
            now = DateTime.Now;
            startTime = new DateTime(1970, 1, 1, now.AddHours(1).Hour, now.Minute, 0);

            uet = new UExaminationTask();
            id = new Utility().GetETId();
            et = new ExaminationTask
            {
                ET_Id = id,
                ET_Name = "单元测试每日自动任务1",
                ET_Enabled = (Byte)ExaminationTaskStatus.Enabled,
                ET_Type = (Byte)ExaminationTaskType.Examination,
                ET_ParticipatingDepartment = "[6,9]",
                ET_Attendee = "[6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,39,40,41,42,43,44,45]",
                ET_StatisticType = (Byte)StatisticType.Score,
                ET_TotalScore = 100,
                ET_TotalNumber = 10,
                ET_Mode = (Byte)ExaminationTaskMode.Auto,
                ET_AutoType = (Byte)AutoType.Day,
                ET_AutoOffsetDay = 0,
                ET_DifficultyCoefficient = 0,
                ET_AutoClassifies = "[\"综合、公文、绩效知识（90题）\",\"所得税知识（180题）\",\"营业税知识（60题）\",\"其他地方税知识（180题）\",\"税收征管法、相关法律法规及征管制度（253题）\",\"规费知识（130题）\",\"纳税服务知识（95题）\"]",
                ET_AutoRatio = "[{\"type\":\"单选题\",\"percent\":0.2},{\"type\":\"多选题\",\"percent\":0.2},{\"type\":\"判断题\",\"percent\":0.2},{\"type\":\"公文改错题\",\"percent\":0.1},{\"type\":\"计算题\",\"percent\":0.1},{\"type\":\"案例分析题\",\"percent\":0.1},{\"type\":\"问答题\",\"percent\":0.1}]",
                ET_StartTime = startTime,
                ET_EndTime = startTime,
                ET_TimeSpan = 0,
                ET_PaperTemplates = "[]",
                ET_Questions = "[]",
                ET_Remark = "",
                ET_AddTime = now,
                ET_Status = (Byte)Status.Available
            };
            olsEni.Entry(et).State = EntityState.Added;
            if (0 == olsEni.SaveChanges())
            {
                Assert.Fail("添加测试数据失败。");
            }
            #endregion

            expected = true;
            actual = target.WhetherGenerate(et);

            #region 删除测试数据
            olsEni.Entry(et).State = EntityState.Deleted;
            if (0 == olsEni.SaveChanges())
            {
                Assert.Fail("删除测试数据失败。id值为 " + id + " 。");
            }
            #endregion

            Assert.AreEqual(expected, actual);
        }

        /// <summary>
        /// WhetherGenerate 的测试
        ///   Cond1: 当前时间超过开始时间
        ///     Cond2: 自动类型为“每日”
        ///     Cond3: 不存在相同日期的“试卷模板”
        ///   Expected: false
        ///</summary>
        [TestMethod()]
        [HostType("ASP.NET")]
        [AspNetDevelopmentServerHost("D:\\Cheng\\Workspace\\OnlineLearningSystem\\OnlineLearningSystem\\OnlineLearningSystem", "/")]
        [UrlToTest("http://localhost:7128/Aspxs/Default.aspx")]
        [DeploymentItem("OnlineLearningSystem.dll")]
        public void WhetherGenerateTest1_1()
        {

            int id;
            bool expected, actual;
            DateTime now, startTime;
            ExaminationTask et;
            UExaminationTask uet;
            GeneratePaperTemplate_Accessor target = new GeneratePaperTemplate_Accessor();


            #region 添加测试数据
            now = DateTime.Now;
            startTime = new DateTime(1970, 1, 1, now.AddHours(-1).Hour, now.Minute, 0);

            uet = new UExaminationTask();
            id = new Utility().GetETId();
            et = new ExaminationTask
            {
                ET_Id = id,
                ET_Name = "单元测试每日自动任务1",
                ET_Enabled = (Byte)ExaminationTaskStatus.Enabled,
                ET_Type = (Byte)ExaminationTaskType.Examination,
                ET_ParticipatingDepartment = "[6,9]",
                ET_Attendee = "[6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,39,40,41,42,43,44,45]",
                ET_StatisticType = (Byte)StatisticType.Score,
                ET_TotalScore = 100,
                ET_TotalNumber = 10,
                ET_Mode = (Byte)ExaminationTaskMode.Auto,
                ET_AutoType = (Byte)AutoType.Day,
                ET_AutoOffsetDay = 0,
                ET_DifficultyCoefficient = 0,
                ET_AutoClassifies = "[\"综合、公文、绩效知识（90题）\",\"所得税知识（180题）\",\"营业税知识（60题）\",\"其他地方税知识（180题）\",\"税收征管法、相关法律法规及征管制度（253题）\",\"规费知识（130题）\",\"纳税服务知识（95题）\"]",
                ET_AutoRatio = "[{\"type\":\"单选题\",\"percent\":0.2},{\"type\":\"多选题\",\"percent\":0.2},{\"type\":\"判断题\",\"percent\":0.2},{\"type\":\"公文改错题\",\"percent\":0.1},{\"type\":\"计算题\",\"percent\":0.1},{\"type\":\"案例分析题\",\"percent\":0.1},{\"type\":\"问答题\",\"percent\":0.1}]",
                ET_StartTime = startTime,
                ET_EndTime = startTime,
                ET_TimeSpan = 0,
                ET_PaperTemplates = "[]",
                ET_Questions = "[]",
                ET_Remark = "",
                ET_AddTime = now,
                ET_Status = (Byte)Status.Available
            };
            olsEni.Entry(et).State = EntityState.Added;
            if (0 == olsEni.SaveChanges())
            {
                Assert.Fail("添加测试数据失败。");
            }
            #endregion

            expected = false;
            actual = target.WhetherGenerate(et);

            #region 删除测试数据
            olsEni.Entry(et).State = EntityState.Deleted;
            if (0 == olsEni.SaveChanges())
            {
                Assert.Fail("删除测试数据失败。id值为 " + id + " 。");
            }
            #endregion

            Assert.AreEqual(expected, actual);
        }

        /// <summary>
        /// WhetherGenerate 的测试
        ///   Cond1: 当前时间不超过开始时间
        ///     Cond2: 自动类型为“每日”
        ///     Cond3: 存在相同日期的“试卷模板”
        ///   Expected: false
        ///</summary>
        [TestMethod()]
        [HostType("ASP.NET")]
        [AspNetDevelopmentServerHost("D:\\Cheng\\Workspace\\OnlineLearningSystem\\OnlineLearningSystem\\OnlineLearningSystem", "/")]
        [UrlToTest("http://localhost:7128/Aspxs/Default.aspx")]
        [DeploymentItem("OnlineLearningSystem.dll")]
        public void WhetherGenerateTest1_2()
        {

            int etId, eptId;
            bool expected, actual;
            DateTime now, startTime;
            ExaminationTask et;
            ExaminationPaperTemplate ept;
            UExaminationTask uet;
            GeneratePaperTemplate_Accessor target = new GeneratePaperTemplate_Accessor();


            #region 添加测试数据
            now = DateTime.Now;
            startTime = new DateTime(1970, 1, 1, now.AddHours(1).Hour, now.Minute, 0);

            uet = new UExaminationTask();
            etId = new Utility().GetETId();
            et = new ExaminationTask
            {
                ET_Id = etId,
                ET_Name = "单元测试每日自动任务1",
                ET_Enabled = (Byte)ExaminationTaskStatus.Enabled,
                ET_Type = (Byte)ExaminationTaskType.Examination,
                ET_ParticipatingDepartment = "[6,9]",
                ET_Attendee = "[6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,39,40,41,42,43,44,45]",
                ET_StatisticType = (Byte)StatisticType.Score,
                ET_TotalScore = 100,
                ET_TotalNumber = 10,
                ET_Mode = (Byte)ExaminationTaskMode.Auto,
                ET_AutoType = (Byte)AutoType.Day,
                ET_AutoOffsetDay = 0,
                ET_DifficultyCoefficient = 0,
                ET_AutoClassifies = "[\"综合、公文、绩效知识（90题）\",\"所得税知识（180题）\",\"营业税知识（60题）\",\"其他地方税知识（180题）\",\"税收征管法、相关法律法规及征管制度（253题）\",\"规费知识（130题）\",\"纳税服务知识（95题）\"]",
                ET_AutoRatio = "[{\"type\":\"单选题\",\"percent\":0.2},{\"type\":\"多选题\",\"percent\":0.2},{\"type\":\"判断题\",\"percent\":0.2},{\"type\":\"公文改错题\",\"percent\":0.1},{\"type\":\"计算题\",\"percent\":0.1},{\"type\":\"案例分析题\",\"percent\":0.1},{\"type\":\"问答题\",\"percent\":0.1}]",
                ET_StartTime = startTime,
                ET_EndTime = startTime,
                ET_TimeSpan = 0,
                ET_PaperTemplates = "[]",
                ET_Questions = "[]",
                ET_Remark = "",
                ET_AddTime = now,
                ET_Status = (Byte)Status.Available
            };
            olsEni.Entry(et).State = EntityState.Added;
            if (0 == olsEni.SaveChanges())
            {
                Assert.Fail("添加测试数据失败。");
            }

            eptId = uet.GetEPTId();
            startTime = new DateTime(now.Year, now.Month, now.Day, startTime.Hour, startTime.Minute, startTime.Second);
            ept = new ExaminationPaperTemplate
            {
                EPT_Id = eptId,
                ET_Id = etId,
                ET_Type = et.ET_Type,
                ET_Name = et.ET_Name,
                EPT_PaperTemplateStatus = (Byte)PaperTemplateStatus.Undone,
                EPT_StartDate = now.Date,
                EPT_StartTime = startTime,
                EPT_EndTime = startTime.AddMinutes(et.ET_TimeSpan),
                EPT_TimeSpan = et.ET_TimeSpan,
                EPT_Questions = "[]",
                EPT_Remark = "",
                EPT_AddTime = now,
                EPT_Status = (Byte)Status.Available
            };
            olsEni.Entry(ept).State = EntityState.Added;
            if (0 == olsEni.SaveChanges())
            {
                Assert.Fail("添加测试数据失败。");
            }
            #endregion

            expected = false;
            actual = target.WhetherGenerate(et);

            #region 删除测试数据
            olsEni.Entry(ept).State = EntityState.Deleted;
            if (0 == olsEni.SaveChanges())
            {
                Assert.Fail("删除测试数据失败。试卷模板 id值为 " + eptId + " 。");
            }
            olsEni.Entry(et).State = EntityState.Deleted;
            if (0 == olsEni.SaveChanges())
            {
                Assert.Fail("删除测试数据失败。考试任务 id值为 " + etId + " 。");
            }
            #endregion

            Assert.AreEqual(expected, actual);
        }

        /// <summary>
        /// WhetherGenerate 的测试
        ///   Cond1: 当前时间未超过开始时间
        ///     Cond2: 自动类型为“每周”
        ///     Cond3: 不存在相同日期的“试卷模板”
        ///   Expected: true
        ///</summary>
        [TestMethod()]
        [HostType("ASP.NET")]
        [AspNetDevelopmentServerHost("D:\\Cheng\\Workspace\\OnlineLearningSystem\\OnlineLearningSystem\\OnlineLearningSystem", "/")]
        [UrlToTest("http://localhost:7128/Aspxs/Default.aspx")]
        [DeploymentItem("OnlineLearningSystem.dll")]
        public void WhetherGenerateTest2()
        {

            int id, dayOfWeek;
            bool expected, actual;
            DateTime now, startTime;
            ExaminationTask et;
            UExaminationTask uet;
            GeneratePaperTemplate_Accessor target = new GeneratePaperTemplate_Accessor();


            #region 添加测试数据
            now = DateTime.Now;
            startTime = new DateTime(1970, 1, 1, now.AddHours(1).Hour, now.Minute, 0);
            dayOfWeek = (Byte)now.DayOfWeek;
            dayOfWeek = 0 == dayOfWeek ? 7 : dayOfWeek;

            uet = new UExaminationTask();
            id = new Utility().GetETId();
            et = new ExaminationTask
            {
                ET_Id = id,
                ET_Name = "单元测试每周自动任务1",
                ET_Enabled = (Byte)ExaminationTaskStatus.Enabled,
                ET_Type = (Byte)ExaminationTaskType.Examination,
                ET_ParticipatingDepartment = "[6,9]",
                ET_Attendee = "[6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,39,40,41,42,43,44,45]",
                ET_StatisticType = (Byte)StatisticType.Score,
                ET_TotalScore = 100,
                ET_TotalNumber = 10,
                ET_Mode = (Byte)ExaminationTaskMode.Auto,
                ET_AutoType = (Byte)AutoType.Week,
                ET_AutoOffsetDay = (Byte)dayOfWeek,
                ET_DifficultyCoefficient = 0,
                ET_AutoClassifies = "[\"综合、公文、绩效知识（90题）\",\"所得税知识（180题）\",\"营业税知识（60题）\",\"其他地方税知识（180题）\",\"税收征管法、相关法律法规及征管制度（253题）\",\"规费知识（130题）\",\"纳税服务知识（95题）\"]",
                ET_AutoRatio = "[{\"type\":\"单选题\",\"percent\":0.2},{\"type\":\"多选题\",\"percent\":0.2},{\"type\":\"判断题\",\"percent\":0.2},{\"type\":\"公文改错题\",\"percent\":0.1},{\"type\":\"计算题\",\"percent\":0.1},{\"type\":\"案例分析题\",\"percent\":0.1},{\"type\":\"问答题\",\"percent\":0.1}]",
                ET_StartTime = startTime,
                ET_EndTime = startTime,
                ET_TimeSpan = 0,
                ET_PaperTemplates = "[]",
                ET_Questions = "[]",
                ET_Remark = "",
                ET_AddTime = now,
                ET_Status = (Byte)Status.Available
            };
            olsEni.Entry(et).State = EntityState.Added;
            if (0 == olsEni.SaveChanges())
            {
                Assert.Fail("添加测试数据失败。");
            }
            #endregion

            expected = true;
            actual = target.WhetherGenerate(et);

            #region 删除测试数据
            olsEni.Entry(et).State = EntityState.Deleted;
            if (0 == olsEni.SaveChanges())
            {
                Assert.Fail("删除测试数据失败。id值为 " + id + " 。");
            }
            #endregion

            Assert.AreEqual(expected, actual);
        }

        /// <summary>
        /// WhetherGenerate 的测试
        ///   Cond1: 当前时间未超过开始时间
        ///     Cond2: 自动类型为“每周”
        ///       Cond2.1: 考试日期为每周一，当前日期非周一
        ///     Cond3: 不存在相同日期的“试卷模板”
        ///   Expected: false
        ///</summary>
        [TestMethod()]
        [HostType("ASP.NET")]
        [AspNetDevelopmentServerHost("D:\\Cheng\\Workspace\\OnlineLearningSystem\\OnlineLearningSystem\\OnlineLearningSystem", "/")]
        [UrlToTest("http://localhost:7128/Aspxs/Default.aspx")]
        [DeploymentItem("OnlineLearningSystem.dll")]
        public void WhetherGenerateTest2_1()
        {

            int id;
            bool expected, actual;
            DateTime now, startTime;
            ExaminationTask et;
            UExaminationTask uet;
            GeneratePaperTemplate_Accessor target = new GeneratePaperTemplate_Accessor();


            #region 添加测试数据
            now = DateTime.Now;
            startTime = new DateTime(1970, 1, 1, now.AddHours(1).Hour, now.Minute, 0);

            uet = new UExaminationTask();
            id = new Utility().GetETId();
            et = new ExaminationTask
            {
                ET_Id = id,
                ET_Name = "单元测试每周自动任务1",
                ET_Enabled = (Byte)ExaminationTaskStatus.Enabled,
                ET_Type = (Byte)ExaminationTaskType.Examination,
                ET_ParticipatingDepartment = "[6,9]",
                ET_Attendee = "[6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,39,40,41,42,43,44,45]",
                ET_StatisticType = (Byte)StatisticType.Score,
                ET_TotalScore = 100,
                ET_TotalNumber = 10,
                ET_Mode = (Byte)ExaminationTaskMode.Auto,
                ET_AutoType = (Byte)AutoType.Week,
                ET_AutoOffsetDay = 1,
                ET_DifficultyCoefficient = 0,
                ET_AutoClassifies = "[\"综合、公文、绩效知识（90题）\",\"所得税知识（180题）\",\"营业税知识（60题）\",\"其他地方税知识（180题）\",\"税收征管法、相关法律法规及征管制度（253题）\",\"规费知识（130题）\",\"纳税服务知识（95题）\"]",
                ET_AutoRatio = "[{\"type\":\"单选题\",\"percent\":0.2},{\"type\":\"多选题\",\"percent\":0.2},{\"type\":\"判断题\",\"percent\":0.2},{\"type\":\"公文改错题\",\"percent\":0.1},{\"type\":\"计算题\",\"percent\":0.1},{\"type\":\"案例分析题\",\"percent\":0.1},{\"type\":\"问答题\",\"percent\":0.1}]",
                ET_StartTime = startTime,
                ET_EndTime = startTime,
                ET_TimeSpan = 0,
                ET_PaperTemplates = "[]",
                ET_Questions = "[]",
                ET_Remark = "",
                ET_AddTime = now,
                ET_Status = (Byte)Status.Available
            };
            olsEni.Entry(et).State = EntityState.Added;
            if (0 == olsEni.SaveChanges())
            {
                Assert.Fail("添加测试数据失败。");
            }
            #endregion

            expected = false;
            actual = target.WhetherGenerate(et);

            #region 删除测试数据
            olsEni.Entry(et).State = EntityState.Deleted;
            if (0 == olsEni.SaveChanges())
            {
                Assert.Fail("删除测试数据失败。id值为 " + id + " 。");
            }
            #endregion

            Assert.AreEqual(expected, actual);
        }

        /// <summary>
        /// WhetherGenerate 的测试
        ///   Cond1: 当前时间未超过开始时间
        ///     Cond2: 自动类型为“每月”
        ///     Cond3: 不存在相同日期的“试卷模板”
        ///   Expected: true
        ///</summary>
        [TestMethod()]
        [HostType("ASP.NET")]
        [AspNetDevelopmentServerHost("D:\\Cheng\\Workspace\\OnlineLearningSystem\\OnlineLearningSystem\\OnlineLearningSystem", "/")]
        [UrlToTest("http://localhost:7128/Aspxs/Default.aspx")]
        [DeploymentItem("OnlineLearningSystem.dll")]
        public void WhetherGenerateTest3()
        {

            int id;
            bool expected, actual;
            DateTime now, startTime;
            ExaminationTask et;
            UExaminationTask uet;
            GeneratePaperTemplate_Accessor target = new GeneratePaperTemplate_Accessor();


            #region 添加测试数据
            now = DateTime.Now;
            startTime = new DateTime(1970, 1, 1, now.AddHours(1).Hour, now.Minute, 0);

            uet = new UExaminationTask();
            id = new Utility().GetETId();
            et = new ExaminationTask
            {
                ET_Id = id,
                ET_Name = "单元测试每月自动任务1",
                ET_Enabled = (Byte)ExaminationTaskStatus.Enabled,
                ET_Type = (Byte)ExaminationTaskType.Examination,
                ET_ParticipatingDepartment = "[6,9]",
                ET_Attendee = "[6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,39,40,41,42,43,44,45]",
                ET_StatisticType = (Byte)StatisticType.Score,
                ET_TotalScore = 100,
                ET_TotalNumber = 10,
                ET_Mode = (Byte)ExaminationTaskMode.Auto,
                ET_AutoType = (Byte)AutoType.Month,
                ET_AutoOffsetDay = (Byte)now.Day,
                ET_DifficultyCoefficient = 0,
                ET_AutoClassifies = "[\"综合、公文、绩效知识（90题）\",\"所得税知识（180题）\",\"营业税知识（60题）\",\"其他地方税知识（180题）\",\"税收征管法、相关法律法规及征管制度（253题）\",\"规费知识（130题）\",\"纳税服务知识（95题）\"]",
                ET_AutoRatio = "[{\"type\":\"单选题\",\"percent\":0.2},{\"type\":\"多选题\",\"percent\":0.2},{\"type\":\"判断题\",\"percent\":0.2},{\"type\":\"公文改错题\",\"percent\":0.1},{\"type\":\"计算题\",\"percent\":0.1},{\"type\":\"案例分析题\",\"percent\":0.1},{\"type\":\"问答题\",\"percent\":0.1}]",
                ET_StartTime = startTime,
                ET_EndTime = startTime,
                ET_TimeSpan = 0,
                ET_PaperTemplates = "[]",
                ET_Questions = "[]",
                ET_Remark = "",
                ET_AddTime = now,
                ET_Status = (Byte)Status.Available
            };
            olsEni.Entry(et).State = EntityState.Added;
            if (0 == olsEni.SaveChanges())
            {
                Assert.Fail("添加测试数据失败。");
            }
            #endregion

            expected = true;
            actual = target.WhetherGenerate(et);

            #region 删除测试数据
            olsEni.Entry(et).State = EntityState.Deleted;
            if (0 == olsEni.SaveChanges())
            {
                Assert.Fail("删除测试数据失败。id值为 " + id + " 。");
            }
            #endregion

            Assert.AreEqual(expected, actual);
        }

        /// <summary>
        /// WhetherGenerate 的测试
        ///   Cond1: 当前时间未超过开始时间
        ///     Cond2: 自动类型为“每月”
        ///       Cond2.1: 考试日期为每月 1号，当前日期非 1号
        ///     Cond3: 不存在相同日期的“试卷模板”
        ///   Expected: false
        ///</summary>
        [TestMethod()]
        [HostType("ASP.NET")]
        [AspNetDevelopmentServerHost("D:\\Cheng\\Workspace\\OnlineLearningSystem\\OnlineLearningSystem\\OnlineLearningSystem", "/")]
        [UrlToTest("http://localhost:7128/Aspxs/Default.aspx")]
        [DeploymentItem("OnlineLearningSystem.dll")]
        public void WhetherGenerateTest3_1()
        {

            int id;
            bool expected, actual;
            DateTime now, startTime;
            ExaminationTask et;
            UExaminationTask uet;
            GeneratePaperTemplate_Accessor target = new GeneratePaperTemplate_Accessor();


            #region 添加测试数据
            now = DateTime.Now;
            startTime = new DateTime(1970, 1, 1, now.AddHours(1).Hour, now.Minute, 0);

            uet = new UExaminationTask();
            id = new Utility().GetETId();
            et = new ExaminationTask
            {
                ET_Id = id,
                ET_Name = "单元测试每月自动任务1",
                ET_Enabled = (Byte)ExaminationTaskStatus.Enabled,
                ET_Type = (Byte)ExaminationTaskType.Examination,
                ET_ParticipatingDepartment = "[6,9]",
                ET_Attendee = "[6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,39,40,41,42,43,44,45]",
                ET_StatisticType = (Byte)StatisticType.Score,
                ET_TotalScore = 100,
                ET_TotalNumber = 10,
                ET_Mode = (Byte)ExaminationTaskMode.Auto,
                ET_AutoType = (Byte)AutoType.Month,
                ET_AutoOffsetDay = 1,
                ET_DifficultyCoefficient = 0,
                ET_AutoClassifies = "[\"综合、公文、绩效知识（90题）\",\"所得税知识（180题）\",\"营业税知识（60题）\",\"其他地方税知识（180题）\",\"税收征管法、相关法律法规及征管制度（253题）\",\"规费知识（130题）\",\"纳税服务知识（95题）\"]",
                ET_AutoRatio = "[{\"type\":\"单选题\",\"percent\":0.2},{\"type\":\"多选题\",\"percent\":0.2},{\"type\":\"判断题\",\"percent\":0.2},{\"type\":\"公文改错题\",\"percent\":0.1},{\"type\":\"计算题\",\"percent\":0.1},{\"type\":\"案例分析题\",\"percent\":0.1},{\"type\":\"问答题\",\"percent\":0.1}]",
                ET_StartTime = startTime,
                ET_EndTime = startTime,
                ET_TimeSpan = 0,
                ET_PaperTemplates = "[]",
                ET_Questions = "[]",
                ET_Remark = "",
                ET_AddTime = now,
                ET_Status = (Byte)Status.Available
            };
            olsEni.Entry(et).State = EntityState.Added;
            if (0 == olsEni.SaveChanges())
            {
                Assert.Fail("添加测试数据失败。");
            }
            #endregion

            expected = false;
            actual = target.WhetherGenerate(et);

            #region 删除测试数据
            olsEni.Entry(et).State = EntityState.Deleted;
            if (0 == olsEni.SaveChanges())
            {
                Assert.Fail("删除测试数据失败。id值为 " + id + " 。");
            }
            #endregion

            Assert.AreEqual(expected, actual);
        }

        /// <summary>
        /// GetQuestions 的测试
        ///</summary>
        [TestMethod()]
        [HostType("ASP.NET")]
        [AspNetDevelopmentServerHost("D:\\Cheng\\Workspace\\OnlineLearningSystem\\OnlineLearningSystem\\OnlineLearningSystem", "/")]
        [UrlToTest("http://localhost:7128/Aspxs/Default.aspx")]
        [DeploymentItem("OnlineLearningSystem.dll")]
        public void GetQuestionsTest()
        {

            GeneratePaperTemplate_Accessor target = new GeneratePaperTemplate_Accessor();
            string[] classifies;
            int diffCoef, expected, actual;
            bool hasScore;

            // Cond1: 不存在的分类集合
            classifies = new String[] { "不存在的分类1", "不存在的分类2" };
            diffCoef = 0;
            hasScore = true;

            expected = 0;
            actual = target.GetQuestions(classifies, diffCoef, hasScore).Count;

            Assert.AreEqual(expected, actual);

            // Cond1.1: 存在的分类集合
            //   Cond2.1: 难度系数为 0
            //   Cond2.2: 限制分数
            classifies = new String[] { "综合、公文、绩效知识（90题）", "所得税知识（180题）", "营业税知识（60题）", "其他地方税知识（180题）", "税收征管法、相关法律法规及征管制度（253题）", "规费知识（130题）", "纳税服务知识（95题）" };
            diffCoef = 0;
            hasScore = true;

            expected = olsEni.Questions.Where(m => m.Q_Score > 0 && m.Q_Status == (Byte)Status.Available).Count();
            actual = target.GetQuestions(classifies, diffCoef, hasScore).Count;

            Assert.AreEqual(expected, actual);

            // Cond1.1: 存在的分类集合
            //   Cond2.1: 难度系数为 0
            //   Cond2.2: 不限制分数
            classifies = new String[] { "综合、公文、绩效知识（90题）", "所得税知识（180题）", "营业税知识（60题）", "其他地方税知识（180题）", "税收征管法、相关法律法规及征管制度（253题）", "规费知识（130题）", "纳税服务知识（95题）" };
            diffCoef = 0;
            hasScore = false;

            expected = olsEni.Questions.Where(m => m.Q_Status == (Byte)Status.Available).Count();
            actual = target.GetQuestions(classifies, diffCoef, hasScore).Count;

            Assert.AreEqual(expected, actual);

            // Cond1.1: 存在的分类集合
            //   Cond2.1: 难度系数为 !0
            //   Cond2.2: 限制分数
            classifies = new String[] { "综合、公文、绩效知识（90题）", "所得税知识（180题）", "营业税知识（60题）", "其他地方税知识（180题）", "税收征管法、相关法律法规及征管制度（253题）", "规费知识（130题）", "纳税服务知识（95题）" };
            diffCoef = 3;
            hasScore = true;

            expected = olsEni.Questions.Where(m => m.Q_DifficultyCoefficient == diffCoef && m.Q_Score > 0 && m.Q_Status == (Byte)Status.Available).Count();
            actual = target.GetQuestions(classifies, diffCoef, hasScore).Count;

            Assert.AreEqual(expected, actual);

            // Cond1.1: 存在的分类集合
            //   Cond2.1: 难度系数为 !0
            //   Cond2.2: 不限制分数
            classifies = new String[] { "综合、公文、绩效知识（90题）", "所得税知识（180题）", "营业税知识（60题）", "其他地方税知识（180题）", "税收征管法、相关法律法规及征管制度（253题）", "规费知识（130题）", "纳税服务知识（95题）" };
            diffCoef = 3;
            hasScore = false;

            expected = olsEni.Questions.Where(m => m.Q_DifficultyCoefficient == diffCoef && m.Q_Status == (Byte)Status.Available).Count();
            actual = target.GetQuestions(classifies, diffCoef, hasScore).Count;

            Assert.AreEqual(expected, actual);

        }

        /// <summary>
        /// AdjustRatios 的测试
        ///</summary>
        [TestMethod()]
        [HostType("ASP.NET")]
        [AspNetDevelopmentServerHost("D:\\Cheng\\Workspace\\OnlineLearningSystem\\OnlineLearningSystem\\OnlineLearningSystem", "/")]
        [UrlToTest("http://localhost:7128/Aspxs/Default.aspx")]
        [DeploymentItem("OnlineLearningSystem.dll")]
        public void AdjustRatiosTest()
        {

            Object expected, actual;
            GeneratePaperTemplate_Accessor target = new GeneratePaperTemplate_Accessor();
            List<AutoRatio> ratios;

            // 正常情况
            ratios = new List<AutoRatio>();
            ratios.Add(new AutoRatio("单选题", 0.2));
            ratios.Add(new AutoRatio("多选题", 0.2));
            ratios.Add(new AutoRatio("判断题", 0.2));
            ratios.Add(new AutoRatio("公文改错题", 0.1));
            ratios.Add(new AutoRatio("计算题", 0.1));
            ratios.Add(new AutoRatio("案例分析题", 0.1));
            ratios.Add(new AutoRatio("问答题", 0.1));

            expected = ratios.Sum(m => m.percent);

            actual = target.AdjustRatios(ratios).Sum(m => m.percent);

            Assert.AreEqual(expected, actual);
            actual = null;

            // 未设置出题比例
            ratios = new List<AutoRatio>();

            expected = "未设置出题比例。";
            try
            {
                target.AdjustRatios(ratios);
            }
            catch (Exception ex)
            {
                actual = ex;
            }

            Assert.AreEqual(expected, ((Exception)actual).Message);
            actual = null;

            // 出题比例小于 50%
            ratios = new List<AutoRatio>();
            ratios.Add(new AutoRatio("单选题", 0));
            ratios.Add(new AutoRatio("多选题", 0));
            ratios.Add(new AutoRatio("判断题", 0));
            ratios.Add(new AutoRatio("公文改错题", 0.1));
            ratios.Add(new AutoRatio("计算题", 0.1));
            ratios.Add(new AutoRatio("案例分析题", 0.1));
            ratios.Add(new AutoRatio("问答题", 0.1));

            expected = "出题比例小于 50% 。";
            try
            {
                target.AdjustRatios(ratios);
            }
            catch (Exception ex)
            {
                actual = ex;
            }

            Assert.AreEqual(expected, ((Exception)actual).Message);
            actual = null;

            // 出题比例大于 100%
            ratios = new List<AutoRatio>();
            ratios.Add(new AutoRatio("单选题", 0.3));
            ratios.Add(new AutoRatio("多选题", 0.2));
            ratios.Add(new AutoRatio("判断题", 0.2));
            ratios.Add(new AutoRatio("公文改错题", 0.1));
            ratios.Add(new AutoRatio("计算题", 0.1));
            ratios.Add(new AutoRatio("案例分析题", 0.1));
            ratios.Add(new AutoRatio("问答题", 0.1));

            expected = "出题比例大于 100% 。";
            try
            {
                target.AdjustRatios(ratios);
            }
            catch (Exception ex)
            {
                actual = ex;
            }

            Assert.AreEqual(expected, ((Exception)actual).Message);
            actual = null;

            // 自动补缺
            ratios = new List<AutoRatio>();
            ratios.Add(new AutoRatio("单选题", 0));
            ratios.Add(new AutoRatio("多选题", 0));
            ratios.Add(new AutoRatio("判断题", 0));
            ratios.Add(new AutoRatio("公文改错题", 0));
            ratios.Add(new AutoRatio("计算题", 0.2));
            ratios.Add(new AutoRatio("案例分析题", 0.2));
            ratios.Add(new AutoRatio("问答题", 0.2));

            expected = 0.34;
            actual = target.AdjustRatios(ratios);

            Assert.AreEqual(expected, (Double)((List<AutoRatio>)actual)[((List<AutoRatio>)actual).Count - 1].percent);
            actual = null;

        }

        /// <summary>
        /// SelectQuestionsWithScore 的测试
        ///</summary>
        [TestMethod()]
        [HostType("ASP.NET")]
        [AspNetDevelopmentServerHost("D:\\Cheng\\Workspace\\OnlineLearningSystem\\OnlineLearningSystem\\OnlineLearningSystem", "/")]
        [UrlToTest("http://localhost:7128/Aspxs/Default.aspx")]
        [DeploymentItem("OnlineLearningSystem.dll")]
        public void SelectQuestionsWithScoreTest()
        {
            GeneratePaperTemplate_Accessor target = new GeneratePaperTemplate_Accessor();
            List<AutoRatio> ratios;
            int totalScore;
            List<Question> qs;
            Object expected, actual;

            actual = null;

            #region 无备选试题
            ratios = new List<AutoRatio>();
            ratios.Add(new AutoRatio("单选题", 0.2));
            ratios.Add(new AutoRatio("多选题", 0.2));
            ratios.Add(new AutoRatio("判断题", 0.2));
            ratios.Add(new AutoRatio("公文改错题", 0.1));
            ratios.Add(new AutoRatio("计算题", 0.1));
            ratios.Add(new AutoRatio("案例分析题", 0.1));
            ratios.Add(new AutoRatio("问答题", 0.1));

            totalScore = 100;

            qs = new List<Question>();

            expected = "“单选题”没有备选试题。";
            try
            {
                target.SelectQuestionsWithScore(ratios, totalScore, qs);
            }
            catch (Exception ex)
            {
                actual = ex;
            }

            Assert.AreEqual(expected, ((Exception)actual).Message);
            actual = null;
            #endregion

            #region 备选试题总分小于类型总分
            ratios = new List<AutoRatio>();
            ratios.Add(new AutoRatio("单选题", 0.2));
            ratios.Add(new AutoRatio("多选题", 0.2));
            ratios.Add(new AutoRatio("判断题", 0.2));
            ratios.Add(new AutoRatio("公文改错题", 0.1));
            ratios.Add(new AutoRatio("计算题", 0.1));
            ratios.Add(new AutoRatio("案例分析题", 0.1));
            ratios.Add(new AutoRatio("问答题", 0.1));

            totalScore = 100;

            qs = olsEni.Questions.Where(m => m.Q_Type == "单选题" && m.Q_Status == (Byte)Status.Available).Take(1).ToList();

            expected = "“单选题”备选试题总分小于类型总分。";
            try
            {
                target.SelectQuestionsWithScore(ratios, totalScore, qs);
            }
            catch (Exception ex)
            {
                actual = ex;
            }

            Assert.AreEqual(expected, ((Exception)actual).Message);
            actual = null;
            #endregion

            #region [已注释]超过指定重复次数
            /*ratios = new List<AutoRatio>();
            ratios.Add(new AutoRatio("单选题", 0.2));
            ratios.Add(new AutoRatio("多选题", 0.2));
            ratios.Add(new AutoRatio("判断题", 0.2));
            ratios.Add(new AutoRatio("公文改错题", 0.1));
            ratios.Add(new AutoRatio("计算题", 0.1));
            ratios.Add(new AutoRatio("案例分析题", 0.1));
            ratios.Add(new AutoRatio("问答题", 0.1));

            totalScore = 100;

            qs = olsEni.Questions.Where(m => m.Q_Type == "单选题" && m.Q_Status == (Byte)Status.Available).Take(1).ToList();

            expected = "随机选取试题失败。";
            try
            {
                target.SelectQuestionsWithScore(ratios, totalScore, qs);
            }
            catch (Exception ex)
            {
                actual = ex;
            }

            Assert.AreEqual(expected, ((Exception)actual).Message);
            actual = null;*/
            #endregion

            #region [已注释]无法减去溢出分数
            /*ratios = new List<AutoRatio>();
            ratios.Add(new AutoRatio("单选题", 0.2));
            ratios.Add(new AutoRatio("多选题", 0.2));
            ratios.Add(new AutoRatio("判断题", 0.2));
            ratios.Add(new AutoRatio("公文改错题", 0.1));
            ratios.Add(new AutoRatio("计算题", 0.1));
            ratios.Add(new AutoRatio("案例分析题", 0.1));
            ratios.Add(new AutoRatio("问答题", 0.1));

            totalScore = 100;

            qs = olsEni.Questions.Where(m => m.Q_Status == (Byte)Status.Available).ToList();

            expected = "无法减去溢出分数。";
            try
            {
                target.SelectQuestionsWithScore(ratios, totalScore, qs);
            }
            catch (Exception ex)
            {
                actual = ex;
            }

            Debug.WriteLine(((Exception)actual).Data["Info"]);
            Assert.AreEqual(expected, ((Exception)actual).Message);
            actual = null;*/
            #endregion

            #region 正常减去溢出分数
            ratios = new List<AutoRatio>();
            ratios.Add(new AutoRatio("单选题", 0.2));
            ratios.Add(new AutoRatio("多选题", 0.2));
            ratios.Add(new AutoRatio("判断题", 0.2));
            ratios.Add(new AutoRatio("公文改错题", 0.1));
            ratios.Add(new AutoRatio("计算题", 0.1));
            ratios.Add(new AutoRatio("案例分析题", 0.1));
            ratios.Add(new AutoRatio("问答题", 0.1));

            totalScore = 100;

            qs = olsEni.Questions.Where(m => m.Q_Status == (Byte)Status.Available).ToList();

            expected = 100;
            actual = target.SelectQuestionsWithScore(ratios, totalScore, qs);

            Assert.AreEqual(expected, ((List<Question>)actual).Sum(m => m.Q_Score));

            Debug.WriteLine("Question Score:");
            foreach (var q in ((List<Question>)actual))
            {
                Debug.WriteLine("    " + q.Q_Score);
            }
            actual = null;
            #endregion

            #region 是否能避免重复
            ratios = new List<AutoRatio>();
            ratios.Add(new AutoRatio("单选题", 0.2));
            ratios.Add(new AutoRatio("多选题", 0.2));
            ratios.Add(new AutoRatio("判断题", 0.2));
            ratios.Add(new AutoRatio("公文改错题", 0.1));
            ratios.Add(new AutoRatio("计算题", 0.1));
            ratios.Add(new AutoRatio("案例分析题", 0.1));
            ratios.Add(new AutoRatio("问答题", 0.1));

            totalScore = 100;

            qs = olsEni.Questions.Where(m => m.Q_Status == (Byte)Status.Available).ToList();

            expected = 100;
            actual = target.SelectQuestionsWithScore(ratios, totalScore, qs);

            Debug.WriteLine("Question Id:");
            foreach (var q in ((List<Question>)actual))
            {
                Debug.WriteLine("    " + q.Q_Id);
                if (((List<Question>)actual).Where(m => m.Q_Id == q.Q_Id).Count() > 1)
                {
                    Assert.Fail("未能避免重复。");
                }
            }
            Assert.AreEqual(expected, ((List<Question>)actual).Sum(m => m.Q_Score));

            actual = null;
            #endregion
        }

        /// <summary>
        /// SelectQuestionsWithNumber 的测试
        ///</summary>
        [TestMethod()]
        [HostType("ASP.NET")]
        [AspNetDevelopmentServerHost("D:\\Cheng\\Workspace\\OnlineLearningSystem\\OnlineLearningSystem\\OnlineLearningSystem", "/")]
        [UrlToTest("http://localhost:7128/Aspxs/Default.aspx")]
        [DeploymentItem("OnlineLearningSystem.dll")]
        public void SelectQuestionsWithNumberTest()
        {
            GeneratePaperTemplate_Accessor target = new GeneratePaperTemplate_Accessor();
            List<AutoRatio> ratios;
            int totalNumber;
            List<Question> qs;
            Object expected, actual;

            actual = null;

            #region 无备选试题
            ratios = new List<AutoRatio>();
            ratios.Add(new AutoRatio("单选题", 0.2));
            ratios.Add(new AutoRatio("多选题", 0.2));
            ratios.Add(new AutoRatio("判断题", 0.2));
            ratios.Add(new AutoRatio("公文改错题", 0.1));
            ratios.Add(new AutoRatio("计算题", 0.1));
            ratios.Add(new AutoRatio("案例分析题", 0.1));
            ratios.Add(new AutoRatio("问答题", 0.1));

            totalNumber = 100;
            qs = new List<Question>();

            expected = "“单选题”没有备选试题。";
            try
            {
                target.SelectQuestionsWithNumber(ratios, totalNumber, qs);
            }
            catch (Exception ex)
            {
                actual = ex;
            }

            Assert.AreEqual(expected, ((Exception)actual).Message);
            actual = null;
            #endregion

            #region 备选试题数量不足
            ratios = new List<AutoRatio>();
            ratios.Add(new AutoRatio("单选题", 0.2));
            ratios.Add(new AutoRatio("多选题", 0.2));
            ratios.Add(new AutoRatio("判断题", 0.2));
            ratios.Add(new AutoRatio("公文改错题", 0.1));
            ratios.Add(new AutoRatio("计算题", 0.1));
            ratios.Add(new AutoRatio("案例分析题", 0.1));
            ratios.Add(new AutoRatio("问答题", 0.1));

            totalNumber = 100;
            qs = olsEni.Questions.Where(m => m.Q_Type == "单选题" && m.Q_Status == (Byte)Status.Available).Take(1).ToList();

            expected = "“单选题”备选试题总数小于类型总数。";
            try
            {
                target.SelectQuestionsWithNumber(ratios, totalNumber, qs);
            }
            catch (Exception ex)
            {
                actual = ex;
            }

            Assert.AreEqual(expected, ((Exception)actual).Message);
            Debug.WriteLine(((Exception)actual).Data["Info"]);
            Debug.WriteLine("------------------------------");
            actual = null;
            #endregion

            #region [已注释]超过指定重复次数
            /*ratios = new List<AutoRatio>();
            ratios.Add(new AutoRatio("单选题", 0.2));
            ratios.Add(new AutoRatio("多选题", 0.2));
            ratios.Add(new AutoRatio("判断题", 0.2));
            ratios.Add(new AutoRatio("公文改错题", 0.1));
            ratios.Add(new AutoRatio("计算题", 0.1));
            ratios.Add(new AutoRatio("案例分析题", 0.1));
            ratios.Add(new AutoRatio("问答题", 0.1));

            totalNumber = 100;

            qs = olsEni.Questions.Where(m => m.Q_Type == "单选题" && m.Q_Status == (Byte)Status.Available).Take(1).ToList();

            expected = "随机选取试题失败。";
            try
            {
                target.SelectQuestionsWithNumber(ratios, totalNumber, qs);
            }
            catch (Exception ex)
            {
                actual = ex;
            }

            Assert.AreEqual(expected, ((Exception)actual).Message);
            Debug.WriteLine(((Exception)actual).Data["Info"]);
            actual = null;*/
            #endregion

            #region 数量不足时，补足
            ratios = new List<AutoRatio>();
            ratios.Add(new AutoRatio("单选题", 0.2));
            ratios.Add(new AutoRatio("多选题", 0.2));
            ratios.Add(new AutoRatio("判断题", 0.2));
            //ratios.Add(new AutoRatio("公文改错题", 0.1));
            //ratios.Add(new AutoRatio("计算题", 0.1));
            //ratios.Add(new AutoRatio("案例分析题", 0.1));
            //ratios.Add(new AutoRatio("问答题", 0.1));
            ratios = target.AdjustRatios(ratios);

            totalNumber = 10;
            qs = olsEni.Questions.Where(m => m.Q_Status == (Byte)Status.Available).ToList();

            expected = totalNumber;
            actual = target.SelectQuestionsWithNumber(ratios, totalNumber, qs);

            Assert.AreEqual(expected, ((List<Question>)actual).Count);
            Debug.WriteLine("Question Type:");
            foreach (var q in ((List<Question>)actual))
            {
                Debug.WriteLine("    " + q.Q_Type);
            }
            Debug.WriteLine("------------------------------");
            actual = null;
            #endregion

        }

        /// <summary>
        /// GenerateWithScore 的测试
        ///</summary>
        [TestMethod()]
        [HostType("ASP.NET")]
        [AspNetDevelopmentServerHost("D:\\Cheng\\Workspace\\OnlineLearningSystem\\OnlineLearningSystem\\OnlineLearningSystem", "/")]
        [UrlToTest("http://localhost:7128/Aspxs/Default.aspx")]
        [DeploymentItem("OnlineLearningSystem.dll")]
        public void GenerateWithScoreTest()
        {

            int id, dboResult;
            Object expected, actual;
            DateTime now, startTime;
            ExaminationTask et;
            UExaminationTask uet;
            GeneratePaperTemplate_Accessor target = new GeneratePaperTemplate_Accessor();
            List<Question> qs;

            actual = null;

            // 备选试题总分小于出题总分
            #region 部署测试数据
            now = DateTime.Now;
            startTime = new DateTime(1970, 1, 1, now.AddHours(1).Hour, now.Minute, 0);

            uet = new UExaminationTask();
            id = new Utility().GetETId();
            et = new ExaminationTask
            {
                ET_Id = id,
                ET_Name = "单元测试每日自动任务1",
                ET_Enabled = (Byte)ExaminationTaskStatus.Enabled,
                ET_Type = (Byte)ExaminationTaskType.Examination,
                ET_ParticipatingDepartment = "[6,9]",
                ET_Attendee = "[6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,39,40,41,42,43,44,45]",
                ET_StatisticType = (Byte)StatisticType.Score,
                ET_TotalScore = 100,
                ET_TotalNumber = 10,
                ET_Mode = (Byte)ExaminationTaskMode.Auto,
                ET_AutoType = (Byte)AutoType.Day,
                ET_AutoOffsetDay = 0,
                ET_DifficultyCoefficient = 0,
                ET_AutoClassifies = "[\"综合、公文、绩效知识（90题）\",\"所得税知识（180题）\",\"营业税知识（60题）\",\"其他地方税知识（180题）\",\"税收征管法、相关法律法规及征管制度（253题）\",\"规费知识（130题）\",\"纳税服务知识（95题）\"]",
                ET_AutoRatio = "[{\"type\":\"单选题\",\"percent\":0.2},{\"type\":\"多选题\",\"percent\":0.2},{\"type\":\"判断题\",\"percent\":0.2},{\"type\":\"公文改错题\",\"percent\":0.1},{\"type\":\"计算题\",\"percent\":0.1},{\"type\":\"案例分析题\",\"percent\":0.1},{\"type\":\"问答题\",\"percent\":0.1}]",
                ET_StartTime = startTime,
                ET_EndTime = startTime,
                ET_TimeSpan = 0,
                ET_PaperTemplates = "[]",
                ET_Questions = "[]",
                ET_Remark = "",
                ET_AddTime = now,
                ET_Status = (Byte)Status.Available
            };
            olsEni.Entry(et).State = EntityState.Added;

            dboResult = olsDbo.ExecuteSql("UPDATE Questions SET Q_Status = @status", new SqlParameter("@status", (Byte)Status.Recycle));

            if (0 == dboResult)
            {
                Assert.Fail("更新试题数据失败。");
            }

            qs = olsEni.Questions.Where(m => m.Q_Type == "单选题").Take(1).ToList();
            qs.AddRange(olsEni.Questions.Where(m => m.Q_Type == "多选题").Take(1).ToList());
            qs.AddRange(olsEni.Questions.Where(m => m.Q_Type == "判断题").Take(1).ToList());
            qs.AddRange(olsEni.Questions.Where(m => m.Q_Type == "公文改错题").Take(1).ToList());
            qs.AddRange(olsEni.Questions.Where(m => m.Q_Type == "计算题").Take(1).ToList());
            qs.AddRange(olsEni.Questions.Where(m => m.Q_Type == "案例分析题").Take(1).ToList());
            qs.AddRange(olsEni.Questions.Where(m => m.Q_Type == "问答题").Take(1).ToList());
            foreach (var q in qs)
            {
                q.Q_Status = (Byte)Status.Available;
            }

            if (0 == olsEni.SaveChanges())
            {
                Assert.Fail("部署测试数据失败。");
            }
            #endregion

            expected = "备选试题总分小于出题总分。";
            try
            {
                target.GenerateWithScore(et);
            }
            catch (Exception ex)
            {
                actual = ex;
            }
            Assert.AreEqual(expected, ((Exception)actual).Message);
            actual = null;

            #region 恢复试题状态
            dboResult = olsDbo.ExecuteSql("UPDATE Questions SET Q_Status = @status", new SqlParameter("@status", (Byte)Status.Available));

            if (0 == dboResult)
            {
                Assert.Fail("更新试题数据失败。");
            }
            #endregion

            // 备选试题总分大于出题总分
            #region 部署测试数据
            now = DateTime.Now;
            startTime = new DateTime(1970, 1, 1, now.AddHours(1).Hour, now.Minute, 0);

            uet = new UExaminationTask();
            id = new Utility().GetETId();
            et = new ExaminationTask
            {
                ET_Id = id,
                ET_Name = "单元测试每日自动任务1",
                ET_Enabled = (Byte)ExaminationTaskStatus.Enabled,
                ET_Type = (Byte)ExaminationTaskType.Examination,
                ET_ParticipatingDepartment = "[6,9]",
                ET_Attendee = "[6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,39,40,41,42,43,44,45]",
                ET_StatisticType = (Byte)StatisticType.Score,
                ET_TotalScore = 100,
                ET_TotalNumber = 10,
                ET_Mode = (Byte)ExaminationTaskMode.Auto,
                ET_AutoType = (Byte)AutoType.Day,
                ET_AutoOffsetDay = 0,
                ET_DifficultyCoefficient = 0,
                ET_AutoClassifies = "[\"综合、公文、绩效知识（90题）\",\"所得税知识（180题）\",\"营业税知识（60题）\",\"其他地方税知识（180题）\",\"税收征管法、相关法律法规及征管制度（253题）\",\"规费知识（130题）\",\"纳税服务知识（95题）\"]",
                ET_AutoRatio = "[{\"type\":\"单选题\",\"percent\":0.2},{\"type\":\"多选题\",\"percent\":0.2},{\"type\":\"判断题\",\"percent\":0.2},{\"type\":\"公文改错题\",\"percent\":0.1},{\"type\":\"计算题\",\"percent\":0.1},{\"type\":\"案例分析题\",\"percent\":0.1},{\"type\":\"问答题\",\"percent\":0.1}]",
                ET_StartTime = startTime,
                ET_EndTime = startTime,
                ET_TimeSpan = 0,
                ET_PaperTemplates = "[]",
                ET_Questions = "[]",
                ET_Remark = "",
                ET_AddTime = now,
                ET_Status = (Byte)Status.Available
            };
            olsEni.Entry(et).State = EntityState.Added;

            if (0 == olsEni.SaveChanges())
            {
                Assert.Fail("部署测试数据失败。");
            }
            #endregion

            expected = et.ET_TotalScore;
            actual = target.GenerateWithScore(et);

            Assert.AreEqual(expected, ((List<Question>)actual).Sum(m => m.Q_Score));
        }

        /// <summary>
        /// GenerateWithNumber 的测试
        ///</summary>
        [TestMethod()]
        [HostType("ASP.NET")]
        [AspNetDevelopmentServerHost("D:\\Cheng\\Workspace\\OnlineLearningSystem\\OnlineLearningSystem\\OnlineLearningSystem", "/")]
        [UrlToTest("http://localhost:7128/Aspxs/Default.aspx")]
        [DeploymentItem("OnlineLearningSystem.dll")]
        public void GenerateWithNumberTest()
        {

            int id, dboResult;
            Object expected, actual;
            DateTime now, startTime;
            ExaminationTask et;
            UExaminationTask uet;
            GeneratePaperTemplate_Accessor target = new GeneratePaperTemplate_Accessor();
            List<Question> qs;

            actual = null;

            // 备选试题总数小于出题总数
            #region 部署测试数据
            now = DateTime.Now;
            startTime = new DateTime(1970, 1, 1, now.AddHours(1).Hour, now.Minute, 0);

            uet = new UExaminationTask();
            id = new Utility().GetETId();
            et = new ExaminationTask
            {
                ET_Id = id,
                ET_Name = "单元测试每日自动任务1",
                ET_Enabled = (Byte)ExaminationTaskStatus.Enabled,
                ET_Type = (Byte)ExaminationTaskType.Examination,
                ET_ParticipatingDepartment = "[6,9]",
                ET_Attendee = "[6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,39,40,41,42,43,44,45]",
                ET_StatisticType = (Byte)StatisticType.Number,
                ET_TotalScore = 100,
                ET_TotalNumber = 10,
                ET_Mode = (Byte)ExaminationTaskMode.Auto,
                ET_AutoType = (Byte)AutoType.Day,
                ET_AutoOffsetDay = 0,
                ET_DifficultyCoefficient = 0,
                ET_AutoClassifies = "[\"综合、公文、绩效知识（90题）\",\"所得税知识（180题）\",\"营业税知识（60题）\",\"其他地方税知识（180题）\",\"税收征管法、相关法律法规及征管制度（253题）\",\"规费知识（130题）\",\"纳税服务知识（95题）\"]",
                ET_AutoRatio = "[{\"type\":\"单选题\",\"percent\":0.2},{\"type\":\"多选题\",\"percent\":0.2},{\"type\":\"判断题\",\"percent\":0.2},{\"type\":\"公文改错题\",\"percent\":0.1},{\"type\":\"计算题\",\"percent\":0.1},{\"type\":\"案例分析题\",\"percent\":0.1},{\"type\":\"问答题\",\"percent\":0.1}]",
                ET_StartTime = startTime,
                ET_EndTime = startTime,
                ET_TimeSpan = 0,
                ET_PaperTemplates = "[]",
                ET_Questions = "[]",
                ET_Remark = "",
                ET_AddTime = now,
                ET_Status = (Byte)Status.Available
            };
            olsEni.Entry(et).State = EntityState.Added;

            dboResult = olsDbo.ExecuteSql("UPDATE Questions SET Q_Status = @status", new SqlParameter("@status", (Byte)Status.Recycle));

            if (0 == dboResult)
            {
                Assert.Fail("更新试题数据失败。");
            }

            qs = olsEni.Questions.Where(m => m.Q_Type == "单选题").Take(1).ToList();
            qs.AddRange(olsEni.Questions.Where(m => m.Q_Type == "多选题").Take(1).ToList());
            qs.AddRange(olsEni.Questions.Where(m => m.Q_Type == "判断题").Take(1).ToList());
            qs.AddRange(olsEni.Questions.Where(m => m.Q_Type == "公文改错题").Take(1).ToList());
            qs.AddRange(olsEni.Questions.Where(m => m.Q_Type == "计算题").Take(1).ToList());
            qs.AddRange(olsEni.Questions.Where(m => m.Q_Type == "案例分析题").Take(1).ToList());
            qs.AddRange(olsEni.Questions.Where(m => m.Q_Type == "问答题").Take(1).ToList());
            foreach (var q in qs)
            {
                q.Q_Status = (Byte)Status.Available;
            }

            if (0 == olsEni.SaveChanges())
            {
                Assert.Fail("部署测试数据失败。");
            }
            #endregion

            expected = "备选试题总数小于出题总数。";
            try
            {
                target.GenerateWithNumber(et);
            }
            catch (Exception ex)
            {
                actual = ex;
            }
            Assert.AreEqual(expected, ((Exception)actual).Message);
            actual = null;

            #region 恢复试题状态
            dboResult = olsDbo.ExecuteSql("UPDATE Questions SET Q_Status = @status", new SqlParameter("@status", (Byte)Status.Available));

            if (0 == dboResult)
            {
                Assert.Fail("更新试题数据失败。");
            }
            #endregion

            // 备选试题总数大于出题总数
            #region 部署测试数据
            now = DateTime.Now;
            startTime = new DateTime(1970, 1, 1, now.AddHours(1).Hour, now.Minute, 0);

            uet = new UExaminationTask();
            id = new Utility().GetETId();
            et = new ExaminationTask
            {
                ET_Id = id,
                ET_Name = "单元测试每日自动任务1",
                ET_Enabled = (Byte)ExaminationTaskStatus.Enabled,
                ET_Type = (Byte)ExaminationTaskType.Examination,
                ET_ParticipatingDepartment = "[6,9]",
                ET_Attendee = "[6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,39,40,41,42,43,44,45]",
                ET_StatisticType = (Byte)StatisticType.Number,
                ET_TotalScore = 100,
                ET_TotalNumber = 10,
                ET_Mode = (Byte)ExaminationTaskMode.Auto,
                ET_AutoType = (Byte)AutoType.Day,
                ET_AutoOffsetDay = 0,
                ET_DifficultyCoefficient = 0,
                ET_AutoClassifies = "[\"综合、公文、绩效知识（90题）\",\"所得税知识（180题）\",\"营业税知识（60题）\",\"其他地方税知识（180题）\",\"税收征管法、相关法律法规及征管制度（253题）\",\"规费知识（130题）\",\"纳税服务知识（95题）\"]",
                ET_AutoRatio = "[{\"type\":\"单选题\",\"percent\":0.2},{\"type\":\"多选题\",\"percent\":0.2},{\"type\":\"判断题\",\"percent\":0.2},{\"type\":\"公文改错题\",\"percent\":0.1},{\"type\":\"计算题\",\"percent\":0.1},{\"type\":\"案例分析题\",\"percent\":0.1},{\"type\":\"问答题\",\"percent\":0.1}]",
                ET_StartTime = startTime,
                ET_EndTime = startTime,
                ET_TimeSpan = 0,
                ET_PaperTemplates = "[]",
                ET_Questions = "[]",
                ET_Remark = "",
                ET_AddTime = now,
                ET_Status = (Byte)Status.Available
            };
            olsEni.Entry(et).State = EntityState.Added;

            if (0 == olsEni.SaveChanges())
            {
                Assert.Fail("部署测试数据失败。");
            }
            #endregion

            expected = et.ET_TotalNumber;
            actual = target.GenerateWithNumber(et);

            Assert.AreEqual(expected, ((List<Question>)actual).Count);
            Debug.WriteLine("备选试题总数：" + ((List<Question>)actual).Count);
        }

        /// <summary>
        /// Generate 的测试
        ///</summary>
        [TestMethod()]
        [HostType("ASP.NET")]
        [AspNetDevelopmentServerHost("D:\\Cheng\\Workspace\\OnlineLearningSystem\\OnlineLearningSystem\\OnlineLearningSystem", "/")]
        [UrlToTest("http://localhost:7128/Aspxs/Default.aspx")]
        [DeploymentItem("OnlineLearningSystem.dll")]
        public void GenerateEtTest()
        {

            int id;
            Object expected, actual;
            DateTime now, startTime;
            ExaminationTask et;
            UExaminationTask uet;
            GeneratePaperTemplate_Accessor target = new GeneratePaperTemplate_Accessor();

            actual = null;

            // 成绩计算方式为得分
            #region 添加测试数据
            now = DateTime.Now;
            startTime = new DateTime(1970, 1, 1, now.AddHours(1).Hour, now.Minute, 0);

            uet = new UExaminationTask();
            id = new Utility().GetETId();
            et = new ExaminationTask
            {
                ET_Id = id,
                ET_Name = "单元测试每日自动任务1",
                ET_Enabled = (Byte)ExaminationTaskStatus.Enabled,
                ET_Type = (Byte)ExaminationTaskType.Examination,
                ET_ParticipatingDepartment = "[6,9]",
                ET_Attendee = "[6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,39,40,41,42,43,44,45]",
                ET_StatisticType = (Byte)StatisticType.Score,
                ET_TotalScore = 100,
                ET_TotalNumber = 10,
                ET_Mode = (Byte)ExaminationTaskMode.Auto,
                ET_AutoType = (Byte)AutoType.Day,
                ET_AutoOffsetDay = 0,
                ET_DifficultyCoefficient = 0,
                ET_AutoClassifies = "[\"综合、公文、绩效知识（90题）\",\"所得税知识（180题）\",\"营业税知识（60题）\",\"其他地方税知识（180题）\",\"税收征管法、相关法律法规及征管制度（253题）\",\"规费知识（130题）\",\"纳税服务知识（95题）\"]",
                ET_AutoRatio = "[{\"type\":\"单选题\",\"percent\":0.2},{\"type\":\"多选题\",\"percent\":0.2},{\"type\":\"判断题\",\"percent\":0.2},{\"type\":\"公文改错题\",\"percent\":0.1},{\"type\":\"计算题\",\"percent\":0.1},{\"type\":\"案例分析题\",\"percent\":0.1},{\"type\":\"问答题\",\"percent\":0.1}]",
                ET_StartTime = startTime,
                ET_EndTime = startTime,
                ET_TimeSpan = 0,
                ET_PaperTemplates = "[]",
                ET_Questions = "[]",
                ET_Remark = "",
                ET_AddTime = now,
                ET_Status = (Byte)Status.Available
            };
            olsEni.Entry(et).State = EntityState.Added;
            #endregion

            expected = et.ET_TotalScore;
            actual = target.Generate(et);

            Assert.AreEqual(expected, ((List<Question>)actual).Sum(m => m.Q_Score));
            actual = null;

            // 成绩计算方式为正确率
            #region 添加测试数据
            now = DateTime.Now;
            startTime = new DateTime(1970, 1, 1, now.AddHours(1).Hour, now.Minute, 0);

            uet = new UExaminationTask();
            id = new Utility().GetETId();
            et = new ExaminationTask
            {
                ET_Id = id,
                ET_Name = "单元测试每日自动任务1",
                ET_Enabled = (Byte)ExaminationTaskStatus.Enabled,
                ET_Type = (Byte)ExaminationTaskType.Examination,
                ET_ParticipatingDepartment = "[6,9]",
                ET_Attendee = "[6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,39,40,41,42,43,44,45]",
                ET_StatisticType = (Byte)StatisticType.Number,
                ET_TotalScore = 100,
                ET_TotalNumber = 10,
                ET_Mode = (Byte)ExaminationTaskMode.Auto,
                ET_AutoType = (Byte)AutoType.Day,
                ET_AutoOffsetDay = 0,
                ET_DifficultyCoefficient = 0,
                ET_AutoClassifies = "[\"综合、公文、绩效知识（90题）\",\"所得税知识（180题）\",\"营业税知识（60题）\",\"其他地方税知识（180题）\",\"税收征管法、相关法律法规及征管制度（253题）\",\"规费知识（130题）\",\"纳税服务知识（95题）\"]",
                ET_AutoRatio = "[{\"type\":\"单选题\",\"percent\":0.2},{\"type\":\"多选题\",\"percent\":0.2},{\"type\":\"判断题\",\"percent\":0.2},{\"type\":\"公文改错题\",\"percent\":0.1},{\"type\":\"计算题\",\"percent\":0.1},{\"type\":\"案例分析题\",\"percent\":0.1},{\"type\":\"问答题\",\"percent\":0.1}]",
                ET_StartTime = startTime,
                ET_EndTime = startTime,
                ET_TimeSpan = 0,
                ET_PaperTemplates = "[]",
                ET_Questions = "[]",
                ET_Remark = "",
                ET_AddTime = now,
                ET_Status = (Byte)Status.Available
            };
            olsEni.Entry(et).State = EntityState.Added;
            #endregion

            expected = et.ET_TotalNumber;
            actual = target.Generate(et);

            Assert.AreEqual(expected, ((List<Question>)actual).Count);
            actual = null;

            // 未设置成绩计算方式
            #region 添加测试数据
            now = DateTime.Now;
            startTime = new DateTime(1970, 1, 1, now.AddHours(1).Hour, now.Minute, 0);

            uet = new UExaminationTask();
            id = new Utility().GetETId();
            et = new ExaminationTask
            {
                ET_Id = id,
                ET_Name = "单元测试每日自动任务1",
                ET_Enabled = (Byte)ExaminationTaskStatus.Enabled,
                ET_Type = (Byte)ExaminationTaskType.Examination,
                ET_ParticipatingDepartment = "[6,9]",
                ET_Attendee = "[6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,39,40,41,42,43,44,45]",
                ET_StatisticType = (Byte)StatisticType.Unset,
                ET_TotalScore = 100,
                ET_TotalNumber = 10,
                ET_Mode = (Byte)ExaminationTaskMode.Auto,
                ET_AutoType = (Byte)AutoType.Day,
                ET_AutoOffsetDay = 0,
                ET_DifficultyCoefficient = 0,
                ET_AutoClassifies = "[\"综合、公文、绩效知识（90题）\",\"所得税知识（180题）\",\"营业税知识（60题）\",\"其他地方税知识（180题）\",\"税收征管法、相关法律法规及征管制度（253题）\",\"规费知识（130题）\",\"纳税服务知识（95题）\"]",
                ET_AutoRatio = "[{\"type\":\"单选题\",\"percent\":0.2},{\"type\":\"多选题\",\"percent\":0.2},{\"type\":\"判断题\",\"percent\":0.2},{\"type\":\"公文改错题\",\"percent\":0.1},{\"type\":\"计算题\",\"percent\":0.1},{\"type\":\"案例分析题\",\"percent\":0.1},{\"type\":\"问答题\",\"percent\":0.1}]",
                ET_StartTime = startTime,
                ET_EndTime = startTime,
                ET_TimeSpan = 0,
                ET_PaperTemplates = "[]",
                ET_Questions = "[]",
                ET_Remark = "",
                ET_AddTime = now,
                ET_Status = (Byte)Status.Available
            };
            olsEni.Entry(et).State = EntityState.Added;
            #endregion

            expected = "未设置成绩计算方式。任务Id："+ et.ET_Id;
            try
            {
                target.Generate(et);
            }
            catch (Exception ex)
            {
                actual = ex;
            }

            Assert.AreEqual(expected, ((Exception)actual).Message + ((Exception)actual).Data["Info"]);
            actual = null;
        }

        /// <summary>
        /// Generate 的测试
        ///</summary>
        [TestMethod()]
        [HostType("ASP.NET")]
        [AspNetDevelopmentServerHost("D:\\Cheng\\Workspace\\OnlineLearningSystem\\OnlineLearningSystem\\OnlineLearningSystem", "/")]
        [UrlToTest("http://localhost:7128/Aspxs/Default.aspx")]
        [DeploymentItem("OnlineLearningSystem.dll")]
        public void GenerateTest()
        {

            int id, dboResult;
            Object expected, actual;
            DateTime now, startTime;
            ExaminationTask et;
            UExaminationTask uet;
            GeneratePaperTemplate_Accessor target = new GeneratePaperTemplate_Accessor();

            actual = null;

            #region 部署测试数据
            now = DateTime.Now;
            startTime = new DateTime(1970, 1, 1, now.AddHours(1).Hour, now.Minute, 0);

            uet = new UExaminationTask();
            id = new Utility().GetETId();
            et = new ExaminationTask
            {
                ET_Id = id,
                ET_Name = "单元测试每日自动任务1",
                ET_Enabled = (Byte)ExaminationTaskStatus.Enabled,
                ET_Type = (Byte)ExaminationTaskType.Examination,
                ET_ParticipatingDepartment = "[6,9]",
                ET_Attendee = "[6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,39,40,41,42,43,44,45]",
                ET_StatisticType = (Byte)StatisticType.Score,
                ET_TotalScore = 100,
                ET_TotalNumber = 10,
                ET_Mode = (Byte)ExaminationTaskMode.Auto,
                ET_AutoType = (Byte)AutoType.Day,
                ET_AutoOffsetDay = 0,
                ET_DifficultyCoefficient = 0,
                ET_AutoClassifies = "[\"综合、公文、绩效知识（90题）\",\"所得税知识（180题）\",\"营业税知识（60题）\",\"其他地方税知识（180题）\",\"税收征管法、相关法律法规及征管制度（253题）\",\"规费知识（130题）\",\"纳税服务知识（95题）\"]",
                ET_AutoRatio = "[{\"type\":\"单选题\",\"percent\":0.2},{\"type\":\"多选题\",\"percent\":0.2},{\"type\":\"判断题\",\"percent\":0.2},{\"type\":\"公文改错题\",\"percent\":0.1},{\"type\":\"计算题\",\"percent\":0.1},{\"type\":\"案例分析题\",\"percent\":0.1},{\"type\":\"问答题\",\"percent\":0.1}]",
                ET_StartTime = startTime,
                ET_EndTime = startTime,
                ET_TimeSpan = 0,
                ET_PaperTemplates = "[]",
                ET_Questions = "[]",
                ET_Remark = "",
                ET_AddTime = now,
                ET_Status = (Byte)Status.Available
            };
            olsEni.Entry(et).State = EntityState.Added;
            if (0 == olsEni.SaveChanges())
            {
                Assert.Fail("添加测试数据失败。");
            }

            dboResult = olsDbo.ExecuteSql("UPDATE Questions SET Q_Status = @status", new SqlParameter("@status", (Byte)Status.Recycle));
            if (0 == dboResult)
            {
                Assert.Fail("更新试题数据失败。");
            }
            #endregion

            expected = "单元测试每日自动任务1：备选试题总分小于出题总分。\r\n";
            actual = target.Generate();

            Assert.AreEqual(expected, ((ResponseJson)actual).message);
            actual = null;

            #region 恢复试题数据
            dboResult = olsDbo.ExecuteSql("UPDATE Questions SET Q_Status = @status", new SqlParameter("@status", (Byte)Status.Available));
            if (0 == dboResult)
            {
                Assert.Fail("更新试题数据失败。");
            }
            #endregion

            // 正常情况
            #region 部署测试数据
            now = DateTime.Now;
            startTime = new DateTime(1970, 1, 1, now.AddHours(1).Hour, now.Minute, 0);

            uet = new UExaminationTask();
            id = new Utility().GetETId();
            et = new ExaminationTask
            {
                ET_Id = id,
                ET_Name = "单元测试每日自动任务1",
                ET_Enabled = (Byte)ExaminationTaskStatus.Enabled,
                ET_Type = (Byte)ExaminationTaskType.Examination,
                ET_ParticipatingDepartment = "[6,9]",
                ET_Attendee = "[6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,39,40,41,42,43,44,45]",
                ET_StatisticType = (Byte)StatisticType.Score,
                ET_TotalScore = 100,
                ET_TotalNumber = 10,
                ET_Mode = (Byte)ExaminationTaskMode.Auto,
                ET_AutoType = (Byte)AutoType.Day,
                ET_AutoOffsetDay = 0,
                ET_DifficultyCoefficient = 0,
                ET_AutoClassifies = "[\"综合、公文、绩效知识（90题）\",\"所得税知识（180题）\",\"营业税知识（60题）\",\"其他地方税知识（180题）\",\"税收征管法、相关法律法规及征管制度（253题）\",\"规费知识（130题）\",\"纳税服务知识（95题）\"]",
                ET_AutoRatio = "[{\"type\":\"单选题\",\"percent\":0.2},{\"type\":\"多选题\",\"percent\":0.2},{\"type\":\"判断题\",\"percent\":0.2},{\"type\":\"公文改错题\",\"percent\":0.1},{\"type\":\"计算题\",\"percent\":0.1},{\"type\":\"案例分析题\",\"percent\":0.1},{\"type\":\"问答题\",\"percent\":0.1}]",
                ET_StartTime = startTime,
                ET_EndTime = startTime,
                ET_TimeSpan = 0,
                ET_PaperTemplates = "[]",
                ET_Questions = "[]",
                ET_Remark = "",
                ET_AddTime = now,
                ET_Status = (Byte)Status.Available
            };
            olsEni.Entry(et).State = EntityState.Added;
            if (0 == olsEni.SaveChanges())
            {
                Assert.Fail("添加测试数据失败。");
            }

            dboResult = olsDbo.ExecuteSql("UPDATE Questions SET Q_Status = @status", new SqlParameter("@status", (Byte)Status.Available));
            if (0 == dboResult)
            {
                Assert.Fail("更新试题数据失败。");
            }
            #endregion

            expected = "成功处理 1个考试任务。";
            actual = target.Generate();

            Assert.AreEqual(expected, ((ResponseJson)actual).addition);
            actual = null;

        }

    }
}
