package com.mzskyzx.webunittest.ols;

import static org.junit.Assert.*;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.regex.Pattern;

import org.junit.AfterClass;
import org.junit.BeforeClass;
import org.openqa.selenium.Alert;
import org.openqa.selenium.By;
import org.openqa.selenium.JavascriptExecutor;
import org.openqa.selenium.NoSuchElementException;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.ui.ExpectedCondition;
import org.openqa.selenium.support.ui.Select;
import org.openqa.selenium.support.ui.WebDriverWait;
import org.testng.Assert;

import com.google.common.base.Function;
import com.google.common.base.Predicate;
import com.mzskyzx.webunittest.WebElementx;
import com.mzskyzx.webunittest.WebUnitTest;

public class OLSTest extends WebUnitTest {

	private String url = "http://localhost/User/Login";

	public OLSTest() {
		// init("chrome");
		// init("edge");
		// init("ie");
		// init("ie", true, 10);
		init("ie", false, 10);
		wd.get(url);
	}

	protected String login() {
		return loginAdmin();
	}

	protected String login(String url) {
		wd.get(url);
		return loginAdmin();
	}

	protected String loginAdmin() {
		return login("admin", "kyzx201510");
	}

	protected String loginStudent() {
		return login("441481198805230874", "123456");
	}

	protected String login(String name, String password) {

		int timeout;
		String cnName;
		WebElement we;

		// 登录系统
		try {

			setLoadWait(1);

			we = null;
			timeout = 0;
			while (we == null & timeout < 5) {
				System.out.println("Find 'UserName' at " + (timeout + 1) + " time.");
				we = $("#UserName");
				if (we == null) {
					logout();
				} else {
					wd.get(url);
				}
				Thread.sleep(1000);
				timeout += 1;
			}

			setLoadWait(10);

			$("#UserName").sendKeys(name);
			$("#Password").sendKeys(password);
			$("#Submit").click();
			Thread.sleep(1000);
			cnName = $("#User").getAttribute("user-name");

			return cnName;
		} catch (Exception e) {
			printException(e);
			return null;
		}
	}

	protected Function<WebDriver, Boolean> isPageLoaded() {
		return new Function<WebDriver, Boolean>() {
			@Override
			public Boolean apply(WebDriver driver) {
				return ((JavascriptExecutor) driver).executeScript("return document.readyState").equals("complete");
			}
		};
	}

	public void waitForPageLoad() {
		WebDriverWait wait = new WebDriverWait(wd, 30);
		wait.until(isPageLoaded());
	}

	private void hideFooter() {

		String js;
		JavascriptExecutor je;

		waitForPageLoad();
		je = (JavascriptExecutor) wd;
		js = "$('.footer').hide();";
		je.executeScript(js);
	}

	protected Boolean logout() {

		WebElement we;

		wd.switchTo().window(wd.getWindowHandle());
		we = $("#Logout");
		if (we == null) {
			return false;
		}
		we.click();
		return true;
	}

	protected void openTaskList() {

		WebElement we, frame;

		// 打开任务列表页面
		try {

			wd.switchTo().window(wd.getWindowHandle());

			// 检查“任务管理”按钮是否存在
			we = $x("//a[@_href='/ExaminationTask/List']");
			if (!we.isDisplayed()) {
				$x("//dl[@id='menu-examination-task']/dt").click();
			}
			we.click();
			frame = $x("//iframe[@src='/ExaminationTask/List']");
			wd.switchTo().frame(frame);

		} catch (Exception e) {
			printException(e);
		}
	}

	protected void openTaskCreate() {

		// 打开添加任务页面
		try {

			openTaskList();
			$("#CreateBtn").click();
		} catch (Exception e) {
			printException(e);
		}
	}

