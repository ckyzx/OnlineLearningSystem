package com.mzskyzx.webunittest.ols;

import static org.junit.Assert.*;

import org.junit.Test;
import org.openqa.selenium.WebElement;

import com.mzskyzx.webunittest.WebElementx;

public class TaskStartAndStopTest extends OLSTest {

	@Test
	public void test() {

		String url;

		url = "http://localhost:8090/User/Login";
		login(url);
		openTaskList();

		// 测试手动任务

		try {
			testTask("手动", false);
		} catch (Exception e) {
			e.printStackTrace();
			assertTrue(false);
		}

		// 测试自动任务
		try {

			testTask("每日", true);
			testTask("每周", true);
			testTask("每月", true);
		} catch (Exception e) {
			e.printStackTrace();
			assertTrue(false);
		}

		// 测试预定任务
		try {

			testTask("预定", false);
		} catch (Exception e) {
			e.printStackTrace();
			assertTrue(false);
		}

		close();
	}

	private void testTask(String taskType, Boolean showStartBtn) throws Exception {

		String taskName;
		WebElement we;
		WebElementx wex;

		try {
			
		wex = $wex("//tr[.//td[.//span[contains(text(), '" + taskType + "')]]]/td[3]");
		taskName = wex.text();

		we = $x("//tr[.//td[text()='" + taskName + "']]/td/a[text()='开始' or text() = '开启']");
		assertTrue(!we.getAttribute("class").contains("hide"));

		we.click();
		$x("//div[@class='layui-layer-btn']/a[text()='是']").click();

		Thread.sleep(1000);
		$x("//a[@title='刷新']").click();
		we = $x("//tr[.//td[text()='" + taskName + "']]/td/a[text()='开始' or text() = '开启']");
		assertTrue(we.getAttribute("class").contains("hide"));

		we = $x("//tr[.//td[text()='" + taskName + "']]/td/a[text()='结束' or text() = '关闭']");
		assertTrue(!we.getAttribute("class").contains("hide"));

		we.click();
		$x("//div[@class='layui-layer-btn']/a[text()='是']").click();

		if(showStartBtn){
			
			Thread.sleep(1000);
			$x("//a[@title='刷新']").click();
			we = $x("//tr[.//td[text()='" + taskName + "']]/td/a[text()='开始' or text() = '开启']");
			assertTrue(!we.getAttribute("class").contains("hide"));
		}

		} catch (Exception e) {
			throw e;
		}
	}
}
