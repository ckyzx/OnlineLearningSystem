using OnlineLearningSystem.Utilities;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Threading;
using Microsoft.VisualStudio.TestTools.UnitTesting.Web;
using OnlineLearningSystem.Models;
using System.Diagnostics;
using System.Data.SqlClient;

namespace TimeTaskTestProject
{
    
    
    /// <summary>
    ///这是 ChangePaperTemplateStatusTest 的测试类，旨在
    ///包含所有 ChangePaperTemplateStatusTest 单元测试
    ///</summary>
    [TestClass()]
    public class ChangePaperTemplateStatusTest : Test
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
        //
        //使用 TestInitialize 在运行每个测试前先运行代码
        [TestInitialize()]
        public void MyTestInitialize()
        {

            Int32 result;

            result = olsDbo.ExecuteProcedure("dbo.UnitTesting_DeleteExaminationTask", new SqlParameter[] { new SqlParameter("@etName", "单元测试") });

            Debug.WriteLine("“清除考试任务”操作返回 " + result + " 。");
        }
        
        //使用 TestCleanup 在运行完每个测试后运行代码
        [TestCleanup()]
        public void MyTestCleanup()
        {

            Int32 result;

            result = olsDbo.ExecuteProcedure("dbo.UnitTesting_DeleteExaminationTask", new SqlParameter[] { new SqlParameter("@etName", "单元测试") });

            Debug.WriteLine("“清除考试任务”操作返回 " + result + " 。");
        }
        
        #endregion

