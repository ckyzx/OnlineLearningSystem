using OnlineLearningSystem.Utilities;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using System;
using Microsoft.VisualStudio.TestTools.UnitTesting.Web;
using System.Diagnostics;

namespace TimeTaskTestProject
{
    
    
    /// <summary>
    ///这是 StaticHelperTest 的测试类，旨在
    ///包含所有 StaticHelperTest 单元测试
    ///</summary>
    [TestClass()]
    public class StaticHelperTest
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
        //[TestInitialize()]
        //public void MyTestInitialize()
        //{
        //}
        //
        //使用 TestCleanup 在运行完每个测试后运行代码
        //[TestCleanup()]
        //public void MyTestCleanup()
        //{
        //}
        //
        #endregion


        /// <summary>
        /// GetExceptionMessage 的测试
        ///</summary>
        [TestMethod()]
        [HostType("ASP.NET")]
        [AspNetDevelopmentServerHost("D:\\Cheng\\Workspace\\OnlineLearningSystem\\OnlineLearningSystem\\OnlineLearningSystem", "/")]
        [UrlToTest("http://localhost:7128/Aspxs/Default.aspx")]
        public void GetExceptionMessageTest()
        {
            Exception ex;
            string expected, actual;

            ex = new Exception("测试抛出错误。");
            ex.Data.Add("Info", "附加数据信息。");

            expected = "Message: 测试抛出错误。\\r\\nSource: \\r\\nStackTrace: \\r\\n\\r\\nDataInfo: 附加数据信息。\\r\\n";
            actual = StaticHelper.GetExceptionMessage(ex);

            Assert.AreEqual(expected, actual);
            Debug.WriteLine(actual);
        }
    }
}
