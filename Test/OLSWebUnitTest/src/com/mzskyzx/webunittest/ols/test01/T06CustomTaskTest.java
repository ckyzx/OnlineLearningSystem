package com.mzskyzx.webunittest.ols.test01;

import static org.junit.Assert.*;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.concurrent.TimeUnit;

import org.junit.AfterClass;
import org.junit.BeforeClass;
import org.junit.Test;
import org.openqa.selenium.Alert;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.support.ui.Select;
import org.testng.Assert;

public class T06CustomTaskTest {

	private static WebDriver wd;

	@BeforeClass
	public static void setUpBeforeClass() throws Exception {
		System.setProperty("webdriver.chrome.driver", "Resources\\chromedriver.exe");
		wd = new ChromeDriver();
		wd.manage().window().maximize();
	}

	@AfterClass
	public static void tearDownAfterClass() throws Exception {
	}

	@Test
	public void test() {

		String expected, actual = null;
		String date;
		Date now;
		SimpleDateFormat simpleDateFormat;
		WebElement frame, we;
		Select select;

		now = new Date();

		wd.manage().timeouts().implicitlyWait(10, TimeUnit.SECONDS);

		// 登录系统
		try {

			wd.get("http://localhost:8090/User/Login");
			wd.findElement(By.xpath("//input[@id='UserName']")).sendKeys("admin");
			wd.findElement(By.xpath("//input[@id='Password']")).sendKeys("kyzx201510");
			wd.findElement(By.xpath("//input[@id='Submit']")).click();
			actual = wd.findElement(By.id("User")).getAttribute("user-name");
			expected = "系统管理员";
			assertEquals(expected, actual);
		} catch (Exception e) {
			//System.out.println(e.getMessage());
			e.printStackTrace();
		}

		// 打开添加任务页面
		try {

			wd.findElement(By.xpath("//dl[@id='menu-examination-task']/dt")).click();
			wd.findElement(By.xpath("//a[@_href='/ExaminationTask/List']")).click();
			frame = wd.findElement(By.xpath("//iframe[@src='/ExaminationTask/List']"));
			wd.switchTo().frame(frame);
			wd.findElement(By.xpath("//a[@id='CreateBtn']")).click();
		} catch (Exception e) {
			//System.out.println(e.getMessage());
			e.printStackTrace();
		}

		// 录入任务信息
		try {

			frame = wd.findElement(By.xpath("//iframe[@src='/ExaminationTask/Create']"));
			wd.switchTo().frame(frame);

			// 任务名称
			simpleDateFormat = new SimpleDateFormat("MMddhhmmss");
			wd.findElement(By.xpath("//input[@id='ET_Name']")).sendKeys("预定任务" + simpleDateFormat.format(now));

			// 参与人员
			we = wd.findElement(By.xpath("//ul[@id='DepartmentsAndUsers']"));
			we = we.findElement(By.xpath("//li[.//span[text()='技术部']]"));
			we.findElement(By.xpath("//span[contains(@class,'chk')]")).click();
			// webElement.findElement(By.xpath("/html/body")).click();
			// System.out.println("'"+wd.findElement(By.xpath("//*[@id='ET_Attendee']")).getAttribute("value")+"'");

			// 成绩计算
			we = wd.findElement(By.xpath("//select[@id='ET_StatisticType']"));
			select = new Select(we);
			select.selectByVisibleText("得分");

			// 出题方式
			we = wd.findElement(By.xpath("//select[@id='ET_Mode']"));
			select = new Select(we);
			select.selectByVisibleText("预定");

			// 考试日期
			simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd");
			we = wd.findElement(By.xpath("//input[@id='ETStartDate']"));
			we.clear();
			Assert.assertTrue(validate("ETStartDate", "请选择考试日期"));
			we.sendKeys(simpleDateFormat.format(now));

			// 开始时间
			Assert.assertTrue(validate("ET_StartTime", "请选择开始时间"));
			we = wd.findElement(By.xpath("//div[@id='StartTime']/select[contains(@class,'hourcombo')]"));
			select = new Select(we);
			select.selectByValue("8");

			// 结束时间
			Assert.assertTrue(validate("ET_EndTime", "请选择结束时间"));
			we = wd.findElement(By.xpath("//div[@id='EndTime']/select[contains(@class,'hourcombo')]"));
			select = new Select(we);
			select.selectByValue("12");

			// 持续天数
			we = wd.findElement(By.xpath("//input[@id='ET_ContinuedDays']"));
			we.clear();
			Assert.assertTrue(validate("ET_ContinuedDays", "持续天数 字段是必需的。"));
			we.sendKeys("2");

			// 考试时长
			we = wd.findElement(By.xpath("//input[@id='ET_TimeSpan']"));
			we.clear();
			we.sendKeys("10");

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
			
			wd.close();
		} catch (Exception e) {
			//System.out.println(e.getMessage());
			e.printStackTrace();
		}
	}

	private WebElement $(String selector) {

		int poundIndex;
		String tag, id;
		WebElement we = null;

		if (selector.indexOf("#") != -1) {

			poundIndex = selector.indexOf("#");
			if(poundIndex == 0){
				tag = "*";
			}else{
				tag = selector.substring(0, poundIndex);
			}
			id = selector.substring(poundIndex + 1);
			we = wd.findElement(By.xpath("//" + tag + "[@id='" + id + "']"));

			return we;
		}

		return we;
	}

	private Boolean validate(String id, String tip) {

		String text;

		submit(false);
		text = wd.findElement(By.xpath("//span[@htmlfor='" + id + "']")).getText();
		return text.contains(tip);
	}

	private void submit(Boolean hasAlert) {
		wd.findElement(By.xpath("//input[@type='submit']")).click();
	}

	private void submit(Boolean hasAlert, Boolean accept) {

		Alert alert;

		wd.findElement(By.xpath("//input[@type='submit']")).click();

		if (hasAlert) {

			alert = wd.switchTo().alert();
			Assert.assertTrue(alert.getText().contains("确定提交吗？"));

			if (accept) {
				alert.accept();
			} else {
				alert.dismiss();
			}
		}
	}

}