	private void openTaskEdit(String taskName) {

		WebElement we;

		// 打开编辑任务页面
		try {

			openTaskList();
			hideFooter();
			we = $xl("//tr[.//td[text()='" + taskName + "']]/td/a[contains(@class, 'edit')]");
			we.click();

		} catch (Exception e) {
			printException(e);
		}
	}

	protected void openExaminationCenter(String text) {
		wd.switchTo().window(wd.getWindowHandle());
		$("#menu-examination-center").click();
		openIframe("menu-examination-center", text, "_href");
	}

	protected void openExerciseCenter(String text) {
		wd.switchTo().window(wd.getWindowHandle());
		$("#menu-exercise-center").click();
		openIframe("menu-exercise-center", text, "_href");
	}

	protected void openIframe(String text, String srcAttr) {

		String src;
		WebElement we;

		we = $x("//a[text()='" + text + "']");
		we.click();
		src = we.getAttribute(srcAttr);
		we = $x("//iframe[@src='" + src + "']");
		wd.switchTo().frame(we);
	}

	protected void openIframe(String menuId, String text, String srcAttr) {

		String src;
		WebElement we;

		we = $x("//dl[@id='" + menuId + "']/dd/ul/li/a[text()='" + text + "']");
		if (we == null) {
			we = $x("//dl[@id='" + menuId + "']/dd/ul/li/a/span[text()='" + text + "']/..");
		}
		we.click();
		src = we.getAttribute(srcAttr);
		we = $x("//iframe[@src='" + src + "']");
		wd.switchTo().frame(we);
	}

	protected void openMenu(String text) {
		$x("//dt[contains(text(),'" + text + "')]").click();
	}

	protected void openLink(String text) {
		$x("//a[text()='" + text + "']").click();
	}

	protected Boolean validate(String id, String tip) {

		String text;

		submit();
		text = wd.findElement(By.xpath("//span[@htmlfor='" + id + "']")).getText();
		return text.contains(tip);
	}

	protected void submit() {
		wd.findElement(By.xpath("//input[@type='submit']")).click();
	}

	protected void submit(Boolean hasAlert, Boolean accept) {

		Alert alert;

		wd.findElement(By.xpath("//input[@type='submit']")).click();

		if (hasAlert) {

			alert = wd.switchTo().alert();
			assertTrue(alert.getText().contains("确定提交吗？"));

			if (accept) {
				alert.accept();
			} else {
				alert.dismiss();
			}
		}
	}

	public static boolean isNumeric(String str) {
		Pattern pattern = Pattern.compile("[0-9]*");
		return pattern.matcher(str).matches();
	}

	protected String addManualTask(Boolean start) throws Exception {

		String taskName, date;
		WebElement we;
		Select select;
		SimpleDateFormat simpleDateFormat;

		taskName = null;

		try {

			openTaskCreate();

			// 任务名称
			taskName = setTaskName("手动任务");

			// 参与人员
			setAttendees("人教股");

			// 成绩计算
			setSelect("ET_StatisticType", "得分");

			// 出题方式
			setSelect("ET_Mode", "手动");

			// 考试时长
			setTimeSpan(10);

			// 选择试题
			Assert.assertTrue(validate("Questions", "请选择试题"));
			
			wd.findElement(By.xpath("//input[@type='checkbox'][@value='all']")).click();

			// 备注
			setRemark("");

			// 提交
			submit(true, true);
			
			Assert.assertTrue(wd.findElement(By.xpath("//nav[@class='breadcrumb']")).getText().contains("考试任务"));

			// 修改任务名
			openTaskEdit(taskName);
			taskName = appendTaskName("测试编辑");

			// 提交
			submit(true, true);

			if (start) {
				startTask(taskName);
			}

		} catch (Exception e) {
			throw e;
		}

		return taskName;
	}

