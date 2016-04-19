package com.mzskyzx.webunittest.ols;

import static org.junit.Assert.*;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import org.junit.AfterClass;
import org.junit.BeforeClass;
import org.junit.Test;
import org.openqa.selenium.WebElement;

public class AutoRatioTest extends OLSTest {

	private static SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
	
	@BeforeClass
	public static void setUpBeforeClass() throws Exception {
		System.out.println("Test is Started at " + simpleDateFormat.format(new Date()) + ".");
	}

	@AfterClass
	public static void tearDownAfterClass() throws Exception {
		System.out.println("Test is Ended at " + simpleDateFormat.format(new Date()) + ".");
	}

	@Test
	public void test() {
		
		String taskName;
		WebElement we;
		List<Integer> autoRatios;

		try {

			// 登录管理员
			login();

			// 01 “公文改错题”备选试题总分小于类型总分，检验是否自动关闭任务。
			autoRatios = new ArrayList<Integer>();
			autoRatios.add(10);
			autoRatios.add(10);
			autoRatios.add(10);
			autoRatios.add(40);
			autoRatios.add(10);
			autoRatios.add(10);
			autoRatios.add(10);

			// 添加自动任务
			taskName = addAutoTask("人教股","day", autoRatios, true, true);
			
			$x("//a[@title='刷新']").click();
			we = $x("//tr[.//td[text()='" + taskName + "']]/td/a[text()='结束' or text() = '关闭']");
			assertTrue(we.getAttribute("class").contains("hide"));
			
			// 02 出题比例小于 50%，检验是否报错。
			autoRatios = new ArrayList<Integer>();
			autoRatios.add(10);
			autoRatios.add(10);
			autoRatios.add(10);
			autoRatios.add(0);
			autoRatios.add(0);
			autoRatios.add(0);
			autoRatios.add(0);

			// 添加自动任务
			calendar = Calendar.getInstance();
			now = new Date();
			taskName = addAutoTask("人教股","day", autoRatios, false, false);
			assertTrue(taskName == null);

			close();
		} catch (Exception e) {
			e.printStackTrace();
			fail("Test occured a exception.");
		}
	}

}
