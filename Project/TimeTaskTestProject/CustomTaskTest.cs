using System;
using System.Text;
using System.Collections.Generic;
using System.Linq;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Microsoft.VisualStudio.TestTools.UnitTesting.Web;

using System.Data;
using System.Data.SqlClient;
using System.Diagnostics;
using System.Threading;
using OnlineLearningSystem.Utilities;
using OnlineLearningSystem.Models;

namespace TimeTaskTestProject
{
    /// <summary>
    /// CustomTaskTest 的摘要说明
    /// </summary>
    [TestClass]
    public class CustomTaskTest : Test
    {
        public CustomTaskTest()
        {
            //
            //TODO: 在此处添加构造函数逻辑
            //
        }

        private TestContext testContextInstance;

        /// <summary>
        ///获取或设置测试上下文，该上下文提供
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
        // 编写测试时，可以使用以下附加特性:
        //
        // 在运行类中的第一个测试之前使用 ClassInitialize 运行代码
        // [ClassInitialize()]
        // public static void MyClassInitialize(TestContext testContext) { }
        //
        // 在类中的所有测试都已运行之后使用 ClassCleanup 运行代码
        // [ClassCleanup()]
        // public static void MyClassCleanup() { }
        //
        // 在运行每个测试之前，使用 TestInitialize 来运行代码
        [TestInitialize()]
        public void MyTestInitialize() {

            Int32 result;

            result = olsDbo.ExecuteProcedure("dbo.UnitTesting_DeleteExaminationTask", new SqlParameter[] { new SqlParameter("@etName", "单元测试") });

            Debug.WriteLine("“清除考试任务”操作返回 " + result + " 。");
        }
        
        // 在每个测试运行完之后，使用 TestCleanup 来运行代码
        [TestCleanup()]
        public void MyTestCleanup() {

            Int32 result;

            result = olsDbo.ExecuteProcedure("dbo.UnitTesting_DeleteExaminationTask", new SqlParameter[] { new SqlParameter("@etName", "单元测试") });

            Debug.WriteLine("“清除考试任务”操作返回 " + result + " 。");
        }
        
        #endregion

        /// <summary>
        /// 测试预定任务
        ///</summary>
        [TestMethod()]
        [HostType("ASP.NET")]
        [AspNetDevelopmentServerHost("D:\\Cheng\\Workspace\\OLS\\Project\\OnlineLearningSystem", "/")]
        [UrlToTest("http://localhost:8090/Aspxs/Default.aspx")]
        public void Test1()
        {

            int id;
            DateTime now, startTime, endTime;
            ExaminationTask et;
            ExaminationPaperTemplate ept;
            UExaminationTask_Accessor uet;
            GeneratePaperTemplate_Accessor gpt = new GeneratePaperTemplate_Accessor();
            ResponseJson resJson;
            Object expected, actual;

            #region 部署测试数据

            now = DateTime.Now;
            uet = new UExaminationTask_Accessor();

            startTime = now.AddSeconds(5);
            endTime = startTime.AddHours(1);
            endTime = new DateTime(1970, 1, 1, endTime.Hour, endTime.Minute, endTime.Second);
            id = new Utility().GetETId();
            et = new ExaminationTask
            {
                ET_Id = id,
                ET_Name = "单元测试预定任务" + id,
                ET_Enabled = (Byte)ExaminationTaskStatus.Disabled,
                ET_Type = (Byte)ExaminationTaskType.Examination,
                ET_ParticipatingDepartment = "[6,9]",
                ET_Attendee = "[6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,39,40,41,42,43,44,45]",
                ET_StatisticType = (Byte)StatisticType.Score,
                ET_TotalScore = 100,
                ET_TotalNumber = 10,
                ET_Mode = (Byte)ExaminationTaskMode.Custom,
                ET_AutoType = (Byte)AutoType.Custom,
                ET_AutoOffsetDay = 0,
                ET_DifficultyCoefficient = 0,
                ET_AutoClassifies = "[]",
                ET_AutoRatio = "[{\"type\":\"单选题\",\"percent\":0.2},{\"type\":\"多选题\",\"percent\":0.2},{\"type\":\"判断题\",\"percent\":0.2},{\"type\":\"公文改错题\",\"percent\":0.1},{\"type\":\"计算题\",\"percent\":0.1},{\"type\":\"案例分析题\",\"percent\":0.1},{\"type\":\"问答题\",\"percent\":0.1}]",
                ET_StartTime = startTime,
                ET_EndTime = endTime,
                ET_ContinuedDays = 5,
                ET_TimeSpan = 1,
                ET_PaperTemplates = "[]",
                ET_Questions = "[3,4,5,6,7,8,9,10,11,12]",
                ET_Remark = "",
                ET_AddTime = now,
                ET_Status = (Byte)Status.Available
            };
            olsEni.Entry(et).State = EntityState.Added;

            if (0 == olsEni.SaveChanges())
            {
                Assert.Fail("部署测试数据失败1。");
            }

            uet.AddPaperTemplateAndQuestionTemplate(et);
            #endregion

            // 测试开始任务操作是否正常
            expected = ResponseStatus.Success;
            resJson = uet.SetExaminationTaskStatus(et.ET_Id, ExaminationTaskStatus.Enabled);
            actual = resJson.status;
            Assert.AreEqual(expected, actual);

            // 任务是否开启
            Thread.Sleep(6 * 1000);
            new ChangePaperTemplateStatus_Accessor().Change();
            ept = olsEni.ExaminationPaperTemplates.Where(m => m.ET_Id == et.ET_Id).Take(1).ToList()[0];
            expected = (Byte)PaperTemplateStatus.Doing;
            actual = ept.EPT_PaperTemplateStatus;
            Assert.AreEqual(expected, actual);

            // 结束时间设置是否正常
            startTime = startTime.AddDays(et.ET_ContinuedDays - 1);
            expected = new DateTime(startTime.Year, startTime.Month, startTime.Day, endTime.Hour, endTime.Minute, endTime.Second);
            actual = ept.EPT_EndTime;
            Assert.AreEqual(expected, actual);

        }