	protected String addCustomTask(String department, Boolean start, Boolean waitStart) throws Exception {

		int startTime;
		String taskName;

		try {

			openTaskCreate();

			// 任务名称
			taskName = setTaskName("预定任务");

			// 参与人员
			setAttendees(department);

			// 成绩计算
			setSelect("ET_StatisticType", "得分");

			// 出题方式
			setSelect("ET_Mode", "预定");

			// 考试日期
			setStartDate(now);

			// 开始时间和结束时间
			startTime = setTaskTime();

			// 持续天数
			setContinuedDays(2);

			// 考试时长
			setTimeSpan(10);

			// 选择试题
			Assert.assertTrue(validate("Questions", "请选择试题"));
			$x("//input[@type='checkbox'][@value='all']").click();

			// 备注
			setRemark("");

			// 提交
			submit(true, true);
			Assert.assertTrue(wd.findElement(By.xpath("//nav[@class='breadcrumb']")).getText().contains("考试任务"));

			// 修改任务名
			openTaskEdit(taskName);
			taskName = appendTaskName("测试编辑");

			// 提交
			submit(true, true);

			// if (start) {
			// startTask(taskName);
			// }

			if (waitStart) {
				waitStart(startTime, 4);
			}

			return taskName;
		} catch (Exception e) {
			throw e;
		}
	}

	protected String appendTaskName(String name) {
		WebElementx wex;
		wex = $wex("#ET_Name");
		name = wex.val() + name;
		wex.val(name);
		return name;
	}

	protected String setTaskName(String name) {
		SimpleDateFormat simpleDateFormat = new SimpleDateFormat("MMddhhmmss");
		String taskName = name + simpleDateFormat.format(now);
		$("#ET_Name").sendKeys(taskName);
		return taskName;
	}

	protected void setSelect(String id, String text) {
		WebElement we = $x("//select[@id='" + id + "']");
		Select select = new Select(we);
		select.selectByVisibleText(text);
	}

	protected void setStartDate(Date date) {
		SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd");
		WebElement we = $x("//input[@id='ETStartDate']");
		we.clear();
		Assert.assertTrue(validate("ETStartDate", "请选择考试日期"));
		we.sendKeys(simpleDateFormat.format(now));
	}

	protected void setContinuedDays(int num) {
		WebElement we = $x("//input[@id='ET_ContinuedDays']");
		we.clear();
		Assert.assertTrue(validate("ET_ContinuedDays", "持续天数 字段是必需的。"));
		we.sendKeys(String.valueOf(num));
	}

	protected void setTimeSpan(int num) {
		$wex("#ET_TimeSpan").val(String.valueOf(num));
	}

	protected void setRemark(String remark) {
		SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyyMMddhhmm");
		String date = simpleDateFormat.format(now);
		$("textarea#ET_Remark").sendKeys("[前端测试][DATE" + date + "]" + remark);
	}

	protected String addAutoTask(String department, String type, int autoOffset, Boolean start) throws Exception {
		return addAutoTask(department, type, autoOffset, null, null, 0, start, start);
	}

	protected String addAutoTask(String department, String type, List<Integer> autoRatios, Boolean start,
			Boolean waitStart) throws Exception {
		return addAutoTask(department, type, 0, autoRatios, null, 0, start, waitStart);
	}

	protected String addAutoTask(String department, String type, int autoOffset, List<Integer> autoRatios,
			Boolean start, Boolean waitStart) throws Exception {
		return addAutoTask(department, type, autoOffset, autoRatios, null, 0, start, waitStart);
	}

	protected String addAutoTask(String department, String type, List<Integer> autoRatios, String statisticType,
			int totalScoreOrNumber, Boolean start) throws Exception {
		return addAutoTask(department, type, 0, autoRatios, statisticType, totalScoreOrNumber, start, start);
	}

