package com.mzskyzx.webunittest.ols;

import java.text.SimpleDateFormat;

import org.junit.AfterClass;
import org.junit.BeforeClass;
import org.junit.Test;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.ui.Select;
import org.testng.Assert;

public class AutoTaskWeekTest extends OLSTest {

	@BeforeClass
	public static void setUpBeforeClass() throws Exception {
	}

	@AfterClass
	public static void tearDownAfterClass() throws Exception {
	}

	@Test
	public void test() {

		String url, date, id;
		WebDriver wd;
		WebElement frame, we;
		Select select;
		SimpleDateFormat simpleDateFormat;
		
		url = "http://localhost:8090/User/Login";
		login(url);
		openTaskCreate();
		
		try {

			wd = getWd();
			frame = $x("//iframe[@src='/ExaminationTask/Create']");
			wd.switchTo().frame(frame);

			// 任务名称
			simpleDateFormat = new SimpleDateFormat("MMddhhmmss");
			$("#ET_Name").sendKeys("自动任务每周" + simpleDateFormat.format(getNow()));

			// 参与人员
			we = $x("//ul[@id='DepartmentsAndUsers']/li[.//span[text()='技术部']]");
			id = we.getAttribute("id");
			we = $x("//span[@id='"+id+"_check']");
			we.click();

			// 成绩计算
			we = $("#ET_StatisticType");
			select = new Select(we);
			select.selectByVisibleText("得分");

			// 出题方式
			we = $("#ET_Mode");
			select = new Select(we);
			select.selectByVisibleText("自动");
			
			// 自动类型
			we = $("#ET_AutoType");
			select = new Select(we);
			select.selectByVisibleText("每周");
			
			// 考试日期
			we = $x("//*[@id='AutoOffsetDayContainer']/span/span/select[contains(@class, 'offset-day-num')]");
			select = new Select(we);
			select.selectByVisibleText("五");

			// 出题分类
			we = $x("//ul[@id='QuestionClassifies']/li[.//span[text()='全部']]");
			id = we.getAttribute("id");
			we = $x("//span[@id='"+id+"_check']");
			we.click();

			// 开始时间
			Assert.assertTrue(validate("ET_StartTime", "请选择开始时间"));
			we = $x("//div[@id='StartTime']/select[contains(@class,'hourcombo')]");
			select = new Select(we);
			select.selectByValue("8");

			// 结束时间
			Assert.assertTrue(validate("ET_EndTime", "请选择结束时间"));
			we = $x("//div[@id='EndTime']/select[contains(@class,'hourcombo')]");
			select = new Select(we);
			select.selectByValue("12");

			// 考试时长
			$wex("#ET_TimeSpan").val("10");

			// 备注
			simpleDateFormat = new SimpleDateFormat("yyyyMMddhhmm");
			date = simpleDateFormat.format(now);
			$wex("textarea#ET_Remark").val("[前端测试][DATE" + date + "]");

			// 提交
			submit(true, true);

			frame = $x("//iframe[@src='/ExaminationTask/List']");
			wd.switchTo().frame(frame);
			Assert.assertTrue($wex("//nav[@class='breadcrumb']").text().contains("考试任务"));
			
			close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
}