        /// <summary>
        /// Change 的测试
        ///</summary>
        [TestMethod()]
        [HostType("ASP.NET")]
        [AspNetDevelopmentServerHost("D:\\Cheng\\Workspace\\OnlineLearningSystem\\OnlineLearningSystem\\OnlineLearningSystem", "/")]
        [UrlToTest("http://localhost:7128/Aspxs/Default.aspx")]
        public void ChangeTest1()
        {
            int id;
            DateTime now, startTime;
            ExaminationTask et;
            ExaminationPaperTemplate ept;
            UExaminationTask uet;
            GeneratePaperTemplate_Accessor gpt = new GeneratePaperTemplate_Accessor();
            ChangePaperTemplateStatus target;
            ResponseJson resJson;
            Object expected, actual;

            // 获取状态为“未做”、“进行中”的试卷模板
            #region 部署测试数据

            now = DateTime.Now;
            uet = new UExaminationTask();

            startTime = new DateTime(1970, 1, 1, now.AddHours(1).Hour, now.Minute, 0);
            id = new Utility().GetETId();
            et = new ExaminationTask
            {
                ET_Id = id,
                ET_Name = "单元测试每日自动任务" + id,
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

            startTime = new DateTime(1970, 1, 1, now.Hour, now.Minute, now.AddSeconds(5).Second);
            id += 1;
            et = new ExaminationTask
            {
                ET_Id = id,
                ET_Name = "单元测试每日自动任务" + id,
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
                Assert.Fail("部署测试数据失败1。");
            }

            // 生成试卷模板数据
            uet = new UExaminationTask();
            resJson = gpt.Generate();
            if (ResponseStatus.Error == resJson.status || resJson.message != "")
            {
                Assert.Fail("部署测试数据失败3。" + resJson.message);
            }

            Thread.Sleep(10 * 1000);

            ept = olsEni.ExaminationPaperTemplates.SingleOrDefault(m => m.ET_Id == id);
            if (null == ept)
            {
                Assert.Fail("部署测试数据失败4。");
            }

            ept.EPT_PaperTemplateStatus = (Byte)PaperTemplateStatus.Doing;

            if (0 == olsEni.SaveChanges())
            {
                Assert.Fail("部署测试数据失败2。");
            }

            #endregion

            expected = "共有 2条记录。其中“未做” 1条；“进行中” 1条。";
            target = new ChangePaperTemplateStatus();
            actual = target.Change();

            Assert.AreEqual(expected, ((Dictionary<String,String>)(((ResponseJson)actual).data))["RecordInfo"]);

        }

        /// <summary>
        /// Change 的测试
        ///</summary>
        [TestMethod()]
        [HostType("ASP.NET")]
        [AspNetDevelopmentServerHost("D:\\Cheng\\Workspace\\OnlineLearningSystem\\OnlineLearningSystem\\OnlineLearningSystem", "/")]
        [UrlToTest("http://localhost:7128/Aspxs/Default.aspx")]
        public void ChangeTest2()
        {

            int id;
            DateTime now, startTime;
            ExaminationTask et;
            UExaminationTask uet;
            GeneratePaperTemplate_Accessor gpt = new GeneratePaperTemplate_Accessor();
            ChangePaperTemplateStatus target;
            ResponseJson resJson;
            Object expected1, expected2, expected3, actual;

            // 处理“未做”
            #region 部署测试数据

            now = DateTime.Now;
            uet = new UExaminationTask();

            startTime = new DateTime(1970, 1, 1, now.Hour, now.Minute, now.AddSeconds(5).Second);
            id = new Utility().GetETId();
            et = new ExaminationTask
            {
                ET_Id = id,
                ET_Name = "单元测试每日自动任务" + id,
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
                ET_TimeSpan = 1,
                ET_PaperTemplates = "[]",
                ET_Questions = "[]",
                ET_Remark = "",
                ET_AddTime = now,
                ET_Status = (Byte)Status.Available
            };
            olsEni.Entry(et).State = EntityState.Added;

            if (0 == olsEni.SaveChanges())
            {
                Assert.Fail("部署测试数据失败1。");
            }

            // 生成试卷模板数据
            uet = new UExaminationTask();
            resJson = gpt.Generate();
            if (ResponseStatus.Error == resJson.status || resJson.message != "")
            {
                Assert.Fail("部署测试数据失败3。" + resJson.message);
            }

            Thread.Sleep(10 * 1000);

            #endregion

            expected1 = ResponseStatus.Success;
            expected2 = "成功处理 1条记录。";
            expected3 = "共有 1条记录。其中“未做” 1条；“进行中” 0条。";
            target = new ChangePaperTemplateStatus();
            actual = target.Change();

            Assert.AreEqual(expected1, ((ResponseJson)actual).status);
            Assert.AreEqual(expected2, ((Dictionary<String, String>)(((ResponseJson)actual).data))["SuccessInfo"]);
            Assert.AreEqual(expected3, ((Dictionary<String, String>)(((ResponseJson)actual).data))["RecordInfo"]);

        }

        /// <summary>
        /// Change 的测试
        ///</summary>
        [TestMethod()]
        [HostType("ASP.NET")]
        [AspNetDevelopmentServerHost("D:\\Cheng\\Workspace\\OnlineLearningSystem\\OnlineLearningSystem\\OnlineLearningSystem", "/")]
        [UrlToTest("http://localhost:7128/Aspxs/Default.aspx")]
        public void ChangeTest3()
        {

            int id;
            DateTime now, startTime;
            ExaminationTask et;
            UExaminationTask uet;
            GeneratePaperTemplate_Accessor gpt = new GeneratePaperTemplate_Accessor();
            ChangePaperTemplateStatus target;
            ResponseJson resJson;
            Object expected1, expected2, expected3, actual;

            // 处理“进行中”
            #region 部署测试数据

            now = DateTime.Now;
            uet = new UExaminationTask();

            startTime = new DateTime(1970, 1, 1, now.Hour, now.Minute, now.AddSeconds(5).Second);
            id = new Utility().GetETId();
            et = new ExaminationTask
            {
                ET_Id = id,
                ET_Name = "单元测试每日自动任务" + id,
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
                ET_TimeSpan = 1,
                ET_PaperTemplates = "[]",
                ET_Questions = "[]",
                ET_Remark = "",
                ET_AddTime = now,
                ET_Status = (Byte)Status.Available
            };
            olsEni.Entry(et).State = EntityState.Added;

            if (0 == olsEni.SaveChanges())
            {
                Assert.Fail("部署测试数据失败1。");
            }

            // 生成试卷模板数据
            uet = new UExaminationTask();
            resJson = gpt.Generate();
            if (ResponseStatus.Error == resJson.status || resJson.message != "")
            {
                Assert.Fail("部署测试数据失败3。" + resJson.message);
            }
            
            Thread.Sleep(10 * 1000);

            target = new ChangePaperTemplateStatus();
            actual = target.Change();

            Thread.Sleep(65 * 1000);

            #endregion

            expected1 = ResponseStatus.Success;
            expected2 = "成功处理 1条记录。";
            expected3 = "共有 1条记录。其中“未做” 0条；“进行中” 1条。";
            target = new ChangePaperTemplateStatus();
            actual = target.Change();

            Assert.AreEqual(expected1, ((ResponseJson)actual).status);
            Assert.AreEqual(expected2, ((Dictionary<String, String>)(((ResponseJson)actual).data))["SuccessInfo"]);
            Assert.AreEqual(expected3, ((Dictionary<String, String>)(((ResponseJson)actual).data))["RecordInfo"]);
        }
    }
}