	protected String addAutoTask(String department, String type, int autoOffset, List<Integer> autoRatios,
			String statisticType, int totalScoreOrNumber, Boolean start, Boolean waitStart) throws Exception {

		int startTime;
		String taskName;
		WebElement we;
		Select select;
		SimpleDateFormat simpleDateFormat;

		taskName = null;

		try {

			openTaskCreate();

			// 任务名称
			simpleDateFormat = new SimpleDateFormat("MMddhhmmss");
			taskName = "自动任务";
			switch (type) {
			case "day":
				taskName += "每日";
				break;
			case "week":
				taskName += "每周";
				break;
			case "month":
				taskName += "每月";
			default:
				break;
			}
			taskName += simpleDateFormat.format(now);
			$("#ET_Name").sendKeys(taskName);
			System.out.println("Task Name is '" + taskName + "'.");

			// 参与人员
			setAttendees(department);

			// 成绩计算
			setStatisticType(statisticType, totalScoreOrNumber);

			// 出题方式
			we = $("#ET_Mode");
			select = new Select(we);
			select.selectByVisibleText("自动");

			if (type != "day") {

				// 自动类型
				we = $("#ET_AutoType");
				select = new Select(we);
				if (type == "week") {
					select.selectByVisibleText("每周");
				} else if (type == "month") {
					select.selectByVisibleText("每月");
				}

				// 考试日期
				we = $x("//*[@id='AutoOffsetDayContainer']/span/span/select[contains(@class, 'offset-day-num')]");
				select = new Select(we);
				select.selectByValue(String.valueOf(autoOffset));
			}

			// 出题分类
			setClassifies();

			// 出题比例
			if (!setAutoRatios(autoRatios)) {
				return null;
			}

			// 开始时间和结束时间
			startTime = setTaskTime();

			// 考试时长
			setTimeSpan(10);

			// 备注
			setRemark("");

			// 提交
			submit(true, true);

			Assert.assertTrue($wex("//nav[@class='breadcrumb']").text().contains("考试任务"));

			// 修改任务名
			openTaskEdit(taskName);
			taskName = appendTaskName("测试编辑");

			// 提交
			submit(true, true);

			if (start) {
				startTask(taskName);
			}

			if (waitStart) {
				waitStart(startTime);
			}
		} catch (Exception e) {
			throw e;
		}

		return taskName;
	}

	protected void setClassifies() {
		WebElement we = $x("//ul[@id='QuestionClassifies']/li[.//span[text()='全部']]");
		String id = we.getAttribute("id");
		we = $x("//span[@id='" + id + "_check']");
		we.click();
	}

	protected Boolean setAutoRatios(List<Integer> autoRatios) {

		int totalRatios;
		WebElement we;
		List<WebElement> wes;

		if (autoRatios != null) {

			changeAutoRatioEvent();

			totalRatios = 0;
			wes = $xs("//input[contains(@class,'ratio-percent')]");

			for (int i = 0; i < wes.size(); i++) {
				we = wes.get(i);
				we.clear();
				we.sendKeys(String.valueOf(autoRatios.get(i)));
				totalRatios += autoRatios.get(i);
			}

			submit();

			if (totalRatios < 50 || totalRatios > 100) {
				assertTrue($x("//span[@htmlfor='ET_AutoRatio']").getText().equals("出题比例必须大于 50% 、小于 100%"));
				return false;
			}

			return true;
		}else{
			
			return true;
		}
	}

	protected String addExercise(String department, int totalNumber, List<Integer> autoRatios, Boolean waitStart)
			throws Exception {
		int startTime;
		String taskName;

		taskName = null;

		try {

			openTaskCreate();

			// 任务名称
			taskName = setTaskName("练习任务");
			System.out.println("Task Name is '" + taskName + "'.");

			// 任务类型
			setSelect("ET_Type", "练习");

			// 出题数量
			$wex("#ET_TotalNumber").val(totalNumber);

			// 参与人员
			setAttendees(department);

			// 出题分类
			setClassifies();

			// 考试日期
			setStartDate(now);

			// 出题比例
			if (!setAutoRatios(autoRatios)) {
				return null;
			}

			// 开始时间和结束时间
			startTime = setTaskTime();

			// 持续天数
			setContinuedDays(1);

			// 考试时长
			setTimeSpan(10);

			// 备注
			setRemark("");

			// 提交
			submit(true, true);

			Assert.assertTrue($wex("//nav[@class='breadcrumb']").text().contains("考试任务"));

			// 修改任务名
			openTaskEdit(taskName);
			taskName = appendTaskName("测试编辑");

			// 提交
			submit(true, true);

			if (waitStart) {
				startTask(taskName);
				waitStart(startTime);
			}
		} catch (Exception e) {
			throw e;
		}

		return taskName;
	}

