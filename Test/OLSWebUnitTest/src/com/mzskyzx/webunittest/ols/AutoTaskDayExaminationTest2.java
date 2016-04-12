package com.mzskyzx.webunittest.ols;

import static org.junit.Assert.*;

import java.util.ArrayList;
import java.util.List;

import org.junit.AfterClass;
import org.junit.BeforeClass;
import org.junit.Test;

public class AutoTaskDayExaminationTest2 extends OLSTest {

	@BeforeClass
	public static void setUpBeforeClass() throws Exception {
	}

	@AfterClass
	public static void tearDownAfterClass() throws Exception {
	}

	@Test
	public void test() {
		
		String taskName, userName;
		List<Integer> autoRatios;
		
		try {

			autoRatios = new ArrayList<Integer>();
			autoRatios.add(10);
			autoRatios.add(10);
			autoRatios.add(10);
			autoRatios.add(0);
			autoRatios.add(10);
			autoRatios.add(10);
			autoRatios.add(50);
			
			// 登录管理员
			login();

			// 添加自动任务
			taskName = addAutoTask("人教股","day", 0, autoRatios, true, true);

			// 登录学员
			userName = loginStudent();

			// 答卷
			inputAnswer(taskName);
			
			// 查看已考完页面，检查成绩
			checkExaminationScore(taskName, "\\[未评分\\]");

			// 登录管理员
			login();

			// 查看统计数据，检查成绩
			checkStatisticScore(taskName, userName, "未打分", "");
			
			// 评改试卷
			grade(taskName, userName);

			close();
		} catch (Exception e) {
			e.printStackTrace();
			fail("Test occured a exception.");
		}
	}

}
