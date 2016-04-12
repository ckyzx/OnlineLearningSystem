package com.mzskyzx.webunittest.ols;

import static org.junit.Assert.*;

import java.util.ArrayList;
import java.util.List;

import org.junit.AfterClass;
import org.junit.BeforeClass;
import org.junit.Test;
import org.openqa.selenium.WebElement;

public class AutoRatioTest extends OLSTest {

	@BeforeClass
	public static void setUpBeforeClass() throws Exception {
	}

	@AfterClass
	public static void tearDownAfterClass() throws Exception {
	}

	@Test
	public void test() {
		
		String taskName;
		WebElement we;
		List<Integer> autoRatios;
		
		try {

			autoRatios = new ArrayList<Integer>();
			autoRatios.add(10);
			autoRatios.add(10);
			autoRatios.add(10);
			autoRatios.add(40);
			autoRatios.add(10);
			autoRatios.add(10);
			autoRatios.add(10);
			
			// 登录管理员
			login();

			// 添加自动任务
			taskName = addAutoTask("人教股","day", 0, autoRatios, true, true);

			// 检查是否自动关闭
			$x("//a[@title='刷新']").click();
			we = $x("//tr[.//td[text()='" + taskName + "']]/td/a[text()='开始' or text() = '开启']");
			assertTrue(!we.getAttribute("class").contains("hide"));

			close();
		} catch (Exception e) {
			e.printStackTrace();
			fail("Test occured a exception.");
		}
	}

}