	private void changeAutoRatioEvent() {

		String js;
		JavascriptExecutor je;

		isPageLoaded();
		je = (JavascriptExecutor) wd;
		js = "" + "$('#RatioContainer').off('change', 'input.ratio-percent');"
				+ "$('#RatioContainer').on('change', 'input.ratio-percent', function() {                             "
				+ "    var input;                                                                                    "
				+ "    var ratio, ratios;                                                                            "
				+ "    input = $(this);                                                                              "
				+ "    ratio = input.val();                                                                          "
				+ "    input.val(ratio);                                                                             "
				+ "    input.attr('data-origin-val', ratio);                                                         "
				+ "    ratios = [];                                                                                  "
				+ "    $('#RatioContainer').find('.ratio-item').each(function() {                                    "
				+ "        var item;                                                                                 "
				+ "        var type, percent;                                                                        "
				+ "        item = $(this);                                                                           "
				+ "        type = item.find('.ratio-type').text();                                                   "
				+ "        percent = item.find('input.ratio-percent').val();                                         "
				+ "        percent = parseInt(percent) / 100;                                                        "
				+ "        ratios.push({                                                                             "
				+ "            type: type,                                                                           "
				+ "            percent: percent                                                                      "
				+ "        });                                                                                       "
				+ "    });                                                                                           "
				+ "    $('#ET_AutoRatio').val(JSON.stringify(ratios));                                               "
				+ "});";
		je.executeScript(js);
	}

	private Boolean setStatisticType(String statisticType, int totalScoreOrNumber) {

		WebElement we;
		Select select;

		we = $("#ET_StatisticType");
		select = new Select(we);

		if (statisticType == null) {
			statisticType = "得分";
			totalScoreOrNumber = 100;
		}

		select.selectByVisibleText(statisticType);

		if (statisticType == "得分") {
			$wex("#ET_TotalScore").val(String.valueOf(totalScoreOrNumber));
		} else if (statisticType == "正确率") {
			$wex("#ET_TotalNumber").val(String.valueOf(totalScoreOrNumber));
		}

		return true;
	}

	private Boolean setAttendees(String department) {

		/*
		 * String id; WebElement we;
		 * 
		 * we = $x("//ul[@id='DepartmentsAndUsers']/li[.//span[text()='" +
		 * department + "']]"); id = we.getAttribute("id"); we =
		 * $x("//span[@id='" + id + "_check']"); we.click()
		 */;

		$x("//ul[@id='DepartmentsAndUsers']/li/ul/li[.//span[text()='" + department
				+ "']]/span[contains(@class,'chk')]").click();

		return true;
	}

	private Boolean waitStart(int startTime) throws InterruptedException {
		waitStart(startTime, 1);
		return true;
	}
	private Boolean waitStart(int startTime, int waitMore) throws InterruptedException {

		int wait;

		wait = startTime - (calendar.get(Calendar.HOUR_OF_DAY) * 60 + calendar.get(Calendar.MINUTE));
		wait += waitMore == 0 ? 1 : waitMore; // 加多n分钟，以等待定时任务启动[试卷模板]。
		System.out.println("Need to wait " + wait + " minutes.");
		System.out.println("Wait start...");
		showPageWaiting(wait);

		return true;
	}

