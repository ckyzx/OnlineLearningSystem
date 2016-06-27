package com.mzskyzx.webunittest.ols.test02;

import static org.junit.Assert.*;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import org.junit.AfterClass;
import org.junit.BeforeClass;
import org.junit.Test;

import com.mzskyzx.webunittest.ols.OLSTest;

public class T06ExerciseTest extends OLSTest {

	@BeforeClass
	public static void setUpBeforeClass() throws Exception {
	}

	@AfterClass
	public static void tearDownAfterClass() throws Exception {
	}

	@Test
	public void test(){
		List<Integer> autoRatios = new ArrayList<Integer>();
		autoRatios.add(20);
		autoRatios.add(20);
		autoRatios.add(20);
		autoRatios.add(0);
		autoRatios.add(0);
		autoRatios.add(0);
		autoRatios.add(0);
		testExercise("人教股", 20, autoRatios, true, "[0-9]+\\s*%", "100%");
	}
	
	public void testExercise(String department, int totalNumber, List<Integer> autoRatios, Boolean waitStart, String exerciseScorePattern, String fullMark) {
		String taskName, userName;

		try {

			// 登录管理员
			login();

			// 添加自动任务
			calendar = Calendar.getInstance();
			now = new Date();
			taskName = addExercise(department, totalNumber, autoRatios, waitStart);
			if(taskName == null){
				fail("TaskName is null.");
			}
			
			// 登录学员
			userName = loginStudent();

			// 答卷
			inputAnswer(taskName, "练习");

			// 查看已考完页面，检查成绩
			checkExerciseScore(taskName, exerciseScorePattern);

			// 登录管理员
			login();

			// 评改试卷
			grade(taskName, userName, fullMark);
			
			close();
			
			System.out.println("Test is done.");
		} catch (Exception e) {
			printException(e);
			fail("It is throw a exception.");
		}
	}

}
