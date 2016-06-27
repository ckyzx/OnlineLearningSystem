package com.mzskyzx.webunittest.ols.test02;

import static org.junit.Assert.*;

import org.junit.AfterClass;
import org.junit.BeforeClass;
import org.junit.Test;

import com.mzskyzx.webunittest.ols.OLSTest;

public class T01ManualExaminationTest extends OLSTest {

	@BeforeClass
	public static void setUpBeforeClass() throws Exception {
	}

	@AfterClass
	public static void tearDownAfterClass() throws Exception {
	}

	@Test
	public void test() {

		String taskName, userName;

		try {

			// 登录管理员
			login();

			// 添加手动任务
			taskName = addManualTask(true);

			// 登录学员
			userName = loginStudent();

			// 答卷
			inputAnswer(taskName);

			// 查看已考完页面，检查成绩
			checkExaminationScore(taskName, "[0-9]+\\s*分");

			// 登录管理员
			login();

			// 查看统计数据，检查成绩
			checkStatisticScore(taskName, userName, "未合格", "[0-9]+\\s*分");

			// 评改试卷
			grade(taskName, userName);

			close();
		} catch (Exception e) {
			e.printStackTrace();
			fail("Test occured a exception.");
		}
	}

}