	private void showPageWaiting(int waitMinutes) throws InterruptedException {

		int seconds;
		String js;
		JavascriptExecutor je;

		waitForPageLoad();
		je = (JavascriptExecutor) wd;
		js = "layer.msg('需等待 " + waitMinutes + " 分钟，剩余 " + waitMinutes + " 分  0  秒',{time:"
				+ ((waitMinutes + 1) * 60 * 1000) + ",shade:[0.3,'#000']});";
		je.executeScript(js);

		seconds = waitMinutes * 60;
		while (seconds > 0) {
			js = "$('.layui-layer-content').text('需等待 " + waitMinutes + " 分钟，剩余 " + seconds / 60 + " 分  " + seconds % 60
					+ " 秒');";
			je.executeScript(js);
			Thread.sleep(1000);
			seconds -= 1;
		}
		js = "layer.closeAll();";
		je.executeScript(js);
	}

	private int setTaskTime() throws Exception {

		int startHour, endHour, startMinute;
		WebElement we;
		Select select;

		// 开始时间
		startMinute = getStartMinute();
		startHour = getStartHour(startMinute);
		startMinute = startMinute % 60; // 去除超过60秒的部分
		endHour = getEndHour(startHour);
		Assert.assertTrue(validate("ET_StartTime", "请选择开始时间"));
		we = $x("//div[@id='StartTime']/select[contains(@class,'hourcombo')]");
		select = new Select(we);
		select.selectByValue(String.valueOf(startHour));
		we = $x("//div[@id='StartTime']/select[contains(@class,'mincombo')]");
		select = new Select(we);
		select.selectByValue(String.valueOf(startMinute));

		// 结束时间
		Assert.assertTrue(validate("ET_EndTime", "请选择结束时间"));
		we = $x("//div[@id='EndTime']/select[contains(@class,'hourcombo')]");
		select = new Select(we);
		select.selectByValue(String.valueOf(endHour));
		we = $x("//div[@id='EndTime']/select[contains(@class,'mincombo')]");
		select = new Select(we);
		select.selectByValue(String.valueOf(startMinute));

		return startHour * 60 + startMinute;
	}

	private int getStartMinute() {
		int minute;

		// 增加3秒的空闲
		minute = calendar.get(Calendar.MINUTE);
		minute = minute + 3;
		while (minute % 5 != 0) {
			minute += 1;
		}
		return minute;
	}

	private int getStartHour(int startMinute) {
		int hour;

		hour = calendar.get(Calendar.HOUR_OF_DAY);
		if (startMinute > 59) {
			hour += 1;
		}
		return hour;
	}

	private int getEndHour(int startHour) throws Exception {
		if (startHour == 23) {
			throw new Exception("不允许的开始时间");
		}
		return startHour + 1;
	}

	protected Boolean startTask(String taskName) throws Exception {

		int timeout;
		WebElement we, we1;

		try {

			// 开启任务
			hideFooter();
			we = $xl("//tr[.//td[text()='" + taskName + "']]/td/a[text()='开始' or text() = '开启']");
			assertTrue(!we.getAttribute("class").contains("hide"));
			we.click();

			we1 = null;
			timeout = 0;
			while (we1 == null && timeout < 5) {
				System.out.println("Find 'layui-layer-btn' at " + (timeout + 1) + " time.");
				// 点击“开启”按钮
				we.click();
				Thread.sleep(1000);
				we1 = $x("//div[@class='layui-layer-btn']/a[text()='是']");
				timeout += 1;
			}
			// 点击“确认开启”按钮
			we1.click();

			Thread.sleep(1000);
			$x("//a[@title='刷新']").click();
			we = $x("//tr[.//td[text()='" + taskName + "']]/td/a[text()='开始' or text() = '开启']");
			assertTrue(we.getAttribute("class").contains("hide"));

			return true;
		} catch (Exception e) {
			throw e;
		}
	}

