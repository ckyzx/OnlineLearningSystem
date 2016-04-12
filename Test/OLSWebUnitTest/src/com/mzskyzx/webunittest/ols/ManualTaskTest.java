package com.mzskyzx.webunittest.ols;

import java.text.SimpleDateFormat;

import org.junit.AfterClass;
import org.junit.BeforeClass;
import org.junit.Test;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.ui.Select;
import org.testng.Assert;

public class ManualTaskTest extends OLSTest {

	@BeforeClass
	public static void setUpBeforeClass() throws Exception {
	}

	@AfterClass
	public static void tearDownAfterClass() throws Exception {
	}

	@Test
	public void test() {

		String url, date;
		WebDriver wd;
		WebElement frame, we;
		Select select;
		SimpleDateFormat simpleDateFormat;
		
		url = "http://localhost:8090/User/Login";
		login(url);
		openTaskCreate();
		
		try {

			wd = getWd();
			frame = wd.findElement(By.xpath("//iframe[@src='/ExaminationTask/Create']"));
			wd.switchTo().frame(frame);

			// 任务名称
			simpleDateFormat = new SimpleDateFormat("MMddhhmmss");
			$("#ET_Name").sendKeys("手动任务" + simpleDateFormat.format(getNow()));

			// 参与人员
			we = $("#DepartmentsAndUsers");
			we = we.findElement(By.xpath("//li[.//span[text()='技术部']]"));
			we.findElement(By.xpath("//span[contains(@class,'chk')]")).click();

			// 成绩计算
			we = $("#ET_StatisticType");
			select = new Select(we);
			select.selectByVisibleText("得分");

			// 出题方式
			we = $("#ET_Mode");
			select = new Select(we);
			select.selectByVisibleText("手动");

			// 考试时长
			$wex("#ET_TimeSpan").val("10");

			// 选择试题
			Assert.assertTrue(validate("Questions", "请选择试题"));
			wd.findElement(By.xpath("//input[@type='checkbox'][@value='all']")).click();

			// 备注
			simpleDateFormat = new SimpleDateFormat("yyyyMMddhhmm");
			date = simpleDateFormat.format(now);
			$("textarea#ET_Remark").sendKeys("[前端测试][DATE" + date + "]");

			// 提交
			submit(true, true);

			frame = wd.findElement(By.xpath("//iframe[@src='/ExaminationTask/List']"));
			wd.switchTo().frame(frame);
			Assert.assertTrue(wd.findElement(By.xpath("//nav[@class='breadcrumb']")).getText().contains("考试任务"));
			
			close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
}
