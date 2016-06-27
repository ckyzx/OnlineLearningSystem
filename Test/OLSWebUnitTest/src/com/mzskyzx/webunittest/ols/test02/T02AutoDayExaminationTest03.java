package com.mzskyzx.webunittest.ols.test02;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import org.junit.AfterClass;
import org.junit.BeforeClass;
import org.junit.Test;

import com.mzskyzx.webunittest.ols.OLSTest;

public class T02AutoDayExaminationTest03 extends OLSTest {

	@BeforeClass
	public static void setUpBeforeClass() throws Exception {
	}

	@AfterClass
	public static void tearDownAfterClass() throws Exception {
	}

	@Test
	public void test() {

		List<Integer> autoRatios;

		autoRatios = new ArrayList<Integer>();
		autoRatios.add(20);
		autoRatios.add(20);
		autoRatios.add(20);
		autoRatios.add(10);
		autoRatios.add(10);
		autoRatios.add(10);
		autoRatios.add(10);
		testLoop("01 默认出题总分 100分 ", null, 0, autoRatios, "\\[未评分\\]", "未打分", "", "100分");

		/*autoRatios = new ArrayList<Integer>();
		autoRatios.add(30);
		autoRatios.add(20);
		autoRatios.add(20);
		autoRatios.add(0);
		autoRatios.add(10);
		autoRatios.add(10);
		autoRatios.add(10);
		testLoop("02 设置出题总分为 200分 ", "得分", 200, autoRatios, "\\[未评分\\]", "未打分", "", "200分");

		autoRatios = new ArrayList<Integer>();
		autoRatios.add(35);
		autoRatios.add(25);
		autoRatios.add(25);
		autoRatios.add(0);
		autoRatios.add(5);
		autoRatios.add(5);
		autoRatios.add(5);
		testLoop("03 设置出题总分为 500分 ", "得分", 500, autoRatios, "\\[未评分\\]", "未打分", "", "500分");

		autoRatios = new ArrayList<Integer>();
		autoRatios.add(30);
		autoRatios.add(20);
		autoRatios.add(20);
		autoRatios.add(0);
		autoRatios.add(10);
		autoRatios.add(10);
		autoRatios.add(10);
		testLoop("04 设置出题总数为 50", "正确率", 50, autoRatios, "\\[未评分\\]", "未打分", "", "100%");

		autoRatios = new ArrayList<Integer>();
		autoRatios.add(39);
		autoRatios.add(29);
		autoRatios.add(20);
		autoRatios.add(0);
		autoRatios.add(10);
		autoRatios.add(1);
		autoRatios.add(1);
		testLoop("05 设置出题总数为 200", "正确率", 200, autoRatios, "\\[未评分\\]", "未打分", "", "100%");*/

		close();
	}

	private void testLoop(String loopName, String statisticType, int totalScoreOrNumber, List<Integer> autoRatios, String examScorePattern,
			String statStatePattern, String statScorePattern, String fullMark) {

		int timeout;
		Boolean flag;

		System.out.println("-------------------------RUNSTART-------------------------");
		
		flag = false;
		timeout = 0;
		while (!flag && timeout < 5) {
			System.out.println("Run '" + loopName + "' at " + (timeout + 1) + " time.");
			flag = testExam(statisticType, totalScoreOrNumber, autoRatios, examScorePattern, statStatePattern, statScorePattern,
					fullMark);
			System.out.println("Run '" + loopName + "' is " + (flag ? "success" : "failure") + ".");
			timeout += 1;
		}

		System.out.println("--------------------------RUNEND--------------------------");
	}

	private Boolean testExam(String statisticType, int totalScoreOrNumber, List<Integer> autoRatios, String examScorePattern,
			String statStatePattern, String statScorePattern, String fullMark) {

		String taskName, userName;

		try {

			// 登录管理员
			login();

			// 添加自动任务
			calendar = Calendar.getInstance();
			now = new Date();
			taskName = addAutoTask("人教股", "day", autoRatios, statisticType, totalScoreOrNumber, true);

			// 登录学员
			userName = loginStudent();

			// 答卷
			inputAnswer(taskName);

			// 查看已考完页面，检查成绩
			checkExaminationScore(taskName, examScorePattern);

			// 登录管理员
			login();

			// 查看统计数据，检查成绩
			checkStatisticScore(taskName, userName, statStatePattern, statScorePattern);

			// 评改试卷
			grade(taskName, userName, fullMark);

			return true;
		} catch (Exception e) {
			printException(e);
		}

		return false;
	}
}