	protected Boolean checkExaminationScore(String taskName, String pattern) throws InterruptedException {

		String score;
		Pattern p;
		WebElement we;

		p = Pattern.compile(pattern);

		// 打开已考完页面，查看成绩
		openExaminationCenter("已");
		we = $x("//tr[.//td[text()='" + taskName + "']]/td[9]");
		score = we.getText();
		System.out.println("Examination Score is '" + score + "'.");
		assertTrue(p.matcher(score).matches());

		// 查看考卷
		$x("//tr[.//td[text()='" + taskName + "']]/td/a[text()='查看试卷']").click();
		$x("//div[@id='ExaminationPaperGradeContainer']");

		return true;
	}

	protected Boolean checkExerciseScore(String taskName, String pattern) throws InterruptedException {

		String score;
		Pattern p;
		WebElement we;

		p = Pattern.compile(pattern);

		openExerciseCenter("已");
		we = $x("//tr[.//td[text()='" + taskName + "']]/td[9]");
		score = we.getText();
		System.out.println("Examination Score is '" + score + "'.");
		assertTrue(p.matcher(score).matches());

		// 查看考卷
		$x("//tr[.//td[text()='" + taskName + "']]/td/a[text()='查看试卷']").click();
		$x("//div[@id='ExaminationPaperGradeContainer']");

		return true;
	}

	protected Boolean checkStatisticScore(String taskName, String userName, String statePattern, String scorePattern) {

		String state, score;
		Pattern pState, pScore;
		WebElement we;

		pState = Pattern.compile(statePattern);
		pScore = Pattern.compile(scorePattern);

		// 打开考试统计，查看成绩
		openMenu("数据统计");
		openIframe("考试统计", "_href");
		we = $x("//tr[.//td[text()='" + taskName + "']]/td/a[text()='详情']");
		we.click();
		we = $x("//div[@class='layui-layer-content']/iframe");
		wd.switchTo().frame(we);

		we = $x("//tr[.//td[text()='" + userName + "']]/td[6]");
		state = we.getText();
		System.out.println("Statistic state is '" + state + "'.");
		assertTrue(pState.matcher(state).matches());

		we = $x("//tr[.//td[text()='" + userName + "']]/td[5]");
		score = we.getText();
		System.out.println("Statistic Score is '" + score + "'.");
		assertTrue(pScore.matcher(score).matches());

		return true;
	}

	protected Boolean grade(String taskName, String userName) throws InterruptedException {
		return grade(taskName, userName, "100分");
	}

	protected Boolean grade(String taskName, String userName, String expectedScore) throws InterruptedException {

		String score;
		WebElement we;
		List<WebElement> wes;

		// 评改试卷
		openTaskList();
		// 结束任务
		hideFooter();
		we = $x("//tr[.//td[text()='" + taskName + "']]/td/a[text()='结束' or text() = '关闭']");
		assertTrue(!we.getAttribute("class").contains("hide"));
		we.click();
		$x("//div[@class='layui-layer-btn']/a[text()='是']").click();
		// 打开试题模板列表
		$x("//tr[.//td[text()='" + taskName + "']]/td/a[text()='试题']").click();
		// 打开评改页面
		we = $x("//a[contains(@class,'list-grade')]");
		if(null == we){
			we = $x("//a[contains(@class,'paper-grade')]");
		}
		we.click();
		// 选取试卷
		we = $x("//h4[contains(text(),'" + userName + "')]");
		if(null != we){
			we.click();
		}
		// 评改试题
		wes = $xs("//a[@title='正确']");
		for (int i = 0; i < wes.size(); i++) {
			wes.get(i).click();
		}
		// 提交评分
		$("button#Grade").click();
		// 验证分数
		Thread.sleep(1000);
		we = $x("//div[@class='layui-layer-content']/span[@class='score']");
		score = we.getText();
		System.out.println("New Score is '" + score + "'");
		assertTrue(score.equals(expectedScore));
		// 结束评分
		$("button#GradeFinish").click();
		wd.switchTo().alert().accept();
		// 验证页面
		Assert.assertTrue($wex("//nav[@class='breadcrumb']").text().contains("试卷模板"));

		return true;
	}