        /// <summary>
        /// 测试预定任务
        ///</summary>
        [TestMethod()]
        [HostType("ASP.NET")]
        [AspNetDevelopmentServerHost("D:\\Cheng\\Workspace\\OLS\\Project\\OnlineLearningSystem", "/")]
        [UrlToTest("http://localhost:8090/Aspxs/Default.aspx")]
        public void Test2()
        {

            int id, epId;
            DateTime now, startTime, endTime;
            ExaminationTask et;
            ExaminationPaper ep;
            ExaminationPaperTemplate ept;
            UExaminationTask_Accessor uet;
            UExaminationPaperTemplate_Accessor uept;
            GeneratePaperTemplate_Accessor gpt = new GeneratePaperTemplate_Accessor();
            ResponseJson resJson;
            Object expected, actual;

            #region 部署测试数据

            now = DateTime.Now;
            uet = new UExaminationTask_Accessor();

            startTime = now.AddSeconds(5);
            endTime = startTime.AddSeconds(5);
            endTime = new DateTime(1970, 1, 1, endTime.Hour, endTime.Minute, endTime.Second);
            id = new Utility().GetETId();
            et = new ExaminationTask
            {
                ET_Id = id,
                ET_Name = "单元测试预定任务" + id,
                ET_Enabled = (Byte)ExaminationTaskStatus.Disabled,
                ET_Type = (Byte)ExaminationTaskType.Examination,
                ET_ParticipatingDepartment = "[6,9]",
                ET_Attendee = "[6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,39,40,41,42,43,44,45]",
                ET_StatisticType = (Byte)StatisticType.Score,
                ET_TotalScore = 100,
                ET_TotalNumber = 10,
                ET_Mode = (Byte)ExaminationTaskMode.Custom,
                ET_AutoType = (Byte)AutoType.Custom,
                ET_AutoOffsetDay = 0,
                ET_DifficultyCoefficient = 0,
                ET_AutoClassifies = "[]",
                ET_AutoRatio = "[{\"type\":\"单选题\",\"percent\":0.2},{\"type\":\"多选题\",\"percent\":0.2},{\"type\":\"判断题\",\"percent\":0.2},{\"type\":\"公文改错题\",\"percent\":0.1},{\"type\":\"计算题\",\"percent\":0.1},{\"type\":\"案例分析题\",\"percent\":0.1},{\"type\":\"问答题\",\"percent\":0.1}]",
                ET_StartTime = startTime,
                ET_EndTime = endTime,
                ET_ContinuedDays = 1,
                ET_TimeSpan = 1,
                ET_PaperTemplates = "[]",
                ET_Questions = "[3,4,5,6,7,8,9,10,11,12]",
                ET_Remark = "",
                ET_AddTime = now,
                ET_Status = (Byte)Status.Available
            };
            olsEni.Entry(et).State = EntityState.Added;

            if (0 == olsEni.SaveChanges())
            {
                Assert.Fail("部署测试数据失败1。");
            }

            uet.AddPaperTemplateAndQuestionTemplate(et);
            #endregion

            // 测试开始任务操作是否正常
            expected = ResponseStatus.Success;
            resJson = uet.SetExaminationTaskStatus(et.ET_Id, ExaminationTaskStatus.Enabled);
            actual = resJson.status;
            Assert.AreEqual(expected, actual);

            // 任务是否开启
            Thread.Sleep(6 * 1000);
            new ChangePaperTemplateStatus_Accessor().Change();
            ept = olsEni.ExaminationPaperTemplates.Where(m => m.ET_Id == et.ET_Id).Take(1).ToList()[0];
            expected = (Byte)PaperTemplateStatus.Doing;
            actual = ept.EPT_PaperTemplateStatus;
            Assert.AreEqual(expected, actual);

            // 结束时间设置是否正常
            startTime = startTime.AddDays(et.ET_ContinuedDays - 1);
            expected = new DateTime(startTime.Year, startTime.Month, startTime.Day, endTime.Hour, endTime.Minute, endTime.Second);
            actual = ept.EPT_EndTime;
            Assert.AreEqual(expected, actual);

            // 添加试卷
            uept = new UExaminationPaperTemplate_Accessor();
            resJson = uept.EnterExamination(ept.EPT_Id, 1);

            // 任务是否正常自动结束
            Thread.Sleep(5 * 1000);
            et = olsEni.ExaminationTasks.Single(m => m.ET_Id == et.ET_Id);
            expected = (Byte)ExaminationTaskStatus.Disabled;
            actual = et.ET_Enabled;
            Assert.AreEqual(expected, actual);

            // 试卷是否自动关闭
            Thread.Sleep(56 * 1000);
            new ChangePaperTemplateStatus_Accessor().Change();
            new ChangePaperStatus_Accessor().Change();
            epId = (Int32)resJson.addition;
            ep = olsEni.ExaminationPapers.Single(m => m.EP_Id == epId);
            expected = (Byte)PaperStatus.Done;
            actual = ep.EP_PaperStatus;
            Assert.AreEqual(expected, actual);
        }
    }
}
