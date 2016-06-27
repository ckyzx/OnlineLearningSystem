package com.mzskyzx.webunittest.test;

import static org.junit.Assert.*;

import org.junit.AfterClass;
import org.junit.BeforeClass;

import com.mzskyzx.webunittest.ols.OLSTest;

public class Test extends OLSTest {

	@BeforeClass
	public static void setUpBeforeClass() throws Exception {
	}

	@AfterClass
	public static void tearDownAfterClass() throws Exception {
	}

	@org.junit.Test
	public void test() throws InterruptedException {
		login();
		//openExerciseCenter("已");
		//openExaminationCenter("已");
		grade("自动任务每日0515043934", "陈佳伟", "100分");
	}

}