	protected Boolean inputAnswer(String taskName) throws InterruptedException {

		String containerId, qType, qId;
		WebElement we;

		// 进入考试
		openExaminationCenter("未");
		Thread.sleep(1000);
		$x("//tr[.//td[text()='" + taskName + "']]/td/a[text()='进入考试']").click();

		while (true) {

			// 录入答案
			we = $x("//div[contains(@class,'question-container-active')]");
			containerId = we.getAttribute("id");
			we = $x("//div[@id='" + containerId + "']/div/div[contains(@class,'swiper-slide-active')]");
			qType = we.getAttribute("data-question-type");
			qId = we.getAttribute("data-question-id");
			Thread.sleep(500);
			inputQuestionAnswer(qType, qId);

			// 点击下一题
			we = $x("//div[@id='" + containerId + "']/div/button[contains(@class,'swiper-button-next-question')]");
			if (we.getAttribute("class").contains("disabled")) {
				break;
			} else {
				we.click();
			}
		}

		// 交卷
		$x("//div[@id='" + containerId + "']/div/button[contains(@class,'paper-hand-in')]").click();
		wd.switchTo().alert().accept();

		return true;
	}

	protected Boolean inputAnswer(String taskName, String taskType) throws InterruptedException {

		String containerId, qType, qId;
		WebElement we;

		// 进入考试
		if (taskType == "考试") {
			openExaminationCenter("未");
			Thread.sleep(1000);
			$x("//tr[.//td[text()='" + taskName + "']]/td/a[text()='进入考试']").click();
		} else/* if("练习") */ {
			openExerciseCenter("练习列表");
			Thread.sleep(1000);
			$x("//tr[.//td[text()='" + taskName + "']]/td/a[text()='进入练习']").click();
			Thread.sleep(1000);
			$x("//div[@class='layui-layer-btn']/a[text()='是']").click();
		}

		while (true) {

			// 录入答案
			we = $x("//div[contains(@class,'question-container-active')]");
			containerId = we.getAttribute("id");
			we = $x("//div[@id='" + containerId + "']/div/div[contains(@class,'swiper-slide-active')]");
			qType = we.getAttribute("data-question-type");
			qId = we.getAttribute("data-question-id");
			Thread.sleep(500);
			inputQuestionAnswer(qType, qId);

			// 点击下一题
			we = $x("//div[@id='" + containerId + "']/div/button[contains(@class,'swiper-button-next-question')]");
			if (we.getAttribute("class").contains("disabled")) {
				break;
			} else {
				we.click();
			}
		}

		// 交卷
		$x("//div[@id='" + containerId + "']/div/button[contains(@class,'paper-hand-in')]").click();
		wd.switchTo().alert().accept();
		Thread.sleep(3000);
		wd.switchTo().alert().accept();

		return true;
	}

	protected Boolean inputQuestionAnswer(String qType, String qId) {

		WebElement we;

		switch (qType) {
		case "单选题":
		case "判断题":
			we = $x("//input[@name='question_radios_" + qId + "']");
			if (!we.isSelected()) {
				we.click();
			}
			break;
		case "多选题":
			we = $x("//input[@name='question_checkboxs_" + qId + "']");
			if (!we.isSelected()) {
				we.click();
			}
			break;
		case "公文改错题":
		case "案例分析题":
		case "计算题":
		case "问答题":
			we = $x("//textarea[@name='question_textarea_" + qId + "']");
			we.clear();
			we.sendKeys(qType + "答案" + qId + "。");
			break;
		default:
			return false;
		}

		return true;
	}

}
